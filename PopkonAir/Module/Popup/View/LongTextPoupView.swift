//
//  LongTextPoupView.swift
//  PopkonAir
//
//  Created by Steven on 14/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class LongTextPoupView: PopupView {
    
    
    let defaultWidth = UIScreen.main.bounds.width - 40
    let defaultHeight = UIScreen.main.bounds.height - 140

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    ///ContentLabel Default Height
    private let defaulLabeltHeight = 20
    private let defualtViewHeight = 98
    
    var buttonTitles : [String] = []
    var buttonActions : [(_ checked : Bool)->Void] = []
    

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var chkButton: UIButton!
    @IBOutlet var buttons: [UIButton]!
    
    
    
    //MARK: - Class Func
    class func instanceFromNib() -> LongTextPoupView {
        return (Bundle.main.loadNibNamed("LongTextPoupView", owner: self, options: nil)![0] as? LongTextPoupView)!
    }
    
    //MARK: - UI Setup
    func setup(content:String,chkTitle:String = "" , buttonTitles: [String] = []) {
        
        //TextView
        self.textView.text = content
        self.textView.sizeToFit()
        
        //CheckButton
        if chkTitle.count == 0 {
            chkButton.isHidden = true
        }else {
            chkButton.setTitle(chkTitle, for: .normal)
        }
        
        //Buttons
        if buttonTitles.count == 0 {
            self.buttonTitles = ["확인"]
        }else {
            self.buttonTitles = buttonTitles
        }
        
        for i in 0...buttons.count-1 {
            if self.buttonTitles.count > i {
                buttons[i].setTitle(self.buttonTitles[i], for: .normal)
            }else {
                buttons[i].isHidden = true
            }
        }
        
        self.frame = CGRect(x: 0, y: 0, width: Int(defaultWidth), height: Int(defaultHeight))
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //trick to update textview content size
        self.textView.isScrollEnabled = false
        self.textView.isScrollEnabled = true
        self.textView.setContentOffset(CGPoint.zero, animated: false)
    }
    
    
    func setButtonActions(actions : [(_ checked : Bool)->Void]) {
        buttonActions = actions
    }
    
    //MARK: - IBActions
    @IBAction func button1Action(_ sender: AnyObject) {
        self.hide()
        if self.buttonActions.count > 1 {
            self.buttonActions[0](chkButton.isSelected)
        }
    }
    @IBAction func button2Action(_ sender: AnyObject) {
        self.hide()
        if self.buttonActions.count > 0 {
            self.buttonActions[1](chkButton.isSelected)
        }
    }
    @IBAction func chkButtonAction(_ sender: Any) {
        chkButton.isSelected = !chkButton.isSelected
    }

}
