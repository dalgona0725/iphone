//
//  FilterMenuView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 7. 31..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit

class FilterMenuView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemCollectionView: UICollectionView!
    
    var onCloseMenu : () -> Void = {  }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    //MARK: - UI Init
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
        let nib = UINib(nibName: "FilterMenuView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        contentView.layer.cornerRadius = 15
        self.addSubview(contentView)
        titleLabel.text = "비디오 필터"

    }
    
    func unSetup() {
        onCloseMenu = {  }
    }

    @IBAction func on(_ close: UIButton) {
        
        onCloseMenu()
        
    }
}
