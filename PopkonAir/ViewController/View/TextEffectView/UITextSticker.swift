//
//  UITextSticker.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 8. 1..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit
import AudioToolbox

class UIEffectSticker : UIView {
    var topView : UIView?
    
    var pos     : CGPoint = CGPoint()
    var scale   : CGFloat = 1.0
    var theta   : CGFloat = 0
    var scaleX : CGFloat {
        get {
            let t = self.transform
            return sqrt(t.a * t.a + t.c * t.c)
        }
    }
    var scaleY : CGFloat {
        get {
            let t = self.transform
            return sqrt(t.b * t.b + t.d * t.d)
        }
    }
    var rotation : CGFloat {
        get {
            let t = self.transform
            return atan2(t.b, t.a)
        }
    }
    
    var preRotation = CGFloat.infinity
    var preScale = CGFloat.infinity
    
    var onRemove : (UIEffectSticker) -> Void = { view in  }
    var garbageView : UIGarbageView? = nil
    func registerGarbage(view: UIGarbageView) {
        garbageView = view
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXIB()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
    }
    
    func clear() {
        onRemove = { sticker in }
        garbageView = nil
    }
    
    func initFromXIB() {
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.isUserInteractionEnabled = true
        resetProperty()
        
        let rot = UIRotationGestureRecognizer(target: self, action: #selector(self.handleRotation(_:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(_:)))
        
        self.gestureRecognizers = [ rot, pan, pinch ]
        for recognizer in self.gestureRecognizers! {
            recognizer.delegate = self
        }
    }
    
    func resetProperty() {
        self.transform = .identity
        pos = CGPoint(x: 0, y: 0)
        scale = 1.0
        theta = 0.0
        
        preRotation = CGFloat.infinity
        preScale = CGFloat.infinity
    }
    
    func updatePosition() {
        pos.x = self.transform.tx
        pos.y = self.transform.ty
    }
    
    func updateTransformWithoffset( trans: CGPoint, addRot: CGFloat = 0 , addScale: CGFloat = 0) {
        self.transform = CGAffineTransform(translationX: trans.x + pos.x, y: trans.y + pos.y)
        
        theta = theta + addRot
        self.transform = self.transform.rotated(by: theta)
        
        if scale  + addScale > 0.5 {
            scale = scale + addScale
            self.transform = self.transform.scaledBy(x: scale , y: scale)
        } else {
            self.transform = self.transform.scaledBy(x: 0.5, y: 0.5)
        }
    }
    
    @objc func handleRotation(_ gesture: UIRotationGestureRecognizer) {
        if preRotation == CGFloat.infinity {
            preRotation = gesture.rotation
        }
        let addR = gesture.rotation - preRotation
        preRotation = gesture.rotation
        //theta = gesture.rotation
        updateTransformWithoffset(trans: CGPoint.zero, addRot: addR, addScale: 0.0)
    }
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let tran = gesture.translation(in: self.superview)
        updateTransformWithoffset(trans: tran, addRot: 0, addScale: 0)
        
        if gesture.state == .ended {
            if garbageView!.checkDistance(with: self, status: .moving) {
                isUserInteractionEnabled = false
                let scale : CGFloat = garbageView!.frame.width / frame.width
                let newSize = CGSize(width: frame.width * scale, height: frame.height * scale )
                let newOrign = CGPoint(x: garbageView!.frame.midX - frame.width * scale * 0.5 , y: garbageView!.frame.midY - frame.height * scale * 0.5 )
                
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                    self.frame.origin = newOrign
                    self.frame.size = newSize
                    self.alpha = 0.5
                }, completion: { (succeed) in
                    self.Remove()
                    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
                    
                })
            }
        }
    }
    @objc func handlePinch(_ gesture: UIPinchGestureRecognizer) {
        
        if preScale == CGFloat.infinity {
            preScale = gesture.scale
        }
        let addS = gesture.scale - preScale
        preScale = gesture.scale
        
        //scale = gesture.scale
        updateTransformWithoffset(trans: CGPoint.zero, addRot: 0.0, addScale: addS)
    }
    
    func Remove() {
        onRemove(self)
        self.removeFromSuperview()
    }
}


extension UIEffectSticker : UIGestureRecognizerDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if topView != nil {
            self.superview?.insertSubview(self, belowSubview: topView!)
        } else {
            self.superview?.bringSubviewToFront(self)
        }
        
        pos.x = self.transform.tx
        pos.y = self.transform.ty

        preRotation = CGFloat.infinity
        preScale = CGFloat.infinity
        //log.debug("@@@touchesBegan@@@ \(pos.y)")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 3 {
            resetProperty()
        } else {
            //log.debug("!!!touchesEnded!! \(pos.y)")
            
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesEnded(touches, with: event)
    }
}


class UITextSticker: UIEffectSticker {
    var textLabel = UILabel()
    var fontSize    : CGFloat = 25
    var currentColor = UIColor.white {
        didSet {
            textLabel.textColor = currentColor
        }
    }
    var currentBackColor = UIColor.clear {
        didSet {
            self.backgroundColor = currentBackColor
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
    }

    override func initFromXIB() {
        
        super.initFromXIB()
        currentColor = UIColor.white
        textLabel = UILabel()
        textLabel.numberOfLines = 0
        textLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        textLabel.textColor = currentColor
        textLabel.backgroundColor = UIColor.clear
        textLabel.textAlignment = .natural
        textLabel.font = UIFont.notoMediumFont(ofSize: fontSize)
        self.addSubview(textLabel)
        
    }
    
    
    func updateFontSize(size: CGFloat) {
        
        let currentPos = self.frame.origin
        resetProperty()
        // 리셋되어 초기로 된 위치값을 최신값으로 업데이트.
        self.frame.origin = currentPos
        
        fontSize = size
        textLabel.font = UIFont.notoMediumFont(ofSize: fontSize)
        updateLabelFrame()

    }
    
    func updateLabelFrame() {
        
        let textDefaultWidth = UIScreen.main.bounds.width * 0.8
        let textDefaultHeight = UIScreen.main.bounds.height * 0.2
        
        let orgSize = CGSize(width: textDefaultWidth, height: textDefaultHeight)
        let textSzie = textLabel.sizeThatFits( orgSize )
        
        let margin : CGFloat = 5
        
        let xPos : CGFloat = margin // (self.frame.width - textSzie.width) * 0.5 - margin
        let yPos : CGFloat = 0      // self.frame.height - textSzie.height
        let w  = textSzie.width  + margin * 2
        let h  = textSzie.height + 4
        
        textLabel.frame = CGRect(x: xPos, y: yPos, width: w, height: h)
        self.frame.size = CGSize(width: w, height: h)
    }
    
}

class UIImageSticker : UIEffectSticker {
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
    }
    
    func addImage(image: UIImage) {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        self.addSubview(imageView)
    }
    
    override func updateTransformWithoffset( trans: CGPoint, addRot: CGFloat = 0 , addScale: CGFloat = 0) {
        self.transform = CGAffineTransform(translationX: trans.x + pos.x, y: trans.y + pos.y)
        
        theta = theta + addRot
        self.transform = self.transform.rotated(by: theta)
        
        if scale  + addScale > 0.2 {
            scale = scale + addScale
            self.transform = self.transform.scaledBy(x: scale , y: scale)
        } else {
            self.transform = self.transform.scaledBy(x: 0.2, y: 0.2)
        }
    }
}
