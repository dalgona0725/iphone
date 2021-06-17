//
//  VideoEffect.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 7. 31..
//  Copyright © 2017년 roy. All rights reserved.
//

import HaishinKit
import UIKit
import Foundation
import AVFoundation

extension VideoEffect {
    @objc open func getEffectName() -> String {
        return "VideoEffect"
    }
    
    @objc open func isVideoEffect() -> Bool {
        return true
    }
}

final class CurrentTimeEffect: VideoEffect {
    
    let filter:CIFilter? = CIFilter(name: "CISourceOverCompositing")
    
    let label:UILabel = {
        let label:UILabel = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        return label
    }()
    
    override func getEffectName() -> String {
        return "CurrentTimeEffect"
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        let now:Date = Date()
        label.text = now.description
        
        UIGraphicsBeginImageContext(image.extent.size)
        label.drawText(in: CGRect(x: 0, y: 0, width: 200, height: 200))
        let result:CIImage = CIImage(image: UIGraphicsGetImageFromCurrentImageContext()!, options: nil)!
        UIGraphicsEndImageContext()
        
        filter!.setValue(result, forKey: "inputImage")
        filter!.setValue(image, forKey: "inputBackgroundImage")
        
        return filter!.outputImage!
    }
}

final class CIOverlayEffect: VideoEffect {
    let filter:CIFilter? = CIFilter(name: "CISourceOverCompositing")
    let scaleFilter:CIFilter? = CIFilter(name: "CILanczosScaleTransform")
    var effectScale: CGFloat = 1.0
    
    var extent:CGRect = CGRect.zero {
        didSet {
            if (extent == oldValue) {
                return
            }
            UIGraphicsBeginImageContext(extent.size)
            let image:UIImage = #imageLiteral(resourceName: "rankey_on_bott")
            image.draw(at: CGPoint(x: 50, y: 50))
            addCIImage = CIImage(image: UIGraphicsGetImageFromCurrentImageContext()!, options: nil)
            UIGraphicsEndImageContext()
        }
    }
    var addCIImage: CIImage?
    var addCgImage : CGImage?
    
    override init() {
        super.init()
    }
    
    override func isVideoEffect() -> Bool {
        return false
    }
    
    override func getEffectName() -> String {
        return "PronamaEffect"
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        guard let filter:CIFilter = filter else {
            return image
        }
        guard let scaleFilter:CIFilter = scaleFilter else {
            return image
        }
        
        //extent = image.extent
        if addCgImage == nil && addCIImage == nil {
            return image
        }
        
        if effectScale != 1.0 {
            scaleFilter.setValue(image, forKey: "inputImage")
            scaleFilter.setValue(effectScale, forKey: "inputScale")
            //scaleFilter.setValue(aspectRatio, forKey: "inputAspectRatio")
            if let scaleImage = scaleFilter.outputImage {
                filter.setValue(scaleImage, forKey: "inputBackgroundImage")
            }
        } else {
            filter.setValue(image, forKey: "inputBackgroundImage")
        }
        
        if addCgImage != nil {
            let ciImage = CIImage(cgImage: addCgImage!)
            filter.setValue(ciImage, forKey: "inputImage")
        } else if addCIImage != nil {
            filter.setValue(addCIImage!, forKey: "inputImage")
        }
        return filter.outputImage!
    }
}

final class CIOriginalEffect: VideoEffect {
    override func getEffectName() -> String {
        return I18N.filter_original.localized
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        return image
    }
}


final class CIMonochromeEffect: VideoEffect {
    let filter:CIFilter? = CIFilter(name: "CIColorMonochrome")
    
    override func getEffectName() -> String {
        return I18N.filter_black_white_i.localized
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        guard let filter:CIFilter = filter else {
            return image
        }
        filter.setValue(image, forKey: "inputImage")
        filter.setValue(CIColor(red: 0.75, green: 0.75, blue: 0.75), forKey: "inputColor")
        filter.setValue(1.0, forKey: "inputIntensity")
        return filter.outputImage!
    }
}

final class CIInstantEffect : VideoEffect {
    let filter:CIFilter? = CIFilter(name: "CIPhotoEffectInstant")
    
    override func getEffectName() -> String {
        return I18N.filter_vintage_i.localized
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        guard let filter:CIFilter = filter else {
            return image
        }
        filter.setValue(image, forKey: "inputImage")
        return filter.outputImage!
    }
}


final class CIProcessEffect : VideoEffect {
    let filter:CIFilter? = CIFilter(name: "CIPhotoEffectProcess")
    
    override func getEffectName() -> String {
        return I18N.filter_vintage_ii.localized
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        guard let filter:CIFilter = filter else {
            return image
        }
        filter.setValue(image, forKey: "inputImage")
        return filter.outputImage!
    }
}

final class CIFadeEffect : VideoEffect {
    let filter:CIFilter? = CIFilter(name: "CIPhotoEffectFade")
    
    override func getEffectName() -> String {
        return I18N.filter_dark.localized
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        guard let filter:CIFilter = filter else {
            return image
        }
        filter.setValue(image, forKey: "inputImage")
        return filter.outputImage!
    }
}

final class CIMonoEffect : VideoEffect {
    let filter:CIFilter? = CIFilter(name: "CIPhotoEffectMono")
    
    override func getEffectName() -> String {
        return I18N.filter_black_white_ii.localized
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        guard let filter:CIFilter = filter else {
            return image
        }
        filter.setValue(image, forKey: "inputImage")
        return filter.outputImage!
    }
}

final class CITransferEffect : VideoEffect {
    let filter:CIFilter? = CIFilter(name: "CIPhotoEffectTransfer")
    
    override func getEffectName() -> String {
        return I18N.filter_warm_i.localized
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        guard let filter:CIFilter = filter else {
            return image
        }
        filter.setValue(image, forKey: "inputImage")
        return filter.outputImage!
    }
}

final class CIChromeEffect : VideoEffect {
    let filter:CIFilter? = CIFilter(name: "CIPhotoEffectChrome")
    
    override func getEffectName() -> String {
        return I18N.filter_warm_ii.localized
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        guard let filter:CIFilter = filter else {
            return image
        }
        filter.setValue(image, forKey: "inputImage")
        return filter.outputImage!
    }
}


final class CIReductionEffect : VideoEffect {
    let filter:CIFilter? = CIFilter(name: "CINoiseReduction")
    
    override func getEffectName() -> String {
        return "선명하게"
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        guard let filter:CIFilter = filter else {
            return image
        }
        filter.setValue(image, forKey: "inputImage")
        filter.setValue(0.2, forKey: "inputNoiseLevel")
        filter.setValue(1.0, forKey: "inputSharpness")
        return filter.outputImage!
    }
}


final class CIInvertEffect : VideoEffect {
    let filter:CIFilter? = CIFilter(name: "CIColorInvert")
    
    override func getEffectName() -> String {
        return "반전효과"
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        guard let filter:CIFilter = filter else {
            return image
        }
        filter.setValue(image, forKey: "inputImage")
        return filter.outputImage!
    }
}

final class CIFaceBalanceEffect : VideoEffect {
    let filter:CIFilter? = CIFilter(name: "CIFaceBalance")
    
    override func getEffectName() -> String {
        return "얼굴밝게"
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        guard let filter:CIFilter = filter else {
            return image
        }
        filter.setValue(image, forKey: "inputImage")
        return filter.outputImage!
    }
}

final class CIGaussianBlurEffect : VideoEffect {
    let filter:CIFilter? = CIFilter(name: "CIGaussianBlur")
    
    override func getEffectName() -> String {
        return "뽀샤시I"
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        guard let filter:CIFilter = filter else {
            return image
        }
        filter.setValue(image, forKey: "inputImage")
        filter.setValue(1.0, forKey: "inputRadius")
        return filter.outputImage!
    }
}

final class CIMedianFilterEffect : VideoEffect {
    let filter:CIFilter? = CIFilter(name: "CIMedianFilter")
    
    override func getEffectName() -> String {
        return "뽀샤시II"
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        guard let filter:CIFilter = filter else {
            return image
        }
        filter.setValue(image, forKey: "inputImage")
        return filter.outputImage!
    }
}


final class CIOverlayHelperEffect: VideoEffect {
    let filter:CIFilter? = CIFilter(name: "CISourceOverCompositing")
    var extent:CGRect = CGRect.zero {
        didSet {
            if (extent == oldValue) {
                return
            }
            UIGraphicsBeginImageContext(extent.size)
            let image:UIImage = #imageLiteral(resourceName: "rankey_on_bott")
            image.draw(at: CGPoint(x: 50, y: 50))
            addCIImage = CIImage(image: UIGraphicsGetImageFromCurrentImageContext()!, options: nil)
            UIGraphicsEndImageContext()
        }
    }
    var addCIImage: CIImage?
    var key: Int = 0
    
    override init() {
        super.init()
    }
    
    override func isVideoEffect() -> Bool {
        return false
    }
    
    override func getEffectName() -> String {
        return "HelperEffect"
    }
    
    override func execute(_ image: CIImage, info: CMSampleBuffer?) -> CIImage {
        guard let filter:CIFilter = filter else {
            return image
        }
        //extent = image.extent
        guard let inputImage = addCIImage else {
            return image
        }
        
        filter.setValue(image, forKey: "inputBackgroundImage")
        filter.setValue(inputImage, forKey: "inputImage")
        
        return filter.outputImage!
    }
}




