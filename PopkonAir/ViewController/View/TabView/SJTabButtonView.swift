//
//  SJTabButtonView.swift
//  PopkonAir
//
//  Created by Steven on 21/12/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class SJTabButtonView: UIView {
    
    @IBOutlet private var contView: UIView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var button: UIButton!
    
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
    
    
    private func initFromXIB() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "SJTabButtonView", bundle: bundle)
        contView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        contView.frame = bounds
        contView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        
        self.addSubview(contView)
        
    }
    
    
    private(set) public var buttonInfo : SJTabButtonInfo = SJTabButtonInfo()
    
    
    //MARK: -Content
    
    func setup(with info: SJTabButtonInfo) {
        
        self.buttonInfo = info
        
        // 카테코리 명칭에 소괄호가 존재할시 두줄로 변경
        if buttonInfo.title.contains("(") {
            if let part = buttonInfo.title.range(of: "\\([^)]+\\)", options: .regularExpression) {
                if part.isEmpty == false {
                    let start = part.lowerBound
                    let end = buttonInfo.title.index(start, offsetBy: 1)
                    buttonInfo.title = buttonInfo.title.replacingCharacters(in: start..<end, with: "\n(")
                    self.button.titleLabel?.numberOfLines = 2
                }
            }
        }
        
        self.button.setTitle(buttonInfo.title, for: .normal)
        
        if info.image != nil {
            self.iconImageView.isHidden = false
            self.iconImageView.image = self.buttonInfo.image
            self.button.titleEdgeInsets = UIEdgeInsets(top: 38, left: 0, bottom: 0, right: 0)
            
        }else {
            self.iconImageView.isHidden = true
            self.iconImageView.image = nil
            self.button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        self.button.titleLabel?.font = self.buttonInfo.font
        self.button.setTitleColor(buttonInfo.titleColor, for: .normal)
        self.button.setTitleColor(buttonInfo.titleColorSelected, for: .selected)
    }
}
