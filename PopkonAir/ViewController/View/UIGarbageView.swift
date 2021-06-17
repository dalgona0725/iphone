
//
//  UIGarbageView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 8. 3..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit

enum ManageViewStatus : Int {
    case none
    case begin
    case moving
    case stop
}

class UIGarbageView: UIView {

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
        //let imgView = UIImageView(frame: V)
        //let img = #imageLiteral(resourceName: "close2")
        
        let imgView = UIImageView(image: #imageLiteral(resourceName: "waste_bin"))
        self.addSubview( imgView )
        imgView.snp.makeConstraints{
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.alpha = 0.5
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    func checkDistance(with view: UIView, status: ManageViewStatus) -> Bool {
        let distance = distanceToView(with: view)
        if distance < self.frame.width * 2 {
            if self.alpha == 0.5 {
                UIView.animate(withDuration: 1, animations: {
                    self.alpha = 1.0
                })
            }
            return true
        } else {
            
            if self.alpha == 1 {
                UIView.animate(withDuration: 1, animations: {
                    self.alpha = 0.5
                })
            }
            return false
        }
    }
    
    func distanceToView(with view: UIView) -> CGFloat {
        return sqrt(pow(view.frame.midX - self.frame.midX, 2 ) + pow(view.frame.midY - self.frame.midY, 2))
    }


}
