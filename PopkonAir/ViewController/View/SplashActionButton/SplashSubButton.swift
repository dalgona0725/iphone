//
//  SplashSubButton.swift
//  PopkonAir
//
//  Created by Steven on 04/01/2017.
//  Copyright © 2017 roy. All rights reserved.
//

import UIKit
import IBAnimatable

class SplashSubButton: AnimatableButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var targetPositions : [CGPoint] = []

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
        
        configureAnimatableProperties()
        fillColor = #colorLiteral(red: 0.9987707734, green: 0.8005083203, blue: 0.00764210429, alpha: 1)
        maskType = .circle
        damping = 1
        delay = 0
        duration = 0.3
        velocity = 1
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = self.bounds.width/2
    }
    
    func run(from index:Int) {
        if targetPositions.count > index {
            let point = targetPositions[index]
            self.animate(.moveBy(x: Double(point.x), y: Double(point.y)))
            
            self.run(from: index+1)
        }
    }
    

}
