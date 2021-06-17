//
//  AlertPopupView.swift
//  PopkonAir
//
//  Created by Steven on 24/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class AlertPopupView: PopupView {

    let defaultWidth : CGFloat = 331
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var topPanel: UIView!
    
    ///ContentLabel Default Height
    private let defaulLabeltHeight = 20
    
    private let defaultBottomHeight = 51
    private let defaultTopHeight = 96
    private let defualtViewHeight = 147
    
    private var buttonTitles : [String] = []
    private var buttonActions : [()->Void] = []
    
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet private weak var okButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    var orgSize : CGSize = CGSize(width: 0, height: 0)
    
    //MARK: - Class Func
    class func instanceFromNib() -> AlertPopupView {
        return (Bundle.main.loadNibNamed("AlertPopupView", owner: self, options: nil)![0] as? AlertPopupView)!
    }
    
    //MARK: - UI Setup
    func setup(content:String ,buttonTitles : [String] = []) {
    
        self.setLayerOutLine(borderWidth: 1, cornerRadius: 12)
        
        self.contentLabel.text = content

        okButton.backgroundColor = popupMainColor
		okButton.setTitleColor(popupOkButtonColor, for: .normal)
        
        if buttonTitles.count == 0 {
            self.buttonTitles = [I18N.ui_ok.localized]
        }else {
            self.buttonTitles = buttonTitles
        }
        
        for i in 0...1 {
            
            if i == 0 {
                self.okButton.setTitle(self.buttonTitles[i], for: .normal)
            }else if i == 1 {
                if self.buttonTitles.count>1 {
                    self.cancelButton.setTitle(self.buttonTitles[i], for: .normal)
                }else {
                    self.cancelButton.isHidden = true
                }
            }
        }
        
        self.updateFrame()
        
    }
	
    func updateOkButtonColor(color: UIColor) {
        okButton.setTitleColor(color, for: .normal)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if let center = self.window?.center {
            self.center = center
        }
        
        if orgSize.width != 0 && orgSize.height != 0 {
            self.frame.size = orgSize
        }
    }
    
    func updateFrame() {
        
        let size = self.contentLabel.sizeThatFits(CGSize(width: defaultWidth-16, height: 400))
        
        //Update Frame
        //get label height changed
        let heightChanged = max(Int(size.height) + 20, defaultTopHeight )
        //check if is over max height size
        //heightChanged = min(Int(UIScreen.main.bounds.height - 128) - defualtViewHeight, heightChanged)
        
        if defaultBottomHeight + heightChanged != Int(self.frame.height) ||
            defaultWidth != self.frame.width {
            let newFrame = CGRect(x: 0, y: 0, width: Int(defaultWidth), height: defaultBottomHeight + heightChanged )
            self.frame = newFrame
        }
        
        orgSize = self.frame.size
    }

    
    func setButtonTitles(titles : [String]) {
        if titles.count == 0 {
            buttonTitles = [I18N.ui_ok.localized]
        }else {
            buttonTitles = titles
        }
        
        okButton.setTitle(buttonTitles[0], for: .normal)
        
        if buttonTitles.count == 1 {
            cancelButton.isHidden = true
        }else {
            cancelButton.isHidden = false
            cancelButton.setTitle(buttonTitles[1], for: .normal)
        }
    }
    func setButtonActions(actions : [()->Void]) {
        buttonActions = actions
    }
    
    //MARK: - IBActions
    @IBAction func cancelAction(_ sender: AnyObject) {
        self.hide()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kCloseAlertPopup), object:nil)
        if self.buttonActions.count > 1 {
            self.buttonActions[1]()
        }
        
        self.buttonActions.removeAll()
    }
    @IBAction func okAction(_ sender: AnyObject) {
        self.hide()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kCloseAlertPopup), object:nil)
        if self.buttonActions.count > 0 {
            self.buttonActions[0]()
        }
        
        self.buttonActions.removeAll()
    }
    
    override func closePopup() {
        dispatchMain.async {
            self.cancelAction(self)
        }
    }
    

}
