//
//  UIView+Frame.swift
//  PopkonAir
//
//  Created by roy on 2016. 8. 14..
//  Copyright © 2016년 roy. All rights reserved.
//

import UIKit

extension UIView
{
    /// 해당 UIView의 frame size중 width를 리턴한다
    ///
    /// - returns: frame.size.width value
    func widthSizeOfFrame() -> CGFloat
    {
        return self.frame.size.width
    }
    
    /// 해당 UIView의 frame size중 height를 리턴한다
    ///
    /// - returns: frame.size.height value
    func heightSizeOfFrame() -> CGFloat
    {
        return self.frame.size.height
    }
    
    /// 해당 UIView의 frame position중 y를 리턴한다
    ///
    /// - returns: frame.origin.y value
    func yPositionOfFrame() -> CGFloat
    {
        return self.frame.origin.y
    }
    
    /// 해당 UIView의 frame position중 x를 리턴한다
    ///
    /// - returns: frame.origin.x value
    func xPositionOfFrame() -> CGFloat
    {
        return self.frame.origin.x
    }
    
    /// 해당 UIView의 frame의 x,y값을 변경한다
    ///
    /// - parameter x: 변경할 x좌표
    /// - parameter y: 변경할 y좌표
    func resetXYPositionOfFrame(_ x: CGFloat, y: CGFloat)
    {
        self.frame = CGRect(x: x, y: y, width: self.widthSizeOfFrame(), height: self.heightSizeOfFrame())
    }
    
    /// 해당 UIView의 frame의 x값을 변경한다
    ///
        /// - parameter x: 변경할 x좌표
    func resetXPositionOfFrame(_ x: CGFloat)
    {
        self.frame = CGRect(x: x, y: self.yPositionOfFrame(), width: self.widthSizeOfFrame(), height: self.heightSizeOfFrame())
    }
    
    /// 해당 UIView의 frame의 y값을 변경한다
    ///
    /// - parameter y: 변경할 y좌표
    func resetYPositionOfFrame(_ y: CGFloat)
    {
        self.frame = CGRect(x: self.xPositionOfFrame(), y: y, width: self.widthSizeOfFrame(), height: self.heightSizeOfFrame())
    }
    
    /// 해당 UIView의 frame의 width, height값을 변경한다
    ///
    /// - parameter width: 변경할 width
    /// - parameter height: 변경할 height
    func resizeOfFrame(_ width:CGFloat, height:CGFloat)
    {
        self.frame = CGRect(x: self.xPositionOfFrame(), y: self.yPositionOfFrame(), width: width, height: height)
    }
    
    /// 해당 UIView의 frame의 width값을 변경한다
    ///
    /// - parameter width: 변경할 width
    func resizeWidthOfFrame(_ width:CGFloat)
    {
        self.frame = CGRect(x: self.xPositionOfFrame(), y: self.yPositionOfFrame(), width: width, height: self.heightSizeOfFrame())
    }
    
    /// 해당 UIView의 frame의 height값을 변경한다
    ///
    /// - parameter height: 변경할 height
    func resizeHeightOfFrame(_ height:CGFloat)
    {
        self.frame = CGRect(x: self.xPositionOfFrame(), y: self.yPositionOfFrame(), width: self.widthSizeOfFrame(), height: height)
    }
}

extension UIView {
    
    /// 해당 UIView의 parentViewContorller를 찾는다.
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
    
    func setLayerOutLine(borderWidth: CGFloat = 1, cornerRadius : CGFloat = 1, borderColor: UIColor = UIColor.darkGray ) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.clipsToBounds = true
        self.layer.masksToBounds = true
    }
    
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
         clipsToBounds = true
         layer.cornerRadius = cornerRadius
         layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
     }
}
