//
//  VideoEffectManager.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2019/12/17.
//  Copyright © 2019 The E&M. All rights reserved.
//
import AVFoundation
import CoreImage
import Foundation
import HaishinKit

/// Haishikit 없을경우 쓸 용도.
//open class VideoEffect: NSObject {
//    open var ciContext: CIContext?
//    open func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
//        return image
//    }
//}

extension CIImage {
    static func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        // Core Image Context 생성 연결
        let defaultOptions: [CIContextOption: AnyObject] = [
            CIContextOption.workingColorSpace : NSNull(),
            CIContextOption.useSoftwareRenderer : NSNumber(value: false)
        ]
        let context = CIContext(options: defaultOptions)
        return context.createCGImage(inputImage, from: inputImage.extent)
    }
}

public class VideoEffectManager: NSObject {
    
    let lockQueue = DispatchQueue(label: "tv.celuv.asp.ios.VideoEffectManager.lock")
    
    // MARK: - 픽셀버퍼관련
    /// 픽셀버퍼 기본 속성
    static let defaultAttributes: [NSString: NSObject] = [
        kCVPixelBufferPixelFormatTypeKey: NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange),
        kCVPixelBufferMetalCompatibilityKey: kCFBooleanTrue,
        kCVPixelBufferOpenGLESCompatibilityKey: kCFBooleanTrue
    ]
    
    /// 픽셀버퍼풀 생성 속성값들
    private var attributes: [NSString: NSObject] {
        var attributes: [NSString: NSObject] = VideoEffectManager.defaultAttributes
        attributes[kCVPixelBufferWidthKey] = NSNumber(value: Int(extent.width))
        attributes[kCVPixelBufferHeightKey] = NSNumber(value: Int(extent.height))
        return attributes
    }
    
    /// 픽셀버퍼
    private var _pixelBufferPool: CVPixelBufferPool?
    private var pixelBufferPool: CVPixelBufferPool! {
        get {
            if _pixelBufferPool == nil {
                var pixelBufferPool: CVPixelBufferPool?
                CVPixelBufferPoolCreate(nil, nil, attributes as CFDictionary?, &pixelBufferPool)
                _pixelBufferPool = pixelBufferPool
            }
            return _pixelBufferPool!
        }
        set {
            _pixelBufferPool = newValue
        }
    }
    
    var context: CIContext? {
        didSet {
            for effect in effects {
                effect.ciContext = context
            }
        }
    }
    
    /// 캡쳐비디오 방향값.
    #if os(iOS) || os(macOS)
    var orientation: AVCaptureVideoOrientation = .portrait
    #endif
    
    /// 영상효과체인
    private(set) var effects: Set<VideoEffect> = []
    private var extent = CGRect.zero {
        didSet {
            guard extent != oldValue else {
                return
            }
            pixelBufferPool = nil
        }
    }
    
    // MARK:- 영상효과 관련
    /// 영상효과를 추가한다.
    /// - Note: 영상효과 체인에 새 효과를 추가한다.
    /// - Warning: effect:ciContext 는 현재 사용치 않으므로 nil처리함.
    func registerEffect(_ effect: VideoEffect) -> Bool {
        effect.ciContext = nil
        return effects.insert(effect).inserted
    }
    
    /// 등록된 영상효과를 제거한다.
    /// - Note: 영상효과 체인에서 해당 효과를 제거한다.
    func unregisterEffect(_ effect: VideoEffect) -> Bool {
        effect.ciContext = nil
        return effects.remove(effect) != nil
    }
    
    /// 영상효과 적용 출력
    /// - Note: 현재 효과셋 요소들을 순차적으로 모두 적용하여 최종이미지를 리턴한다.
    /// - Parameters:
    ///     - input: 입력된 이미지
    @inline(__always)
    func applayAllEffect(input: CIImage) -> CIImage? {
        var applyImage = input
        for effect in effects {
            applyImage = effect.execute(applyImage, info: nil)
        }
        return applyImage
    }
    /// 영상효과 적용 출력
    /// - Note: 영상이미지버퍼 값등을 인자를 받아와 영상효과체인을 적용하여 최종이미지를 리턴한다.
    /// - Warning: AVCaptureVideoDataOutputSampleBufferDelegate 연결시 적용할 수 있다.
    @inline(__always)
    func effect(_ buffer: CVImageBuffer, info: CMSampleBuffer?) -> CIImage {
        var image = CIImage(cvPixelBuffer: buffer)
        for effect in effects {
            image = effect.execute(image, info: info)
        }
        return image
    }
    
    
    /*
    /// <TEST 함수>
    /// 특정 이펙트 속성 업데이트 처리 .
    func updateEffectPos(up: Bool) {
        let effect = effects.first { (eff) -> Bool in
            if ((eff as? CurrentTimeEffect) != nil) {
                return true
            }
            return false
        }
        if let timeEffect = effect as? CurrentTimeEffect {
            timeEffect.updatePos(up: up)
        }
    }
    
    func getTimeEffect() -> CurrentTimeEffect? {
        
        let effect = effects.first { (eff) -> Bool in
            if ((eff as? CurrentTimeEffect) != nil) {
                return true
            }
            return false
        }
        
        if effect != nil {
            return effect as? CurrentTimeEffect
        }
        
        return nil
    } */
}
