//
//  OneLineTextField.swift
//  PopkonAir
//
//  Created by Steven on 27/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit


struct LineColor {
    var normal: UIColor = textFieldLineNormalColor
    var edit : UIColor  = textFieldLineEditColor
}

class OneLineTextField: UITextField {
    
    @IBInspectable var isPasteEnabled: Bool = true
    @IBInspectable var isCutEnabled: Bool = true
    @IBInspectable var isCopyEnabled: Bool = true
    
    var lineColor : LineColor = LineColor()
    var lineTextColor = textFieldTextColor
    var lineMargin : CGFloat = 10  {
        didSet {
            self.layoutSubviews()
        }
    }
    
    fileprivate var bottomBorder = CALayer()
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
        bottomBorder.borderColor = lineColor.normal.cgColor
        bottomBorder.borderWidth = 2
        bottomBorder.frame = CGRect(x: -lineMargin, y: self.bounds.height - 2, width: self.bounds.width+lineMargin*2, height: bottomBorder.borderWidth)
        
        if bottomBorder.superlayer == nil {
            self.layer.addSublayer(bottomBorder)
        }
        
        self.clipsToBounds = false
        self.layer.masksToBounds = false
        
        //Cursor Color
        self.tintColor = lineColor.edit
        self.textColor = lineTextColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bottomBorder.superlayer != nil {
            bottomBorder.frame = CGRect(x: -lineMargin, y: self.bounds.height - 2, width: self.bounds.width+lineMargin*2, height: bottomBorder.borderWidth)
            bottomBorder.borderColor = self.isEditing ? lineColor.edit.cgColor : lineColor.normal.cgColor
        }
    }
    
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        switch action {
        case #selector(UIResponderStandardEditActions.paste(_:)) where !isPasteEnabled,
             #selector(UIResponderStandardEditActions.copy(_:)) where !isCopyEnabled,
             #selector(UIResponderStandardEditActions.cut(_:)) where !isCutEnabled:
            return false
        default:
            return super.canPerformAction(action, withSender: sender)
        }
    }
    

}
