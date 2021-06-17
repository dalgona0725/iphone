//
//  UIColor+Extensions.swift
//  PopkonAir
//
//  Created by roy on 2016. 8. 14..
//  Copyright © 2016년 roy. All rights reserved.
//

import UIKit

extension UIColor
{
    /// RGB값을 UIColor값으로 변환하는 함수, Alpha값은 1이다
    ///
    /// - parameter red: red값
    /// - parameter green: green값
    /// - parameter blue: blue값
    /// - returns: UIColor 값
    class func RGBColor(red: Int, green: Int, blue: Int) -> UIColor
    {
        let newRed   = CGFloat(Double(red) / 255.0)
        let newGreen = CGFloat(Double(green) / 255.0)
        let newBlue  = CGFloat(Double(blue) / 255.0)
        
        return self.init(red: newRed, green: newGreen, blue: newBlue, alpha: CGFloat(1.0))
        
    }
    
    /// RGB값을 UIColor값으로 변환하는 함수
    ///
    /// - parameter red: red값
    /// - parameter green: green값
    /// - parameter blue: blue값
    /// - parameter alpha: alpha값
    /// - returns: UIColor 값
    class func RGBColorWithAlpha(_ red: Int, green: Int, blue: Int, alpha: CGFloat) -> UIColor
    {
        let newRed   = CGFloat(Double(red) / 255.0)
        let newGreen = CGFloat(Double(green) / 255.0)
        let newBlue  = CGFloat(Double(blue) / 255.0)
        
        return self.init(red: newRed, green: newGreen, blue: newBlue, alpha: alpha)
    }
    
    /// HEX 값을 UIColor로 변경하여 가져오기
    ///
    /// - parameter RGBHex: hex값
    /// - returns: UIColor 값
    class func colorWithRGBHexString(_ RGBHex:String) -> UIColor {
        var cString:String = RGBHex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        if (cString.hasPrefix("#")) {
            //cString = cString.substring(from: cString.index(cString.startIndex, offsetBy: 1))
            let startIndex = cString.index(cString.startIndex, offsetBy: 1)
            cString = String(cString[startIndex...])
        }
        
        if (cString.count != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
	
	class func celuvPinkColor() -> UIColor {
		return UIColor(red: 242.0 / 255.0, green: 37.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)
	}
	
	class func celuvBlackColor() -> UIColor {
		return UIColor(red: 56.0 / 255.0, green: 56.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0)
	}
	
	class func celuvPupleColor() -> UIColor {
		return UIColor(red: 101.0 / 255.0, green: 69.0 / 255.0, blue: 230.0 / 255.0, alpha: 1.0)
	}
    
}
