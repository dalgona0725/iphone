//
//  TabBottomView.swift
//  PopkonAir
//
//  Created by Steven on 16/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import IBAnimatable

class TabBottomView: AnimatableView {

    public init() {
        let frame = CGRect(x: 0, y: 0, width: 64, height: 3)
        super.init(frame: frame)
        
        configureAnimatableProperties()
        fillColor = tabUnderBarColor
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    func moveTo(x:Double) {
        if(x >= 0.0) {
            self.animate(.moveBy(x: x, y: 0))
        }
        
    }
}
