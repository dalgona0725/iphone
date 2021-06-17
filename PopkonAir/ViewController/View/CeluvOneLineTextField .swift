//
//  OneLineTextField.swift
//  PopkonAir
//
//  Created by Steven on 27/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit


struct CeluvLineColor {
//    var normal: UIColor = UIColor.colorWithRGBHexString("#c9a617")
//    var edit : UIColor = UIColor.colorWithRGBHexString("#fa377c")
    
    var normal: UIColor = UIColor.clear
    var edit : UIColor = UIColor.RGBColor(red: 198, green: 198, blue: 198)
    
}

class CeluvOneLineTextField : UITextField {
    
    
    var lineColor : CeluvLineColor = CeluvLineColor()
    @IBInspectable var lineMargin : CGFloat = 10  {
        didSet {
            self.layoutSubviews()
        }
    }
    @IBInspectable var lineWidth : CGFloat = 2
    @IBInspectable var insetX: CGFloat = 0
    @IBInspectable var insetY: CGFloat = 0
        
    fileprivate var bottomBorder = CALayer()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
//        
//        bottomBorder.borderColor = lineColor.normal.cgColor
//        bottomBorder.borderWidth = lineWidth
        bottomBorder.frame = CGRect(x: -lineMargin, y: self.bounds.height - lineWidth, width: self.bounds.width+lineMargin*2, height: bottomBorder.borderWidth)
        
        if bottomBorder.superlayer == nil {
            self.layer.addSublayer(bottomBorder)
        }
        
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        
        //Cursor Color
        self.tintColor = lineColor.edit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bottomBorder.superlayer != nil {
            bottomBorder.frame = CGRect(x: -lineMargin, y: self.bounds.height - 2, width: self.bounds.width+lineMargin*2, height: bottomBorder.borderWidth)
            bottomBorder.borderColor = self.isEditing ? lineColor.edit.cgColor : lineColor.normal.cgColor
        }
    }
    
    // placeholder position
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    
    // text position
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX, dy: insetY)
    }
    

}
