//
//  BlurView.swift
//  PopkonAir
//
//  Created by Steven on 24/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit


class BlurView: UIView {

    let blurViewAlpha : CGFloat = 0.5
    var removeAtOnce : Bool = false
    var dontDestory : Bool = false
    
    /*네
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    class func standard() -> BlurView {
        
        let blurView = BlurView(frame: UIScreen.main.bounds)
        blurView.backgroundColor = UIColor.black
        blurView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        
        return blurView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = UIScreen.main.bounds
    }
}

//MARK: - Show & Hide
extension BlurView {
    
    func isHide() -> Bool {
        return self.superview == nil
    }
    
    func showInView(parentView : UIView) {

        if self.superview == nil {
            
            self.frame = UIScreen.main.bounds
            self.alpha = 0
            self.removeAtOnce = false
            
            parentView.addSubview(self)
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.alpha = self.blurViewAlpha
        }) { (finished) in
            self.alpha = self.blurViewAlpha
            self.dontDestory = false
        }
        
    }
    
    func hide() {
        if self.removeAtOnce {
            self.removeFromSuperview()
        } else {
            UIView.animate(withDuration: 0.25, animations: {
                self.alpha = 0
            }) { (finished) in
            
                if self.dontDestory == false {
                    self.alpha = self.blurViewAlpha
                    self.removeFromSuperview()
                }
                
            }
        }
    }
}
