//
//  GLCasterView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2019/12/17.
//  Copyright © 2019 The E&M. All rights reserved.
//

import AVFoundation
import GLKit

protocol NetStreamDrawable: class {
#if os(iOS) || os(macOS)
    var orientation: AVCaptureVideoOrientation { get set }
    var position: AVCaptureDevice.Position { get set }
#endif
    func draw(image: CIImage)
    // Added by Eugene
    func cameraRawStream(_ buffer:CVImageBuffer)
}

open class GLCasterView: GLKView {
    static let defaultOptions: [String: AnyObject] = [
        convertFromCIContextOption(CIContextOption.workingColorSpace): NSNull(),
        convertFromCIContextOption(CIContextOption.useSoftwareRenderer): NSNumber(value: false)
    ]
    public static var defaultBackgroundColor: UIColor = .black
    open var videoGravity: AVLayerVideoGravity = .resizeAspect
    
    var position: AVCaptureDevice.Position = .back
    var orientation: AVCaptureVideoOrientation = .portrait
    
    private var displayImage: CIImage?
    private weak var currentEffectManger: VideoEffectManager?
    
    override public init(frame: CGRect) {
        super.init(frame: frame, context: EAGLContext(api: .openGLES2)!)
        awakeFromNib()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.context = EAGLContext(api: .openGLES2)!
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        enableSetNeedsDisplay = true
        backgroundColor = GLCasterView.defaultBackgroundColor
        layer.backgroundColor = GLCasterView.defaultBackgroundColor.cgColor
    }
    
    open func attachCastScreen(_ manager: VideoEffectManager?) {
        if let manager = manager {
            manager.context =  CIContext(eaglContext: context, options: convertToOptionalCIContextOptionDictionary(GLCasterView.defaultOptions))
            manager.lockQueue.async {
                //self.position = manager.orientation
            }
        }
        currentEffectManger = manager
    }
    
    // added by Eugene
    var unEffectCameraCgImage : CGImage?
    open func getCgImageWithoutEffect() -> CGImage? {
        return unEffectCameraCgImage
    }
}

extension GLCasterView: GLKViewDelegate {
    // MARK: GLKViewDelegate
    public func glkView(_ view: GLKView, drawIn rect: CGRect) {
        glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
        guard let displayImage: CIImage = displayImage else {
            return
        }
        var inRect = CGRect(x: 0, y: 0, width: CGFloat(drawableWidth), height: CGFloat(drawableHeight))
        var fromRect: CGRect = displayImage.extent
        VideoGravityUtil.calculate(videoGravity, inRect: &inRect, fromRect: &fromRect)
        if position == .front {
            currentEffectManger?.context?.draw(displayImage.oriented(forExifOrientation: 1), in: inRect, from: fromRect)
        } else {
            currentEffectManger?.context?.draw(displayImage, in: inRect, from: fromRect)
        }
    }
}

extension GLCasterView: NetStreamDrawable {
    // MARK: NetStreamDrawable
    func draw(image: CIImage) {
        DispatchQueue.main.async {
            self.displayImage = image
            self.setNeedsDisplay()
        }
    }
    
    // added by Eugene
    func cameraRawStream(_ buffer: CVImageBuffer) {
        let image = CIImage(cvImageBuffer: buffer)
        unEffectCameraCgImage = convertCIImageToCGImage(inputImage: image)
    }
    open func convertCIImageToCGImage(inputImage: CIImage) -> CGImage? {
        currentEffectManger?.context?.createCGImage(inputImage, from: inputImage.extent)
        return nil
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromCIContextOption(_ input: CIContextOption) -> String {
    return input.rawValue
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToOptionalCIContextOptionDictionary(_ input: [String: Any]?) -> [CIContextOption: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (CIContextOption(rawValue: key), value) })
}

extension CGRect {
    var aspectRatio: CGFloat {
        return width / height
    }
}

final class VideoGravityUtil {
    @inline(__always)
    static func calculate(_ videoGravity: AVLayerVideoGravity, inRect: inout CGRect, fromRect: inout CGRect) {
        switch videoGravity {
        case .resizeAspect:
            resizeAspect(&inRect, fromRect: &fromRect)
        case .resizeAspectFill:
            resizeAspectFill(&inRect, fromRect: &fromRect)
        default:
            break
        }
    }

    @inline(__always)
    static func resizeAspect(_ inRect: inout CGRect, fromRect: inout CGRect) {
        let xRatio: CGFloat = inRect.width / fromRect.width
        let yRatio: CGFloat = inRect.height / fromRect.height
        if yRatio < xRatio {
            inRect.origin.x = (inRect.size.width - fromRect.size.width * yRatio) / 2
            inRect.size.width = fromRect.size.width * yRatio
        } else {
            inRect.origin.y = (inRect.size.height - fromRect.size.height * xRatio) / 2
            inRect.size.height = fromRect.size.height * xRatio
        }
    }

    @inline(__always)
    static func resizeAspectFill(_ inRect: inout CGRect, fromRect: inout CGRect) {
        let inRectAspect: CGFloat = inRect.aspectRatio
        let fromRectAspect: CGFloat = fromRect.aspectRatio
        if inRectAspect < fromRectAspect {
            inRect.origin.x += (inRect.size.width - inRect.size.height * fromRectAspect) / 2
            inRect.size.width = inRect.size.height * fromRectAspect
        } else {
            inRect.origin.y += (inRect.size.height - inRect.size.width / fromRectAspect) / 2
            inRect.size.height = inRect.size.width / fromRectAspect
        }
    }
}
