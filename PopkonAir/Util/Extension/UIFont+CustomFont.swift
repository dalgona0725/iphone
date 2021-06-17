//
//  UIFont+CustomFont.swift
//  PopkonAir
//
//  Created by Steven on 25/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import Foundation

extension UIFont {
    
    class func allFontNames() {
        print("\n")
        for name in UIFont.familyNames {
            print("----family-----: " + name + "\n")
            for fontName in UIFont.fontNames(forFamilyName: name) {
                print("--font name---: " + fontName + "\n")
            }
            
            print("\n")
            
        }
    }
    class func notoFont(ofSize : CGFloat) -> UIFont {
         let font = UIFont(name: "NotoSansCJKkr-Regular", size: ofSize)
        
        return font!
    }
    
    class func notoBoldFont(ofSize : CGFloat) -> UIFont {
        
        let font = UIFont(name: "NotoSansCJKkr-Bold", size: ofSize)
        
        return font!
    }
    
    class func notoLightFont(ofSize : CGFloat) -> UIFont {
        let font = UIFont(name: "NotoSansCJKkr-Light", size: ofSize)
        
        return font!
    }
    
    class func notoMediumFont(ofSize : CGFloat) -> UIFont {
        let font = UIFont(name: "NotoSansCJKkr-Medium", size: ofSize)
        
        return font!
    }
	
	///Neo Fonts
	class func neoFont(ofSize : CGFloat) -> UIFont {
		
		let font = UIFont(name: "AppleSDGothicNeo-Regular", size: ofSize)
		
		return font!
	}
	
	class func neoBoldFont(ofSize : CGFloat) -> UIFont {
		let font = UIFont(name: "AppleSDGothicNeo-Bold", size: ofSize)
		
		return font!
	}
	
	class func neoSemiBoldFont(ofSize : CGFloat) -> UIFont {
		let font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: ofSize)
		
		return font!
	}
	
	class func neoMediumFont(ofSize : CGFloat) -> UIFont {
		let font = UIFont(name: "AppleSDGothicNeo-Medium", size: ofSize)
		
		return font!
	}
	
	class func neoLightFont(ofSize : CGFloat) -> UIFont {
		let font = UIFont(name: "AppleSDGothicNeo-Light", size: ofSize)
		
		return font!
	}
	
	class func neoUltraLightFont(ofSize : CGFloat) -> UIFont {
		let font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: ofSize)
		
		return font!
	}
    
    
}
