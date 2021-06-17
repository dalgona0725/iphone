//
//  DLGPlayer.m
//  DLGPlayer
//
//  Created by Liu Junqi on 09/12/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#import "DLGPlayer.h"
#import "DLGPlayerView.h"
#import "DLGPlayerDecoder.h"
#import "DLGPlayerDef.h"
#import "DLGPlayerAudioManager.h"
#import "DLGPlayerFrame.h"
#import "DLGPlayerVideoFrame.h"
#import "DLGPlayerAudioFrame.h"

@interface DLGPlayer ()

@property (nonatomic, strong) DLGPlayerView *view;
@property (nonatomic, strong) DLGPlayerDecoder *decoder;
@property (nonatomic, strong) DLGPlayerAudioManager *audio;

@property (nonatomic, strong) NSMutableArray *vframes;
@property (nonatomic, strong) NSMutableArray *aframes;
@property (nonatomic, strong) DLGPlayerAudioFrame *playingAudioFrame;
@property (nonatomic) NSUInteger playingAudioFrameDataPosition;
@property (nonatomic) double bufferedDuration;
@property (nonatomic) double mediaPosition;
@property (nonatomic) double mediaSyncTime;
@property (nonatomic) double mediaSyncPosition;

@property (nonatomic, strong) NSThread *frameReaderThread;
@property (nonatomic) BOOL notifiedBufferStart;
@property (nonatomic) BOOL requestSeek;
@property (nonatomic) double requestSeekPosition;
@property (nonatomic) BOOL opening;

@property (nonatomic) BOOL sendPlayStarted;

@property (nonatomic, strong) dispatch_semaphore_t vFramesLock;
@property (nonatomic, strong) dispatch_semaphore_t aFramesLock;

@end

@implementation DLGPlayer

- (id)init {
    self = [super init];
    if (self) {
        [self initAll];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"DLGPlayer dealloc");
}

- (void)initAll {
    [self initVars];
    [self initAudio];
    [self initDecoder];
    [self initView];
}

- (void)initVars {
    self.minBufferDuration = DLGPlayerMinBufferDuration;
    self.maxBufferDuration = DLGPlayerMaxBufferDuration;
    self.bufferedDuration = 0;
    self.mediaPosition = 0;
    self.mediaSyncTime = 0;
    self.vframes = [NSMutableArray arrayWithCapacity:128];
    self.aframes = [NSMutableArray arrayWithCapacity:128];
    self.playingAudioFrame = nil;
    self.playingAudioFrameDataPosition = 0;
    self.opening = NO;
    self.buffering = NO;
    self.playing = NO;
    self.opened = NO;
    self.requestSeek = NO;
    self.requestSeekPosition = 0;
    self.frameReaderThread = nil;
    self.aFramesLock = dispatch_semaphore_create(1);
    self.vFramesLock = dispatch_semaphore_create(1);
    
    /// Add by Eugene
    self.sendPlayStarted = NO;
}

- (void)initView {
    DLGPlayerView *v = [[DLGPlayerView alloc] init];
    self.view = v;
}

- (void)initDecoder {
    self.decoder = [[DLGPlayerDecoder alloc] init];
}

- (void)initAudio {
    self.audio = [[DLGPlayerAudioManager alloc] init];
}

- (void)clearVars {
    [self.vframes removeAllObjects];
    [self.aframes removeAllObjects];
    self.playingAudioFrame = nil;
    self.playingAudioFrameDataPosition = 0;
    self.opening = NO;
    self.buffering = NO;
    self.playing = NO;
    self.opened = NO;
    self.bufferedDuration = 0;
    self.mediaPosition = 0;
    self.mediaSyncTime = 0;
    [self.view clear];
}

- (void)open:(NSString *)url {
    __weak typeof(self)weakSelf = self;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        NSError *error = nil;
        strongSelf.opening = YES;
        
        if ([strongSelf.audio open:&error]) {
            strongSelf.decoder.audioChannels = [strongSelf.audio channels];
            strongSelf.decoder.audioSampleRate = [strongSelf.audio sampleRate];
        } else {
            [strongSelf handleError:error];
        }
        
        if (![strongSelf.decoder open:url error:&error]) {
            strongSelf.opening = NO;
            [strongSelf handleError:error];
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            strongSelf.view.isYUV = [strongSelf.decoder isYUV];
            strongSelf.view.keepLastFrame = [strongSelf.decoder hasPicture] && ![strongSelf.decoder hasVideo];
            strongSelf.view.rotation = strongSelf.decoder.rotation;
            strongSelf.view.contentSize = CGSizeMake([strongSelf.decoder videoWidth], [strongSelf.decoder videoHeight]);
            strongSelf.view.contentMode = UIViewContentModeScaleAspectFit;
            
            strongSelf.duration = strongSelf.decoder.duration;
            strongSelf.metadata = strongSelf.decoder.metadata;
            strongSelf.opening = NO;
            strongSelf.buffering = NO;
            strongSelf.playing = NO;
            strongSelf.bufferedDuration = 0;
            strongSelf.mediaPosition = 0;
            strongSelf.mediaSyncTime = 0;
            
            if( strongSelf.decoder.hasVideo ) {
                double fps = strongSelf.decoder.videoFPS;
                self.minBufferDuration = DLGPlayerMinBufferDuration * (30.0/fps);
                self.maxBufferDuration = DLGPlayerMaxBufferDuration * (30.0/fps);
            }

            __weak typeof(strongSelf)ws = strongSelf;
            strongSelf.audio.frameReaderBlock = ^(float *data, UInt32 frames, UInt32 channels) {
                [ws readAudioFrame:data frames:frames channels:channels];
            };
            
            strongSelf.opened = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:DLGPlayerNotificationOpened object:strongSelf];
        });
    });
}

- (void)close {
    if (!self.opened && !self.opening) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DLGPlayerNotificationClosed object:self];
        return;
    }

    [self pause];
    [self.decoder prepareClose];

    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 0.1 * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);

    __weak typeof(self)weakSelf = self;

    dispatch_source_set_event_handler(timer, ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        if (strongSelf.opening || strongSelf.buffering) return;
        [strongSelf.decoder close];

        NSArray<NSError *> *errors = nil;
        if ([strongSelf.audio close:&errors]) {
            [strongSelf clearVars];
            [[NSNotificationCenter defaultCenter] postNotificationName:DLGPlayerNotificationClosed object:strongSelf];
        } else {
            for (NSError *error in errors) {
                [strongSelf handleError:error];
            }
        }
        dispatch_cancel(timer);
    });
    dispatch_resume(timer);
}

- (void)play {
    if (!self.opened || self.playing) return;
    
    self.playing = YES;
    __weak typeof(self)weakSelf = self;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }

        [strongSelf render];
        [strongSelf startFrameReaderThread];
    });

    NSError *error = nil;
    if (self.decoder.hasAudio) {
        if (![self.audio play:&error]) {
            [self handleError:error];
        }
    }
}

- (void)pause {
    self.playing = NO;
    self.sendPlayStarted = NO;
    NSError *error = nil;

    if (![self.audio pause:&error]) {
        [self handleError:error];
    }
}

- (void)startFrameReaderThread {
    if (self.frameReaderThread == nil) {
        self.frameReaderThread = [[NSThread alloc] initWithTarget:self selector:@selector(runFrameReader) object:nil];
        [self.frameReaderThread start];
    }
}

- (void)runFrameReader {
    @autoreleasepool {
        while (self.playing) {
            [self readFrame];
            if (self.requestSeek) {
                [self seekPositionInFrameReader];
            } else {
                [NSThread sleepForTimeInterval:1.5];
            }
        }
        self.frameReaderThread = nil;
    }
}

- (void)readFrame {
    self.buffering = YES;
    
    NSMutableArray *tempVFrames = [NSMutableArray arrayWithCapacity:8];
    NSMutableArray *tempAFrames = [NSMutableArray arrayWithCapacity:8];
    double tempDuration = 0;
    dispatch_time_t t = dispatch_time(DISPATCH_TIME_NOW, 0.02 * NSEC_PER_SEC);
    
    while (self.playing && !self.decoder.isEOF && !self.requestSeek
           && (self.bufferedDuration + tempDuration) < self.maxBufferDuration) {
        @autoreleasepool {
            NSArray *fs = [self.decoder readFrames];
            if (fs == nil) { break; }
            if (fs.count == 0) { continue; }
            
            {
                for (DLGPlayerFrame *f in fs) {
                    if (f.type == kDLGPlayerFrameTypeVideo) {
                        [tempVFrames addObject:f];
                        tempDuration += f.duration;
                    }
                }
                
                long timeout = dispatch_semaphore_wait(self.vFramesLock, t);
                if (timeout == 0) {
                    if (tempVFrames.count > 0) {
                        self.bufferedDuration += tempDuration;
                        tempDuration = 0;
                        [self.vframes addObjectsFromArray:tempVFrames];
                        [tempVFrames removeAllObjects];
                    }
                    dispatch_semaphore_signal(self.vFramesLock);
                }
            }
            {
                for (DLGPlayerFrame *f in fs) {
                    if (f.type == kDLGPlayerFrameTypeAudio) {
                        [tempAFrames addObject:f];
                        if (!self.decoder.hasVideo) {
                            tempDuration += f.duration;
                        }
                    }
                }
                
                long timeout = dispatch_semaphore_wait(self.aFramesLock, t);
                if (timeout == 0) {
                    if (tempAFrames.count > 0) {
                        // added by Eugene
                        // readerBlock 일 nil경우 해당 audio buffer 데이터 처리를 하지 못하니, 계속 쌓지않게 한다.
                        // 일시적으로 무음상태가 발생할 수 있지만 메모리 안전상 해당 버퍼를 누적시키지 않는다.,
                        if(_audio.frameReaderBlock != nil ) {
                            if (!self.decoder.hasVideo) {
                                self.bufferedDuration += tempDuration;
                                tempDuration = 0;
                            }
                            [self.aframes addObjectsFromArray:tempAFrames];
                        }
                        [tempAFrames removeAllObjects];
                    }
                    dispatch_semaphore_signal(self.aFramesLock);
                }
            }
        }
    }
    
    {
        // add the rest video frames
        while (tempVFrames.count > 0 || tempAFrames.count > 0) {
            if (tempVFrames.count > 0) {
                long timeout = dispatch_semaphore_wait(self.vFramesLock, t);
                if (timeout == 0) {
                    self.bufferedDuration += tempDuration;
                    tempDuration = 0;
                    [self.vframes addObjectsFromArray:tempVFrames];
                    [tempVFrames removeAllObjects];
                    dispatch_semaphore_signal(self.vFramesLock);
                }
            }
            if (tempAFrames.count > 0) {
                long timeout = dispatch_semaphore_wait(self.aFramesLock, t);
                if (timeout == 0) {
                    if (!self.decoder.hasVideo) {
                        self.bufferedDuration += tempDuration;
                        tempDuration = 0;
                    }
                    [self.aframes addObjectsFromArray:tempAFrames];
                    [tempAFrames removeAllObjects];
                    dispatch_semaphore_signal(self.aFramesLock);
                }
            }
        }
    }
    
    self.buffering = NO;
}

- (void)seekPositionInFrameReader {
    [self.decoder seek:self.requestSeekPosition];

    {
        dispatch_semaphore_wait(self.vFramesLock, DISPATCH_TIME_FOREVER);
        [self.vframes removeAllObjects];
        dispatch_semaphore_signal(self.vFramesLock);
    }
    {
        dispatch_semaphore_wait(self.aFramesLock, DISPATCH_TIME_FOREVER);
        [self.aframes removeAllObjects];
        dispatch_semaphore_signal(self.aFramesLock);
    }

    self.bufferedDuration = 0;
    self.requestSeek = NO;
    self.mediaSyncTime = 0;
    self.mediaPosition = self.requestSeekPosition;
}

- (void)render {
    if (!self.playing) return;

    BOOL eof = self.decoder.isEOF;
    BOOL noframes = YES;
    // Video and Audio
    if (self.decoder.hasVideo) {
        if (self.decoder.hasAudio) {
            noframes = (self.vframes.count <= 0) && (self.aframes.count <= 0);
        } else {
            noframes = (self.vframes.count <= 0);
        }
    } else if (self.decoder.hasAudio) {
        // only Audio
        noframes = (self.aframes.count <= 0);
    }
    
    // Check if reach the end and play all frames.
    if (noframes && eof) {
        [self pause];
        [[NSNotificationCenter defaultCenter] postNotificationName:DLGPlayerNotificationEOF object:self];
        return;
    }
    
    if (noframes && !self.notifiedBufferStart) {
        self.notifiedBufferStart = YES;
        NSDictionary *userInfo = @{ DLGPlayerNotificationBufferStateKey : @(self.notifiedBufferStart) };
        [[NSNotificationCenter defaultCenter] postNotificationName:DLGPlayerNotificationBufferStateChanged object:self userInfo:userInfo];
    } else if (!noframes && self.notifiedBufferStart && self.bufferedDuration >= self.minBufferDuration) {
        self.notifiedBufferStart = NO;
        NSDictionary *userInfo = @{ DLGPlayerNotificationBufferStateKey : @(self.notifiedBufferStart) };
        [[NSNotificationCenter defaultCenter] postNotificationName:DLGPlayerNotificationBufferStateChanged object:self userInfo:userInfo];
    }
    
    // Render if has picture
    if (self.decoder.hasPicture && self.vframes.count > 0) {
        DLGPlayerVideoFrame *frame = self.vframes[0];
        self.view.contentSize = CGSizeMake(frame.width, frame.height);
        [self.vframes removeObjectAtIndex:0];
        [self.view render:frame];
    }
    
    // Check whether render is neccessary
    if (self.vframes.count <= 0 || !self.decoder.hasVideo || self.notifiedBufferStart) {
        __weak typeof(self)weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf render];
        });
        return;
    }
    
    // Render video
    DLGPlayerVideoFrame *frame = nil;
    {
        long timeout = dispatch_semaphore_wait(self.vFramesLock, DISPATCH_TIME_NOW);
        if (timeout == 0) {
            frame = self.vframes[0];
            self.mediaPosition = frame.position;
            self.bufferedDuration -= frame.duration;
            [self.vframes removeObjectAtIndex:0];
            dispatch_semaphore_signal(self.vFramesLock);
        }
    }
    [self.view render:frame];
    
    // Sync audio with video
    double syncTime = [self syncTime];
    NSTimeInterval t = MAX(frame.duration + syncTime, 0.01);

    __weak typeof(self)weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(t * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf render];
    });
    
    /// 정지상태에서 다시 플레이 재개 되었을때
    if (!self.sendPlayStarted && !self.requestSeek) {
        self.sendPlayStarted = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:DLGPlayerNotificationPlayStarted object:self];
    }
}

- (double)syncTime {
    const double now = [NSDate timeIntervalSinceReferenceDate];
    
    if (self.mediaSyncTime == 0) {
        self.mediaSyncTime = now;
        self.mediaSyncPosition = self.mediaPosition;
        return 0;
    }
    
    double dp = self.mediaPosition - self.mediaSyncPosition;
    double dt = now - self.mediaSyncTime;
    double sync = dp - dt;
    
    if (sync > 1 || sync < -1) {
        sync = 0;
        self.mediaSyncTime = 0;
    }
    
    return sync;
}

/*
 * For audioUnitRenderCallback, (DLGPlayerAudioManagerFrameReaderBlock)readFrameBlock
 */
- (void)readAudioFrame:(float *)data frames:(UInt32)frames channels:(UInt32)channels {
    if (!self.playing) return;

    while(frames > 0) {
        @autoreleasepool {
            if (self.playingAudioFrame == nil) {
                {
                    if (self.aframes.count <= 0) {
                        memset(data, 0, frames * channels * sizeof(float));
                        return;
                    }
                    
                    long timeout = dispatch_semaphore_wait(self.aFramesLock, DISPATCH_TIME_NOW);
                    if (timeout == 0) {
                        DLGPlayerAudioFrame *frame = self.aframes[0];
                        if (self.decoder.hasVideo) {
                            const double dt = self.mediaPosition - frame.position;
                            if (dt < -0.1) { // audio is faster than video, silence
                                memset(data, 0, frames * channels * sizeof(float));
                                dispatch_semaphore_signal(self.aFramesLock);
                                break;
                            } else if (dt > 0.1) { // audio is slower than video, skip
                                [self.aframes removeObjectAtIndex:0];
                                dispatch_semaphore_signal(self.aFramesLock);
                                continue;
                            } else {
                                self.playingAudioFrameDataPosition = 0;
                                self.playingAudioFrame = frame;
                                [self.aframes removeObjectAtIndex:0];
                            }
                        } else {
                            self.playingAudioFrameDataPosition = 0;
                            self.playingAudioFrame = frame;
                            [self.aframes removeObjectAtIndex:0];
                            self.mediaPosition = frame.position;
                            self.bufferedDuration -= frame.duration;
                        }
                        dispatch_semaphore_signal(self.aFramesLock);
                    } else return;
                }
            }
            
            NSData *frameData = self.playingAudioFrame.data;
            NSUInteger pos = self.playingAudioFrameDataPosition;
            if (frameData == nil) {
                memset(data, 0, frames * channels * sizeof(float));
                return;
            }
            
            const void *bytes = (Byte *)frameData.bytes + pos;
            const NSUInteger remainingBytes = frameData.length - pos;
            const NSUInteger channelSize = channels * sizeof(float);
            const NSUInteger bytesToCopy = MIN(frames * channelSize, remainingBytes);
            const NSUInteger framesToCopy = bytesToCopy / channelSize;
            
            memcpy(data, bytes, bytesToCopy);
            frames -= framesToCopy;
            data += framesToCopy * channels;
            
            if (bytesToCopy < remainingBytes) {
                self.playingAudioFrameDataPosition += bytesToCopy;
            } else {
                self.playingAudioFrame = nil;
            }
        }
    }
}

- (UIView *)playerView {
    return self.view;
}

/// 영상 플레이 위치 변경시
- (void)setPosition:(double)position {
    self.requestSeekPosition = position;
    self.requestSeek = YES;
    self.sendPlayStarted = NO;
}

/// 현재 영상 위치 리턴
- (double)position {
    return self.mediaPosition;
}
    
/// 위치 변경
- (void)requestSeekPostion {
    if (self.requestSeek) {
        [self seekPositionInFrameReader];
    }
}

/// EOF여부 리턴
- (BOOL)isEOF {
    return self.decoder.isEOF;
}

// added by Eugene
- (void) enableAudio:(BOOL)on
{
    __weak typeof(self)weakSelf = self;
    if (on && self.decoder.hasAudio ) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf)strongSelf = weakSelf;
            if (!strongSelf) {
                return;
            }
            
            __weak typeof(strongSelf)ws = strongSelf;
            strongSelf.audio.frameReaderBlock = ^(float *data, UInt32 frames, UInt32 channels) {
                [ws readAudioFrame:data frames:frames channels:channels];
            };
            [strongSelf.audio play];
        });
    } else {
        if ( [_audio pause] ) {
            _audio.frameReaderBlock = nil;
            
            if (self.aframes.count > 0 ) {
                [self.aframes removeAllObjects];
            }
        }
    }
}
    
- (float) videoAspect {
    if( _decoder ) {
        return (float)self.decoder.videoWidth / (float)self.decoder.videoHeight;
    }
    return 0.0;
}
    
- (CGSize) videoSize {
    if( _decoder ) {
        return CGSizeMake(self.decoder.videoWidth, self.decoder.videoHeight);
    }
    return CGSizeZero;
}

    /// audioManager:unregisterNotifications 호출한다.
- (void) clearAudioSession {
    if( _audio ) {
        [_audio destoryObserver];
    }
}

#pragma mark - Handle Error
- (void)handleError:(NSError *)error {
    if (error == nil) return;
    NSDictionary *userInfo = @{ DLGPlayerNotificationErrorKey : error };
    [[NSNotificationCenter defaultCenter] postNotificationName:DLGPlayerNotificationError object:self userInfo:userInfo];
}

@end
