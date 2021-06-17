//
//  CasterNoticePopupView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 04/12/2018.
//  Copyright © 2018 The E&M. All rights reserved.
//

import UIKit
import UserNotifications


class CasterNoticePopupView : PopupView {
    
    @IBOutlet weak var topPanel: UIView!
    @IBOutlet weak var currentTextCountLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var noticeTextField: OneLineTextField!
	@IBOutlet weak var noticeTitleLabel: UILabel!
	
	
	var orgSize : CGSize = CGSize(width: 0, height: 0)
    
    var buttonAction : ButtonAction = ButtonAction()
    var currentItemNum = 0
    
    fileprivate let maximumLengthOfNotice = 40
    
    //MARK: - Class Func
    class func instanceFromNib() -> CasterNoticePopupView {
        return (Bundle.main.loadNibNamed("CasterNoticePopupView", owner: self, options: nil)![0] as? CasterNoticePopupView)!
    }
    
    //MARK: - UI Setup
    func setup(currentNotice: String) {
        /*
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: UIScreen.main.bounds.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "닫기", style: .done, target: self, action: #selector(doneButtonAction))
        doneBtn.setTitleTextAttributes( [NSFontAttributeName : UIFont.notoBoldFont(ofSize:(15.0)), NSForegroundColorAttributeName : mainColor], for: .normal)
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        noticeTextField.inputAccessoryView = toolbar */
        
        noticeTextField.lineColor.normal = UIColor.celuvPupleColor()
        noticeTextField.lineMargin = 0
        noticeTextField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        
        if currentNotice.isEmpty == false {
            noticeTextField.text = currentNotice
            textChanged(textField: self.noticeTextField)
        } else {
            currentTextCountLabel.text = "0/\(maximumLengthOfNotice)"
        }
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardChanged(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapToHideKeyboard(_:)))
        self.addGestureRecognizer(tap)
        
        topPanel.backgroundColor = popupMainColor
        okButton.backgroundColor = popupMainColor
		okButton.setTitle(I18N.ui_ok.localized, for: .normal)
		okButton.setTitleColor(popupOkButtonColor, for: .normal)
		cancelButton.setTitle(I18N.ui_cancel.localized, for: .normal)
		noticeTitleLabel.text = I18N.popup_broadcast_notice.localized
		noticeTextField.placeholder = I18N.popup_notice_placeholder.localized
        
        orgSize = self.frame.size
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
    
    @objc func textChanged(textField: UITextField) {
        
        var length = 0
        if let text = textField.text {
            if text.needComposedCounting() {
                length = text.composedCount
            } else {
                length = text.count
            }
        }
        currentTextCountLabel.text = "\(length)/\(maximumLengthOfNotice)"
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
    
//    func doneButtonAction() {
//        self.endEditing(true)
//    }
    
    func closeup() {
        self.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
        self.hide()
    }
    override func closePopup() {
        dispatchMain.async {
            self.cancelAction(self.cancelButton)
        }
    }
    
    @IBAction func okAction(_ sender: UIButton) {
        self.endEditing(true)
        guard let _ = noticeTextField.text else {
            return
        }
        self.closeup()
        buttonAction.ok()
        self.buttonAction = ButtonAction()
        
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        self.closeup()
        buttonAction.cancel()
        self.buttonAction = ButtonAction()
    }
    
}

extension CasterNoticePopupView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        var currentCharacterCount = textField.text?.count ?? 0
        
        if let text = textField.text {
            if text.needComposedCounting() {
                currentCharacterCount = text.composedCount
            }
        }
        
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        
        var addCharacterCount = string.count
        if string.needComposedCounting() {
            addCharacterCount = string.composedCount
        }
        
        let newLength = currentCharacterCount + addCharacterCount - range.length
        return newLength <= maximumLengthOfNotice
    }
}
