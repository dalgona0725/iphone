//
//  SplashActionButton.swift
//  PopkonAir
//
//  Created by Steven on 04/01/2017.
//  Copyright © 2017 roy. All rights reserved.
//

import UIKit

struct SplashSubButtonInfo {
    var bgColor = #colorLiteral(red: 0.9987707734, green: 0.8005083203, blue: 0.00764210429, alpha: 1)
    var title = ""
    var font = UIFont.systemFont(ofSize: 16)
    var fontColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
}

class SplashActionButton: UIView {

    @IBOutlet private var contView: UIView!
    
    @IBOutlet private weak var menuButton: UIButton!
    
    private var overlay : SplashOverlay = SplashOverlay(frame:CGRect.zero)
    private var subMenus : [SplashSubButton] = []
    var subMenuInfos : [SplashSubButtonInfo] = [] {
        didSet {
            setupSubButtons()
        }
    }
    
    var subMenuSize = CGSize(width: 50, height: 50)
    
    var onClickSubMenu : (_ index : Int) ->Void = {
        index in
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
    }
    
    
    private func initFromXIB() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SplashActionButton", bundle: bundle)
        contView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        contView.frame = bounds
        contView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        
        self.addSubview(contView)
        
        
        overlay.isHidden = true
        overlay.onTap = {
            self.hideMenu()
        }
        overlay.alpha = 0
        self.insertSubview(overlay, at: 0)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.superview != nil {
            let superViewSize = self.superview!.bounds.size
            
            overlay.frame = CGRect(origin: CGPoint(x: -self.frame.minX, y: -self.frame.minY), size: superViewSize)
        }else {
            overlay.frame = self.bounds
        }
    }

    //MARK: - UI
    private func setupSubButtons() {
        for subButton in subMenus {
            subButton.removeFromSuperview()
        }
        
        for (index,info) in subMenuInfos.enumerated() {
            let subButton = SplashSubButton(frame: CGRect(origin: defaultPosition(), size: subMenuSize))
            
            subButton.setTitle(info.title, for: .normal)
            subButton.titleLabel?.font = info.font
            subButton.titleLabel?.textColor = info.fontColor
            subButton.backgroundColor = info.bgColor
            subButton.addTarget(self, action: #selector(self.subMenuAction(_:)), for: .touchUpInside)
            subButton.tag = index
            subMenus.append(subButton)
            
            self.insertSubview(subButton, aboveSubview: overlay)
        }
    }
    
    //MARK: - SubMen Show & Hide
    func showMenu() {
        
        showOverlay()
        
        for (index, button) in subMenus.enumerated() {
            DispatchQueue.main.async {
                
                button.targetPositions = []
                
                let point = self.pointBeMoved(from: 0)
                button.targetPositions.append(point)
                
                if index > 0 {
                    button.targetPositions.append(self.pointBeMoved(from: index))
                }
                
                button.run(from: 0)
                
            }
        }
    }
    
    func hideMenu() {
        
        hideOverlay()
        
        for (_, button) in subMenus.enumerated() {
            DispatchQueue.main.async {
                
                button.targetPositions = [CGPoint.zero]
                
                button.run(from: 0)
            }
        }
    }
    
    func showOverlay() {
        UIView.animate(withDuration: 0.25) { 
            self.overlay.alpha = 1
        }
    }
    
    func hideOverlay() {
        UIView.animate(withDuration: 0.25) {
            self.overlay.alpha = 0
        }
    }
    
    
    


    //MARK: - IBAction
    @IBAction func menuAction(_ sender: Any) {
        if self.overlay.alpha == 0 {
            showMenu()
        }else {
            hideMenu()
        }
    }
    
    @objc func subMenuAction(_ sender: SplashSubButton) {
        
        onClickSubMenu(sender.tag)
        
        hideMenu()
    }
    
    
    //MARK: - Override
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // Convert the point to the target view's coordinate system.
        // The target view isn't necessarily the immediate subview
        if bounds.contains(point) {
            return super.hitTest(point, with: event)
        }
        
        for button in subMenus {
            let pointForTargetView = button.convert(point, from:self)
            if (button.bounds.contains(pointForTargetView)) {
                // The target view may have its view hierarchy,
                // so call its hitTest method to return the right hit-test view
                return button.hitTest(pointForTargetView, with:event);
            }
        }
        
        
        let pointForTargetView = overlay.convert(point, from:self)
        if (overlay.bounds.contains(pointForTargetView)) {
            // The target view may have its view hierarchy,
            // so call its hitTest method to return the right hit-test view
            return overlay.hitTest(pointForTargetView, with:event);
        }
        
        return super.hitTest(point, with: event)
    }
    
    //MARK: - Layout
    
    func defaultPosition()->CGPoint {
        return CGPoint(x: (bounds.width-subMenuSize.width)/2, y: (bounds.height-subMenuSize.height)/2)
    }
    
    func pointBeMoved(from index : Int) -> CGPoint {
        
        let angle: CGFloat = (-.pi / 4) * CGFloat(index) - .pi/2
        let radius = bounds.height + 30
        let center = CGPoint.zero//CGPoint(x: -bounds.width/2, y: -bounds.height/2)
        
        return point(from: angle, radius: radius, offset: center)
    }
    
    func point(from angle: CGFloat, radius: CGFloat, offset: CGPoint) -> CGPoint {
        return CGPoint(x: radius * cos(angle) + offset.x, y: radius * sin(angle) + offset.y)
    }
    
}
