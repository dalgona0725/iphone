//
//  LetterWriteViewController.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 5. 21..
//  Copyright © 2018년 eugene. All rights reserved.
//

import Foundation

class LetterWriteViewController : BaseViewController {
    
    @IBOutlet weak var topic01Label: UILabel!
    @IBOutlet weak var topic02Label: UILabel!
    @IBOutlet weak var writeButton: UIButton!
    @IBOutlet weak var targetIDTextField: UITextField!
    @IBOutlet weak var messageTextView: PlaceholderTextView!
    @IBOutlet weak var messageLengthLabel: UILabel!
    @IBOutlet weak var writeButtonBottomGapConstraint: NSLayoutConstraint!
    
    //var toolBar : UIToolbar?
    //var nextStepButton: UIButton?
    fileprivate let maximumLengthOfID = 25
    fileprivate let maximumLengthOfMessage = 1000
    let legalIDText = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    
    var targetID : String = ""
    var toAdmin : Bool = false
    
    var writeButtonBottomOrginalGap : CGFloat = 0
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()        
        writeButton.setLayerOutLine(borderWidth: 1, cornerRadius: 0, borderColor: UIColor.darkGray)        
        topic01Label.text = I18N.text_receiver.localized
        topic02Label.text = I18N.text_letterContent.localized
        writeButton.setTitle(I18N.ui_sendLetter.localized, for: .normal)
        targetIDTextField.placeholder = I18N.text_receiverID.localized
        messageLengthLabel.text = String(format: I18N.ui_letterCount.localized, String(0))
        
        messageTextView.delegate = self
        targetIDTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setBarTitle(with: I18N.ui_sendLetter.localized)
        
        if self.targetID.isEmpty == false {
            if self.toAdmin {
                targetIDTextField.text = I18N.text_supervisor.localized
            } else {
                targetIDTextField.text = self.targetID
            }
            targetIDTextField.isEnabled = false
        }
        messageTextView.isEditable = true
        
        self.writeButtonBottomOrginalGap = self.writeButtonBottomGapConstraint.constant
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardChanged(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - User Log out
    override func willLogOut() {
    }
    override func didLogOut(_ notification: NSNotification) {
    }
    
    //MARK: - IBAction
    @IBAction func sendLetterAction(_ sender: Any) {
        
        let sendInquiryProcess : () -> Void = {
            
            if self.targetIDTextField.isFirstResponder {
                _ = self.targetIDTextField.resignFirstResponder()
            }
            if self.messageTextView.isFirstResponder {
                _ = self.messageTextView.resignFirstResponder()
            }
            
            // 받는 사람 아이디를 입력해 주세요.
            
            // 쪽지 내용을 입력해 주세요.
            
            // 본인에게는 쪽지를 보낼 수 없습니다.
            
            // 받는 사람 아이디를 확인해 주세요.
            
            if  var recvID = self.targetIDTextField.text {
                if recvID.count == 0 {
                    self.view.makeToast(I18N.err_inputReceiverID.localized, duration:1.0, position: .center)
                    if self.targetIDTextField.canBecomeFirstResponder {
                        self.targetIDTextField.becomeFirstResponder()
                    }
                    return
                }
                
                if let message = self.messageTextView.text {
                    let trimMessage = message.replacingOccurrences(of: " ", with: "")
                    if trimMessage.count == 0 {
                        self.view.makeToast(I18N.err_inputLetter.localized, duration:1.0, position: .center)
                        if self.messageTextView.canBecomeFirstResponder {
                            self.messageTextView.becomeFirstResponder()
                        }
                        return
                    }
                }
                
                if self.toAdmin {
                    recvID = self.targetID
                }
                
                if recvID == userInfo.userID {
                    self.view.makeToast(I18N.err_cantSendtoMe, duration:1.0, position: .center)
                    return
                }
                
                popupManager.showLoadingView()
                let deadlineTime = DispatchTime.now() + .milliseconds(500)
                dispatchMain.asyncAfter(deadline: deadlineTime, execute: {
                    connection.sendPaper(receiverID: recvID, text: self.messageTextView.text) { (succeed, resultInfo) in
                        if succeed {
                            
                            var targetName = recvID
                            if self.toAdmin {
                                targetName = I18N.text_supervisor.localized
                            }
                            
                            popupManager.showAlert(content: String(format: I18N.text_doneSendLetter.localized, targetName), buttonTitles: [I18N.ui_ok.localized], buttonActions: [{
                                self.popBack()
                                }])
                        }  else {
                            dispatchMain.asyncAfter(deadline: .now() + 0.1 , execute: {
                                self.view.makeToast(resultInfo.message, duration:1.0, position: .center)
                            })
                        }
                        popupManager.hideLoadingView()
                    }
                })
                
            } else {
                log.debug("[ERROR] UI ERROR.")
            }
            
        }
        
        
        userInfo.checkLoginStatus(finished: {
            dispatchMain.async {
                sendInquiryProcess()
            }
        }, failed: {
            
            dispatchMain.async {
                if let navigator = self.navigationController {
                    for vc in navigator.viewControllers {                        
                        if ((vc as? MyInfoViewController) != nil) ||
                            ((vc as? RankViewController) != nil) {
                            self.navigationController?.popToViewController(vc, animated: true)
                        }
                    }
                }
            }
        })

    }
    
    @objc private func popBack() {
        if let navi = self.navigationController {
            if navi.viewControllers.count>1 {
                navi.popViewController(animated: true)
            }else {
                navi.dismiss(animated: true, completion: {})
            }
            
        }else {
            self.dismiss(animated: true, completion: {
            })
        }
    }
    
    //MARK: - Setup
    func setup(targetID: String, isAdmin: Bool = false ) {
        self.targetID = targetID
        self.toAdmin = isAdmin
    }
    
    /*
    func accessoryView() -> UIToolbar? {
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 60))
        toolBar?.barTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        let btn = UIButton(type: .custom)
        btn.setTitle("쪽지보내기", for: .normal)
        btn.setTitleColor(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        btn.titleLabel?.font = UIFont.notoLightFont(ofSize: 16)
        
        btn.bounds = CGRect(x: 0, y: 0, width: toolBar!.frame.width - 20, height: 48)
        btn.backgroundColor = #colorLiteral(red: 0.9334709048, green: 0.3915753365, blue: 0.3600414693, alpha: 1)
        btn.setLayerOutLine(borderWidth: 1, cornerRadius: 0, borderColor: UIColor.darkGray)
        btn.showsTouchWhenHighlighted = true
        btn.addTarget(self, action: #selector(LetterWriteViewController.sendLetterAction) , for: .touchUpInside)
        nextStepButton = btn
        
        let doneButton = UIBarButtonItem(customView: btn)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
        toolBar?.setItems([spaceButton, doneButton, spaceButton], animated: false)
        toolBar?.isUserInteractionEnabled = true
        return toolBar
    }*/
    
    
    //MARK: - TextField 글자제한
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
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
        
        var maxLength = 0
        
        if textField == targetIDTextField {
            let cs = NSCharacterSet(charactersIn: legalIDText).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string != filtered {
                return false
            }
            maxLength = self.maximumLengthOfID
        }

        return newLength <= maxLength
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        //키보드에서 return 키가 눌렸을때
        if textField == targetIDTextField
        {
            _ = messageTextView.becomeFirstResponder()
        }
        
        return true
    }
    
    //MARK: - Keyboard Up/Dwon Event
    @objc func keyboardChanged(notification: Notification) {
        if let userInfo = notification.userInfo {
            let animationTime = (userInfo["UIKeyboardAnimationDurationUserInfoKey"] as! NSNumber).doubleValue
            let keyboardRect = (userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
            
            //var viewHeight : CGFloat = 0
            let keyboardHeight = UIScreen.main.bounds.height - keyboardRect.origin.y
            
            /*
            UIView.animate(withDuration: animationTime, animations: {
            }) { (succeed) in
                self.writeButtonBottomGapConstraint.constant = keyboardHeight + self.writeButtonBottomOrginalGap
            }*/
            
            UIView.animate(withDuration: animationTime, animations: {
                self.writeButtonBottomGapConstraint.constant = keyboardHeight + self.writeButtonBottomOrginalGap
                self.view.layoutIfNeeded()
            })
            
        }
    }
    
}

//MARK: - UITextViewDelegate
extension LetterWriteViewController : UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        var currentCharacterCount = textView.text.count
        if let text = textView.text {
            if text.needComposedCounting() {
                currentCharacterCount = text.composedCount
            }
        }
        
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        
        var addCharacterCount = text.count
        if text.needComposedCounting() {
            addCharacterCount = text.composedCount
        }
        let newLength = currentCharacterCount + addCharacterCount - range.length
        
        let maxLength = self.maximumLengthOfMessage
        
        if newLength <= maxLength {
            self.messageLengthLabel.text = String(format: I18N.ui_letterCount.localized, String(newLength))
            
        }

        return newLength <= maxLength
    }
    
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
    
}
