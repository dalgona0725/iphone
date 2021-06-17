//
//  SplashOverlay.swift
//  PopkonAir
//
//  Created by Steven on 04/01/2017.
//  Copyright © 2017 roy. All rights reserved.
//

import UIKit

class SplashOverlay: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var onTap : ()->Void = {}
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setup()
    }

    func setup() {
        self.backgroundColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 0.345114512)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler))
        
        self.addGestureRecognizer(tap)
    }
    
    @objc func tapHandler() {
        onTap()
    }
}
