//
//  GiftInputPopupView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 10. 24..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit

class GiftInputPopupView: AlertPopupView {
    
    private let defaulLabeltHeight = 20
    private let defualtViewHeight = 129
    
    fileprivate var maxTextFieldInput = 10
    
    var maxInputText : Int {
        get {
            return maxTextFieldInput
        }
        set {
            maxTextFieldInput = newValue
        }
    }
    
    
//    @IBOutlet weak var titleBar: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet weak var inputTextField: OneLineTextField!
    @IBOutlet weak var mainButton: UIButton!
    
    
    var buttonActions : [(_ text : String)->Void] = []

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    //MARK: - Class Func
    override class func instanceFromNib() -> GiftInputPopupView {
        return (Bundle.main.loadNibNamed("GiftInputPopupView", owner: self, options: nil)![0] as? GiftInputPopupView)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topPanel.backgroundColor = popupMainColor
        titleLabel.textColor = titleTextColor
        mainButton.backgroundColor = popupMainColor
        
        inputTextField.lineColor.normal = UIColor.celuvPupleColor()
        inputTextField.lineMargin = 0
        
        //Tap
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    //MARK: - UI Setup
    @objc func tapHandler(_ sender:UITapGestureRecognizer){
        inputTextField.resignFirstResponder()
    }
    
    override func setup(content:String ,buttonTitles : [String] = []) {
        self.titleLabel.text = content
        for i in 0...buttonTitles.count-1 {
            buttons[i].setTitle(buttonTitles[i], for: .normal)
        }
        
        self.updateFrame()
    }
    
    override func updateFrame() {
        orgSize = self.frame.size
    }
    
    func setKeyboardType(keyType : UIKeyboardType ) {
        inputTextField.keyboardType = keyType
    }
    
    func setPlaceHolder( text : String) {
        inputTextField.placeholder = text
    }
    
    func setInfoLabel( text : String ) {
        infoLabel.text = text
    }
    
    func setButtonActions(actions : [(_ text : String)->Void]) {
        buttonActions = actions
    }
    
    //MARK: - IBActions
    @IBAction func button1Action(_ sender: AnyObject) {
        self.hide()
        if self.buttonActions.count > 0 {
            self.buttonActions[0](inputTextField.text!)
        }
        self.buttonActions.removeAll()
    }
    @IBAction func button2Action(_ sender: AnyObject) {
        self.hide()
        if self.buttonActions.count > 1 {
            self.buttonActions[1](inputTextField.text!)
        }
        self.buttonActions.removeAll()
    }
    
    @IBAction func button3Action(_ sender: AnyObject) {
        self.hide()
        if self.buttonActions.count > 2 {
            self.buttonActions[2](inputTextField.text!)
        }
        self.buttonActions.removeAll()
    }
    
    override func closePopup() {
        self.resignFirstResponder()
        dispatchMain.async {
            self.hide()
            self.buttonActions.removeAll()
        }
    }
}


extension GiftInputPopupView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hide()
        if self.buttonActions.count > 0 {
            self.buttonActions[0](inputTextField.text!)
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= maxTextFieldInput
    }
}
