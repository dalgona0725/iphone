//
//  ChkAlertPopupView.swift
//  PopkonAir
//
//  Created by Steven on 09/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class ChkAlertPopupView: AlertPopupView {

    private let defaulLabeltHeight = 20
    private let defualtViewHeight = 129
    
    
    
    @IBOutlet weak var chkButton: UIButton!
    
    
    var buttonActions : [(_ checked : Bool)->Void] = []
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    //MARK: - Class Func
    override class func instanceFromNib() -> ChkAlertPopupView {
        return (Bundle.main.loadNibNamed("ChkAlertPopupView", owner: self, options: nil)![0] as? ChkAlertPopupView)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func setup(content: String, chkTitle: String, buttonTitles: [String]) {
        self.setup(content: content, buttonTitles: buttonTitles)
        
        chkButton.setTitle(chkTitle, for: .normal)
        
    }
    
    override func updateFrame() {
        
        let size = self.contentLabel.sizeThatFits(CGSize(width: defaultWidth - 16, height: 400))
        
        //Update Frame
        var heightChanged = max(0, Int(size.height) - defaulLabeltHeight)
        //check if is over max height size
        heightChanged = min(Int(UIScreen.main.bounds.height - 128) - defualtViewHeight, heightChanged)
        
        if defualtViewHeight + heightChanged != Int(self.frame.height) {
            let newFrame = CGRect(x: 0, y: 0, width: Int(defaultWidth), height: defualtViewHeight + heightChanged + 10)
            self.frame = newFrame
        }
    }
    
    func setButtonActions(actions : [(_ checked : Bool)->Void]) {
        buttonActions = actions
    }
    
    //MARK: - IBActions
    @IBAction override func cancelAction(_ sender: AnyObject) {
        self.hide()
        if self.buttonActions.count > 1 {
            self.buttonActions[1](chkButton.isSelected)
        }
    }
    @IBAction override func okAction(_ sender: AnyObject) {
        self.hide()
        if self.buttonActions.count > 0 {
            self.buttonActions[0](chkButton.isSelected)
        }
    }

    @IBAction func chkButtonAction(_ sender: Any) {
        chkButton.isSelected = !chkButton.isSelected
    }

}
