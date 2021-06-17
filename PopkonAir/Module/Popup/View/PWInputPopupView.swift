//
//  PWInputPopupView.swift
//  PopkonAir
//
//  Created by Steven on 04/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class PWInputPopupView: AlertPopupView {

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
    
    @IBOutlet weak var inputTextField: OneLineTextField!
    
    var buttonActions : [(_ text : String)->Void] = []

    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //MARK: - Class Func
    override class func instanceFromNib() -> PWInputPopupView {
        return (Bundle.main.loadNibNamed("PWInputPopupView", owner: self, options: nil)![0] as? PWInputPopupView)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
		contentLabel.textColor = popupOkButtonColor
        topPanel.backgroundColor = popupMainColor
        inputTextField.lineColor.normal = UIColor.celuvPupleColor()
        inputTextField.lineMargin = 0
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardChanged(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapToHideKeyboard(_:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc func handleTapToHideKeyboard(_ sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    @objc func keyboardChanged(notification : Notification) {
        
        if let userInfo = notification.userInfo {
            let animationTime = (userInfo["UIKeyboardAnimationDurationUserInfoKey"] as! NSNumber).doubleValue
            let keyboardRect = (userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
            
            var moveValue : CGFloat = 0
            if keyboardRect.origin.y < self.frame.origin.y + self.frame.height {
                moveValue = self.frame.origin.y + self.frame.height - keyboardRect.origin.y
            }
            
            let trans = CATransform3DMakeTranslation(0, -moveValue, 0)
            UIView.animate(withDuration: animationTime, animations: {
                self.layer.transform = trans
            })
        }
    }
    
    
    override func updateFrame() {
        
        //        let size = self.contentLabel.sizeThatFits(CGSize(width: defaultWidth-16, height: 400))
        //
        //        //Update Frame
        //        var heightChanged = max(0, Int(size.height) - defaulLabeltHeight)
        //        //check if is over max height size
        //        heightChanged = min(Int(UIScreen.main.bounds.height - 128) - defualtViewHeight, heightChanged)
        //
        //        if defualtViewHeight + heightChanged != Int(self.frame.height) {
        //            let newFrame = CGRect(x: 0, y: 0, width: Int(defaultWidth), height: defualtViewHeight + heightChanged + 10)
        //            self.frame = newFrame
        //        }
        
        orgSize = self.frame.size
    }
    
    func setKeyboardType(keyType : UIKeyboardType ) {
        inputTextField.keyboardType = keyType
    }
    
    func setPlaceHolder( text : String) {
        inputTextField.placeholder = text
    }

    func setButtonActions(actions : [(_ text : String)->Void]) {
        buttonActions = actions
    }
    
    //MARK: - IBActions
    @IBAction override func cancelAction(_ sender: AnyObject) {
        self.closeup()
        if self.buttonActions.count > 1 {
            self.buttonActions[1](inputTextField.text!)
        }
        self.buttonActions.removeAll()
    }
    @IBAction override func okAction(_ sender: AnyObject) {
        self.closeup()
        if self.buttonActions.count > 0 {
            self.buttonActions[0](inputTextField.text!)
        }
        self.buttonActions.removeAll()
    }

    override func closePopup() {
        self.resignFirstResponder()
        dispatchMain.async {
            self.cancelAction(self)
        }
    }
    
    func closeup() {
        self.hide()
        NotificationCenter.default.removeObserver(self)
    }
    
}

extension PWInputPopupView : UITextFieldDelegate {
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
