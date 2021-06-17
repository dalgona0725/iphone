//
//  UITextView+Placeholder.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 7. 16..
//  Copyright © 2018년 eugene. All rights reserved.
//

import UIKit

class PlaceholderTextView : UITextView {
    @IBInspectable var placeholder : String = ""
    var placeholderLabel : UILabel? = nil
    
    override func draw(_ rect: CGRect) {
        if self.placeholder.count > 0 {
            if self.placeholderLabel == nil {
                let linePadding = self.textContainer.lineFragmentPadding
                let placeholderRect = CGRect(x: self.textContainerInset.left + linePadding, y: self.textContainerInset.top, width: rect.size.width - self.textContainerInset.left - self.textContainerInset.right - 2 * linePadding, height: rect.size.height - self.textContainerInset.top - self.textContainerInset.bottom )
                
                let label = UILabel(frame: placeholderRect)
                label.font = self.font
                label.textAlignment = self.textAlignment
                label.textColor = UIColor.lightGray
                self.addSubview(label)
                
                label.text = self.placeholder
                label.sizeToFit()
                
                placeholderLabel = label
                
                NotificationCenter.default.addObserver(self, selector: #selector(self.textChanged), name: UITextView.textDidChangeNotification, object: nil)
            }
            self.showOrHidePlaceholder()
        }
        
        super.draw(rect)
    }
    
    
    @objc func textChanged(_ notification: NSNotification) {
        if self.placeholder.count == 0 {
            return
        }
        
        UIView.animate(withDuration: 0.1) {
            self.showOrHidePlaceholder()
        }
    }
    
    func showOrHidePlaceholder() {
        if self.text.count == 0 {
            self.placeholderLabel?.alpha = 1.0
        } else {
            self.placeholderLabel?.alpha = 0.0
        }
    }

}
