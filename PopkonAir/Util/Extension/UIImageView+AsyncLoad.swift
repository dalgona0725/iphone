//
//  UIImage+AsyncLoad.swift
//  PopkonAir
//
//  Created by Steven on 10/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

extension UIImageView
{
    //aync Load Image
    func asynLoadImage(fromURL: String) {
        
        DispatchQueue.global().async {
            let image = URL(string: fromURL)
                .flatMap { (try? Data(contentsOf: $0)) }
                .flatMap { UIImage(data: $0) }
            
            if (image != nil){
                DispatchQueue.main.async {
                    self.image = image
                }
            }else {
                DispatchQueue.main.async {
                    self.image = nil
                }

            }
        }
    }
}


extension UIImage {
    
    // - Returns: An array of images.
    /// - Parameters:
    ///     - image: 조각낼 이미지 데이터
    ///     - removeTransparentPixel: 이미지내 빈 투명값을 상하를 줄일지 여부
    ///     - complete: 처리된후 콜백처리
    /// - Note: 이미지 분리가 끝나면 콜백함수 파라미터안에 해당 결과값을 보내서 처리한다.
    func slice(image: UIImage, removeTransparentPixel: Bool, complete: (@escaping ([UIImage])->Void) = { images in } ) {
        
        let width: CGFloat
        let height: CGFloat
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = image.size.height
            height = image.size.width
        default:
            width = image.size.width
            height = image.size.height
        }
        
        let maximunSpriteNums = Int( width / height )
        let tileWidth = Int(width / CGFloat(maximunSpriteNums))
        let scale = Int(image.scale)
        var images = [UIImage]()
        
        var x = 0
        let y = 0
        let tileSize = tileWidth * scale
        var tileHeight = tileWidth * scale
        var targetImage = image
        
        /// 비어있는 투명값 픽셀제거가 필요할 경우
        if removeTransparentPixel {
            if let compressedImage = self.imageByCroppingTransparentPixels(horizontal: false, vertical: true) {
                targetImage = compressedImage
                tileHeight = Int(compressedImage.size.height) * scale
            }
        }
        
        let size = CGSize(width: tileSize, height: tileHeight)
        for _ in 0 ..< maximunSpriteNums {
            let origin = CGPoint(x: x * scale, y: y * scale)
            let cropRect = CGRect(origin: origin, size: size)
            if let cropped = imageByCropping(imageToCrop: targetImage, toRect: cropRect) {
                images.append(cropped)
            }
            x += tileWidth
        }
        complete( images )
    }
    
    // - Returns: An array of images.
    ///
    /// - Note: The order of the images that are returned will correspond
    ///         to the `imageOrientation` of the image. If the image's
    ///         `imageOrientation` is not `.up`, take care interpreting
    ///         the order in which the tiled images are returned.
    func slice(image: UIImage, into howMany: Int = 0 ) -> [UIImage] {
        let width: CGFloat
        let height: CGFloat
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = image.size.height
            height = image.size.width
        default:
            width = image.size.width
            height = image.size.height
        }
        
        var maximunSpriteNums = howMany
        if howMany == 0 {
            maximunSpriteNums = Int( width / height )
        }
        
        let tileWidth = Int(width / CGFloat(maximunSpriteNums))
        //let tileHeight = Int(height) // / CGFloat(howMany))
        
        let scale = Int(image.scale)
        var images = [UIImage]()
        
        var x = 0
        let y = 0
        for _ in 0 ..< maximunSpriteNums {
            let tileSize = tileWidth * scale
            let origin = CGPoint(x: x * scale, y: y * scale)
            let size = CGSize(width: tileSize, height: tileSize)
            let cropRect = CGRect(origin: origin, size: size)
            if let cropped = imageByCropping(imageToCrop: image, toRect: cropRect) {
                images.append(cropped)
            }
            x += tileWidth
        }
        return images
    }
    
    // Image에서 필요한 영역만큼을 UIImage로 다시 생성한다.
    func imageByCropping(imageToCrop : UIImage, toRect: CGRect) -> UIImage? {
        UIGraphicsBeginImageContext(toRect.size)
        let currentContext = UIGraphicsGetCurrentContext()
        
        let clippedRect = CGRect(x: 0, y: 0, width: toRect.size.width, height: toRect.size.height)
        currentContext?.clip(to: clippedRect)
        let drawRect = CGRect(x: toRect.origin.x * -1, y: toRect.origin.y * -1, width: imageToCrop.size.width, height: imageToCrop.size.height)
        
        currentContext?.draw(imageToCrop.cgImage!, in: drawRect)
        let cropped = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        //return cropped?.sd_rotatedImage(withAngle: CGFloat(Double.pi), fitSize: false)
        return cropped?.sd_flippedImage(withHorizontal: false, vertical: true)
    }
    
}


extension UIImage {
    /// - 이미지빈영역을 제거하고 새로 이미지데이터를 만든다.
    func imageByCroppingTransparentPixels(horizontal: Bool, vertical: Bool) -> UIImage? {
        let rect = self.cropRectForImage(image: self,horizontal: horizontal, vertical: vertical)
        return cropImage(toRect: rect)
    }
    
    func cropImage(toRect rect:CGRect) -> UIImage? {
        var rect = rect
        rect.size.width = rect.width * self.scale
        rect.size.height = rect.height * self.scale
        guard let imageRef = self.cgImage?.cropping(to: rect) else {
            return nil
        }
        let croppedImage = UIImage(cgImage:imageRef)
        return croppedImage
    }
    
    func cropRectForImage(image:UIImage, horizontal: Bool, vertical: Bool) -> CGRect {
        if let imageAsCGImage = image.cgImage {
            let context:CGContext? = self.createARGBBitmapContext(inImage: imageAsCGImage)
            if let context = context {
                let width = Int(imageAsCGImage.width)
                let height = Int(imageAsCGImage.height)
                let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: CGFloat(width), height: CGFloat(height))
                context.draw(imageAsCGImage, in: rect)

                var lowX:Int = horizontal ? width : 0
                var highX:Int = horizontal ? 0 : width
                var lowY:Int = vertical ? height : 0
                var highY:Int = vertical ? 0: height
                
                if let data:UnsafeMutableRawPointer = context.data {
                    let opauePtr = OpaquePointer(data)
                    let dataType:UnsafeMutablePointer<UInt8>? = UnsafeMutablePointer<UInt8>(opauePtr)
                    if let dataType = dataType {
                        for y in 0..<height {
                            for x in 0..<width {
                                let pixelIndex:Int = (width * y + x) * 4 /* 4 for A, R, G, B */;
                                if (dataType[pixelIndex] != 0) { //Alpha value is not zero; pixel is not transparent.
                                    if horizontal {
                                        if (x < lowX) { lowX = x };
                                        if (x > highX) { highX = x };
                                    }
                                    
                                    if vertical {
                                        if (y < lowY) { lowY = y};
                                        if (y > highY) { highY = y};
                                    }
                                }
                            }
                        }
                    }
                    free(data)
                } else {
                    return CGRect.zero
                }
                return CGRect(x: CGFloat(lowX), y: CGFloat(lowY), width: CGFloat(highX-lowX), height: CGFloat(highY-lowY))
                
            }
        }
        return CGRect.zero
    }
    
    func createARGBBitmapContext(inImage: CGImage) -> CGContext {
        var bitmapByteCount = 0
        var bitmapBytesPerRow = 0
        
        //Get image width, height
        let pixelsWide = inImage.width
        let pixelsHigh = inImage.height
        
        // Declare the number of bytes per row. Each pixel in the bitmap in this
        // example is represented by 4 bytes; 8 bits each of red, green, blue, and
        // alpha.
        bitmapBytesPerRow = Int(pixelsWide) * 4
        bitmapByteCount = bitmapBytesPerRow * Int(pixelsHigh)
        
        // Use the generic RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        // Allocate memory for image data. This is the destination in memory
        // where any drawing to the bitmap context will be rendered.
        let bitmapData = malloc(bitmapByteCount)
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
        
        // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
        // per component. Regardless of what the source image format is
        // (CMYK, Grayscale, and so on) it will be converted over to the format
        // specified here by CGBitmapContextCreate.
        let context = CGContext(data: bitmapData, width: pixelsWide, height: pixelsHigh, bitsPerComponent: 8, bytesPerRow: bitmapBytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        return context!
    }
}
