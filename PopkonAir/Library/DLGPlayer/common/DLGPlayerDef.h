//
//  DLGPlayerDef.h
//  DLGPlayer
//
//  Created by Liu Junqi on 05/12/2016.
//  Copyright © 2016 Liu Junqi. All rights reserved.
//

#ifndef DLGPlayerDef_h
#define DLGPlayerDef_h

#define DLGPlayerLocalizedStringTable   @"DLGPlayerStrings"

#define DLGPlayerMinBufferDuration  3
#define DLGPlayerMaxBufferDuration  5

#define DLGPlayerErrorDomainDecoder         @"DLGPlayerDecoder"
#define DLGPlayerErrorDomainAudioManager    @"DLGPlayerAudioManager"

#define DLGPlayerErrorCodeInvalidURL                        -1
#define DLGPlayerErrorCodeCannotOpenInput                   -2
#define DLGPlayerErrorCodeCannotFindStreamInfo              -3
#define DLGPlayerErrorCodeNoVideoAndAudioStream             -4

#define DLGPlayerErrorCodeNoAudioOuput                      -5
#define DLGPlayerErrorCodeNoAudioChannel                    -6
#define DLGPlayerErrorCodeNoAudioSampleRate                 -7
#define DLGPlayerErrorCodeNoAudioVolume                     -8
#define DLGPlayerErrorCodeCannotSetAudioCategory            -9
#define DLGPlayerErrorCodeCannotSetAudioActive              -10
#define DLGPlayerErrorCodeCannotInitAudioUnit               -11
#define DLGPlayerErrorCodeCannotCreateAudioComponent        -12
#define DLGPlayerErrorCodeCannotGetAudioStreamDescription   -13
#define DLGPlayerErrorCodeCannotSetAudioRenderCallback      -14
#define DLGPlayerErrorCodeCannotUninitAudioUnit             -15
#define DLGPlayerErrorCodeCannotDisposeAudioUnit            -16
#define DLGPlayerErrorCodeCannotDeactivateAudio             -17
#define DLGPlayerErrorCodeCannotStartAudioUnit              -18
#define DLGPlayerErrorCodeCannotStopAudioUnit               -19

#pragma mark - Notification
// 영상 스트림 연결이 되었을때
#define DLGPlayerNotificationOpened                 @"DLGPlayerNotificationOpened"
// 영상 스트림 닫기 처리가 되었을때
#define DLGPlayerNotificationClosed                 @"DLGPlayerNotificationClosed"
// 프레임이 다 플레이하고, EOF 일경우
#define DLGPlayerNotificationEOF                    @"DLGPlayerNotificationEOF"
// 버퍼링이 시작되거나 끝났을 때
#define DLGPlayerNotificationBufferStateChanged     @"DLGPlayerNotificationBufferStateChanged"
#define DLGPlayerNotificationError                  @"DLGPlayerNotificationError"
// 영상 플레이 호출후 첫렌더링 처리 될때 알림
#define DLGPlayerNotificationPlayStarted            @"DLGPlayerNotificationPlayStarted"

#pragma mark - Notification Key
#define DLGPlayerNotificationBufferStateKey         @"DLGPlayerNotificationBufferStateKey"
#define DLGPlayerNotificationSeekStateKey           @"DLGPlayerNotificationSeekStateKey"
#define DLGPlayerNotificationErrorKey               @"DLGPlayerNotificationErrorKey"
#define DLGPlayerNotificationRawErrorKey            @"DLGPlayerNotificationRawErrorKey"

#endif /* DLGPlayerDef_h */
