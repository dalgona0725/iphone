//
//  ThreeBtnInputPopupView.swift
//  PopkonAir
//
//  Created by Steven on 11/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class ThreeBtnInputPopupView: AlertPopupView {

    private let defaulLabeltHeight = 20
    private let defualtViewHeight = 129
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var inputTextField: OneLineTextField!
    
    @IBOutlet weak var titleBar: UIView!
    @IBOutlet var buttons: [UIButton]!
    
    @IBOutlet weak var mainButton: UIButton!
    
    var buttonActions : [(_ text : String)->Void] = []
    
    
    //MARK: - Class Func
    override class func instanceFromNib() -> ThreeBtnInputPopupView {
        return (Bundle.main.loadNibNamed("ThreeBtnInputPopupView", owner: self, options: nil)![0] as? ThreeBtnInputPopupView)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        inputTextField.lineColor.normal = UIColor.celuvPupleColor()
        inputTextField.lineMargin = 0
        
        titleBar.backgroundColor = popupMainColor
        titleLabel.textColor = .white
        
        mainButton.backgroundColor = popupMainColor
        mainButton.setTitleColor(.white, for: .normal)
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
    
    //MARK: - UI Setup
    override func setup(content:String ,buttonTitles : [String] = []) {
        
        self.titleLabel.text = content
        
    
        for i in 0...buttonTitles.count-1 {
            buttons[i].setTitle(buttonTitles[i], for: .normal)
        }
        
    }
    
    func setButtonActions(actions : [(_ text : String)->Void]) {
        buttonActions = actions
    }
    
    //MARK: - IBActions
    func closeup() {
        self.hide()
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func button1Action(_ sender: AnyObject) {
        self.closeup()
        if self.buttonActions.count > 0 {
            self.buttonActions[0](inputTextField.text!)
        }
        self.buttonActions.removeAll()
    }
    @IBAction func button2Action(_ sender: AnyObject) {
        self.closeup()
        if self.buttonActions.count > 1 {
            self.buttonActions[1](inputTextField.text!)
        }
        self.buttonActions.removeAll()
    }
    
    @IBAction func button3Action(_ sender: AnyObject) {
        self.closeup()
        if self.buttonActions.count > 2 {
            self.buttonActions[2](inputTextField.text!)
        }
        self.buttonActions.removeAll()
    }
    
    override func closePopup() {
        self.resignFirstResponder()
        dispatchMain.async {
            self.closeup()
            self.buttonActions.removeAll()
        }
    }

}

extension ThreeBtnInputPopupView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 25
    }
}
