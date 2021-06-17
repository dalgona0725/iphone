
//
//  UIDeviceExtensions.swift
//  Template1
//
//  Created by Abhilash on 24/05/17.
//  Copyright © 2017 Mobiotics. All rights reserved.
//
import Foundation
import UIKit

struct ScreenSize {
	static let width = UIScreen.main.bounds.size.width
	static let height = UIScreen.main.bounds.size.height
	static let frame = CGRect(x: 0, y: 0, width: ScreenSize.width, height: ScreenSize.height)
	static let maxWH = max(ScreenSize.width, ScreenSize.height)
}

struct DeviceType {
	static let iPhone4orLess    = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH < 568.0
	static let iPhone5orSE      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 568.0
	static let iPhone678        = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 667.0
	static let iPhone678p       = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 736.0
	static let iPhoneX_XS       = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 812.0
	static let iPhoneXR_XS_MAX  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 896.0
    static let iPhone12_Pro     = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 844.0
    static let iPhone12MAX      = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.maxWH == 926.0
}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        /// https://gist.github.com/adamawolf/3048717
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XSMax"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro MAx"
            
        case "iPhone13,1":                              return "iPhone 12 Mini"
        case "iPhone13,2":                              return "iPhone 12"
        case "iPhone13,3":                              return "iPhone 12 Pro"
        case "iPhone13,4":                              return "iPhone 12 Pro Max"
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4", "iPad6,7", "iPad6,8":return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    var modelType : ScreenType {
        switch modelName {
        case "iPhone 5", "iPhone 5c", "iPhone 5s":      return .iPhone5
        case "iPhone 6", "iPhone 6s":                   return .iPhone6
        case "iPhone 6 Plus", "iPhone 6s Plus":         return .iPhone6Plus
        case "iPhone 7":                                return .iPhone7
        case "iPhone 7 Plus":                           return .iPhone7Plus
        case "iPhone 8":                                return .iPhone8
        case "iPhone 8 Plus":                           return .iPhone8Plus
        case "iPhone X", "iPhone 12 Mini":              return .iPhoneX
        case "iPhone XS", "iPhone 11 Pro":              return .iPhoneXS
        case "iPhone XSMax", "iPhone 11 Pro MAx":       return .iPhoneXSMax
        case "iPhone XR", "iPhone 11":                  return .iPhoneXR
        case "iPhone 12", "iPhone 12 Pro":              return .iPhone12
        case "iPhone 12 Pro Max":                       return .iPhone12Max
        default:                                        return .Unknown
        }
    }
    
    var deviceIOSVersion: String {
        return UIDevice.current.systemVersion
    }
    
    var deviceScreenWidth: CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        let width = screenSize.width;
        return width
    }
    var deviceScreenHeight: CGFloat {
        let screenSize: CGRect = UIScreen.main.bounds
        let height = screenSize.height;
        return height
    }
    
    var deviceOrientationString: String {
        var orientation : String
        switch UIDevice.current.orientation{
        case .portrait:
            orientation="Portrait"
        case .portraitUpsideDown:
            orientation="Portrait Upside Down"
        case .landscapeLeft:
            orientation="Landscape Left"
        case .landscapeRight:
            orientation="Landscape Right"
        case .faceUp:
            orientation="Face Up"
        case .faceDown:
            orientation="Face Down"
        default:
            orientation="Unknown"
        }
        return orientation
    }
    
    //  Landscape Portrait
    var isDevicePortrait: Bool {
        return UIDevice.current.orientation.isPortrait
    }
    var isDeviceLandscape: Bool {
        return UIDevice.current.orientation.isLandscape
    }
    
    var isIPhone: Bool {
        return UIDevice().userInterfaceIdiom == .phone
    }
    var isIPad: Bool {
        return UIDevice().userInterfaceIdiom == .pad
    }
    enum ScreenType: String {
        case iPhone4
        case iPhone5
        case iPhone6
        case iPhone6Plus
        case iPhone7
        case iPhone7Plus
        case iPhone8
        case iPhone8Plus
        case iPhoneX
        case iPhoneXR
        case iPhoneXS
        case iPhoneXSMax
        case iPhone12
        case iPhone12Max
        case Unknown
    }
    var screenType: ScreenType? {
        /// https://developer.apple.com/design/human-interface-guidelines/ios/visual-design/adaptivity-and-layout/
        guard isIPhone else { return nil }
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4
        case 1136:
            return .iPhone5
        case 1334:
            return .iPhone6
        case 2208:
            return .iPhone6Plus
        case 2436:
            return .iPhoneXS
        case 2688:
            return .iPhoneXSMax
        case 1792:
            return .iPhoneXR
        case 2532:
            return .iPhone12
        case 2778:
            return .iPhone12Max
        default:
            return nil
        }
    }
    
    // helper funcs
    func isScreen35inch() -> Bool {
        return UIDevice().screenType == .iPhone4
    }
    
    func isScreen4inch() -> Bool {
        return UIDevice().screenType == .iPhone5
    }
    
    func isScreen47inch() -> Bool {
        return UIDevice().screenType == .iPhone6
    }
    
    func isScreen55inch() -> Bool {
        return UIDevice().screenType == .iPhone6Plus
    }
    
    func isiPhoneX() -> Bool {
        return UIDevice.current.modelType == .iPhoneX
    }
    
    func hasNotchScreen() -> Bool {
        if UIDevice.current.modelType == .iPhoneX  ||
            UIDevice.current.modelType == .iPhoneXR ||
            UIDevice.current.modelType == .iPhoneXS ||
            UIDevice.current.modelType == .iPhoneXSMax ||
            UIDevice.current.modelType == .iPhone12 ||
            UIDevice.current.modelType == .iPhone12Max {
            return true
        }
        return false
    }
    
    
}



