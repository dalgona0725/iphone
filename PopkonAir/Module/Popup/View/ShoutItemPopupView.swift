//
//  ShoutItemPopupView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 1. 31..
//  Copyright © 2018년 eugene. All rights reserved.
//
import UIKit

class ShoutItemPopupView : PopupView {
    
    @IBOutlet weak var topPanel: UIView!
    @IBOutlet weak var currentItemNumLabel: UILabel!
    @IBOutlet weak var currentTextCountLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var shoutTextField: OneLineTextField!
    var orgSize : CGSize = CGSize(width: 0, height: 0)
    
    var buttonAction : ButtonAction = ButtonAction()
    
    var currentItemNum = 0
    
    //MARK: - Class Func
    class func instanceFromNib() -> ShoutItemPopupView {
        return (Bundle.main.loadNibNamed("ShoutItemPopupView", owner: self, options: nil)![0] as? ShoutItemPopupView)!
    }
    
    //MARK: - UI Setup
    func setup(itemNum : Int) {
        //init toolbar
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: UIScreen.main.bounds.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "닫기", style: .done, target: self, action: #selector(self.doneButtonAction))
        doneBtn.setTitleTextAttributes( [NSAttributedString.Key.font : UIFont.notoBoldFont(ofSize:(15.0)), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)], for: .normal)
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        
        shoutTextField.inputAccessoryView = toolbar
        shoutTextField.lineColor.normal = UIColor.celuvPupleColor()
        shoutTextField.lineMargin = 0
        shoutTextField.addTarget(self, action: #selector(self.textChanged), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardChanged(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapToHideKeyboard(_:)))
        self.addGestureRecognizer(tap)
        
        if itemNum > 0 {
            var str = NSMutableAttributedString(string: "")
            str = NSMutableAttributedString(string: "보유갯수: ",
                                            attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize:(17.0)), NSAttributedString.Key.foregroundColor : UIColor.black])
            
            let timeAttr = NSAttributedString(string: "\(itemNum)개", attributes: [NSAttributedString.Key.font: UIFont.notoMediumFont(ofSize:(17.0)),NSAttributedString.Key.foregroundColor: UIColor.blue])
            str.append(timeAttr)
            currentItemNumLabel.attributedText = str
        } else {
            currentItemNumLabel.text = "보유갯수: 0개"
        }
        currentItemNum = itemNum
        currentTextCountLabel.text = "0/50"
        //self.setLayerOutLine(borderWidth: 1, cornerRadius: 2, borderColor: UIColor.darkGray)
        
        topPanel.backgroundColor = popupMainColor
        okButton.backgroundColor = popupMainColor
        
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
        currentTextCountLabel.text = "\(length)/50"
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
    
    @objc func doneButtonAction() {
        self.endEditing(true)
    }
    func closeup() {
        self.resignFirstResponder()
        NotificationCenter.default.removeObserver(self)
        self.hide()
        self.buttonAction = ButtonAction()
    }
    override func closePopup() {
        dispatchMain.async {
            self.cancelAction(self.cancelButton)
        }
    }
    
    @IBAction func okAction(_ sender: UIButton) {
        self.endEditing(true)
        
        guard let text = shoutTextField.text else {
            return
        }
        
        if currentItemNum == 0 {
            self.makeToast("보유중인 메가폰 아이템이 없습니다.\n구매 후 다시 이용해 주세요.", duration: 1.0, position: .center)
            return
        }
        
        let abbreviated = text.replacingOccurrences(of: " ", with: "")
        
        if text.count == 0 || abbreviated.count == 0 {
            self.makeToast("텍스트 입력후 아이템을 사용해 주세요.", duration: 1.0, position: .center)
            return
        }
        
        buttonAction.ok()
        self.closeup()
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        buttonAction.cancel()
        self.closeup()
    }
    
}

extension ShoutItemPopupView : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.endEditing(true)
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        /*
         이모지 키보드제외..
         if textField.isFirstResponder {
         if textField.textInputMode?.primaryLanguage == "emoji" || textField.textInputMode?.primaryLanguage == nil {
         return false
         }
         }
         
         if string.containsEmoji() {
         return  false
         } */

        /*
        if let text = textField.text {
            if range.length == 0 && text.count < 50 {
                currentTextCountLabel.text = "\(text.count)/50"
                return true
            } else {
                return false
            }
        } else {
            return false
        }
         */
        
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
        return newLength <= 50
    }
}

/*
 extension ShoutItemPopupView : UITextViewDelegate {
 func textViewDidChange(_ textView: UITextView) {
 let line = textView.caretRect(for: textView.selectedTextRange!.start)
 let overflow = line.origin.y + line.size.height - (textView.contentOffset.y + textView.bounds.size.height - textView.contentInset.bottom - textView.contentInset.top);
 
 if overflow > 0 {
 var offset = textView.contentOffset
 offset.y = offset.y + overflow + 7
 
 UIView.animate(withDuration: 0.2, animations: {
 textView.setContentOffset(offset, animated: true)
 })
 }
 }
 
 func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
 let currentCharacterCount = textView.text.count
 let newLength = currentCharacterCount + text.count - range.length
 return newLength <= 50
 }
 } */
