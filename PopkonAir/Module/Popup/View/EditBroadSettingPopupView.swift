//
//  EditBroadSettingPopupView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 11. 6..
//  Copyright © 2017년 roy. All rights reserved.
//


import UIKit

class EditBroadSettingPopupView: AlertPopupView {
    
//    private let defaulLabeltHeight = 20
//    private let defualtViewHeight = 129
    
    fileprivate let maximumLengthOfTitle = 40
    fileprivate let maximumLengthOfPassword = 10
    
    @IBOutlet weak var adultCastLabel: UILabel!
    @IBOutlet weak var adultSwitch: UISwitch!
    
    @IBOutlet weak var viewersNumLabel: UILabel!
    @IBOutlet weak var viewerNumSlider: UISlider!
    
    @IBOutlet weak var titleTextInput: OneLineTextField!
    
    @IBOutlet weak var passwordCheckButton: UIButton!
    @IBOutlet weak var passwordTextInput: OneLineTextField!
	
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var passwordLabel: UILabel!
	@IBOutlet weak var viewCountLabel: UILabel!	
    
    fileprivate var textFields = [OneLineTextField]()
    
    let defaultLineColor = UIColor.lightGray
    var castInfo        = BCPrepareInfo()
    var isAdult         = false
    var maxViewerCount  = 0
    
    /// 사업부 요청. 방송이후 19금/일반 설정은 변경되어서는 안된다.
    var enableAdultCast = false
    
    var doneAction : (_ broadcastInfo: BCPrepareInfo) -> Void = { info in }
    
    let legalSecretText = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz[]{}|<>,.~`!@#$%^&*()_+-=£¥•\\?/\"\'₩"
    
    //MARK: - Class Func
    override class func instanceFromNib() -> EditBroadSettingPopupView {
        return (Bundle.main.loadNibNamed("EditBroadSettingPopupView", owner: self, options: nil)![0] as? EditBroadSettingPopupView)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topPanel.backgroundColor = popupMainColor
		contentLabel.textColor = popupOkButtonColor
		contentLabel.text = I18N.popup_setting_broadcast.localized
		passwordLabel.text = I18N.ui_broadPassword.localized
		viewCountLabel.text = I18N.ui_broadViewerCount.localized
				
        titleTextInput.lineColor.normal = defaultLineColor
        titleTextInput.lineMargin = 0
        passwordTextInput.lineColor.normal = defaultLineColor
        passwordTextInput.lineMargin = 0
        
        titleTextInput.delegate = self
        passwordTextInput.delegate = self
        
        passwordCheckButton.isSelected = false
        
        adultSwitch.tintColor = popupMainColor
        adultSwitch.onTintColor = popupMainColor
        viewerNumSlider.thumbTintColor = textFieldLineEditColor
        viewerNumSlider.tintColor = textFieldLineEditColor
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardChanged(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapToHideKeyboard(_:)))
        self.addGestureRecognizer(tap)
        
        if enableAdultCast == false {
            adultCastLabel.heightAnchor.constraint(equalToConstant: 0).isActive = true
            adultSwitch.heightAnchor.constraint(equalToConstant: 0).isActive = true
            adultSwitch.isHidden = true
        }
                
        textFields = [ titleTextInput, passwordTextInput ]
    }
	
    
    @objc func handleTapToHideKeyboard(_ sender: UITapGestureRecognizer) {
        self.endEditing(true)
    }
    
    @objc func keyboardChanged(notification : Notification) {
        
        if let userInfo = notification.userInfo {
            let animationTime = (userInfo["UIKeyboardAnimationDurationUserInfoKey"] as! NSNumber).doubleValue
            let keyboardRect = (userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
            
            var moveValue : CGFloat = 0

            let focusView = textFields.first { (field) -> Bool in
                return field.isEditing
            }
            if focusView != nil {
                if keyboardRect.origin.y < focusView!.frame.origin.y + focusView!.frame.height + self.frame.origin.y {
                    moveValue = focusView!.frame.origin.y + focusView!.frame.height - keyboardRect.origin.y + self.frame.origin.y + 25
                }
            }
            
            let trans = CATransform3DMakeTranslation(0, -moveValue, 0)
            UIView.animate(withDuration: animationTime, animations: {
                self.layer.transform = trans
            })
        }
    }
    
    func setup(broadcastInfo : BCPrepareInfo) {
        // BCPrepareInfo class 참조값이다.
        castInfo     = broadcastInfo
        isAdult      = castInfo.isAdult
        maxViewerCount = castInfo.viewerCnt
        
        if castInfo.password != "" {
            passwordTextInput.text = castInfo.password
            passwordCheckButton.isSelected = true
        } else {
            passwordTextInput.text = ""
            passwordCheckButton.isSelected = false
        }
        
        titleTextInput.text = castInfo.title
        
        viewersNumLabel.text = "\(maxViewerCount)" + I18N.ui_numOfPerson.localized
        viewerNumSlider.value = Float( maxViewerCount / 10 )
        adultSwitch.isOn = self.isAdult
        
    }
    
    override func updateFrame() {
        orgSize = self.frame.size
    }
    
    func closeup() {
        self.hide()
        NotificationCenter.default.removeObserver(self)
        self.doneAction = { info in }
    }
    
    override func cancelAction(_ sender: AnyObject) {
        dispatchMain.async {
            popupManager.hide(popup: self)
            self.closeup()
        }
    }
    
    override func okAction(_ sender: AnyObject) {
        if self.checkInputInfo() == false {
            return
        }
        
        if let title = titleTextInput.text {
            castInfo.title = title
        }
        if let pw = passwordTextInput.text {
            castInfo.password = pw
        } else {
            castInfo.password = ""
        }
        
        castInfo.isAdult    = self.isAdult
        castInfo.viewerCnt  = self.maxViewerCount
        
        //self.closeup()
        self.doneAction(castInfo)
        
        dispatchMain.async {
            popupManager.hide(popup: self)
            self.closeup()
        }
    }
    
    override func closePopup() {
        self.resignFirstResponder()
        dispatchMain.async {
            self.cancelAction(self)
        }
    }
    
    func checkInputInfo() -> Bool {
        
        // 공백체크
        guard let titleText = titleTextInput.text else {
            return false
        }
        
        let reducedTitle = titleText.replacingOccurrences(of: " ", with: "")
        if reducedTitle.count < 1 {
            self.makeToast(I18N.text_inputCastTitle.localized, duration: 1.0, position: .center)
            return false
        }
        
        if passwordCheckButton.isSelected {
            guard let secretText = passwordTextInput.text else {
                return false
            }
            let reducedSecret = secretText.replacingOccurrences(of: " ", with: "")
            if reducedSecret.count < 1 {
                self.makeToast(I18N.cast_needPassword.localized, duration: 1.0, position: .center)
                return false
            }
        }
         
        return true
    }
    
    @IBAction func chkBtnClicked(_ sender: UIButton) {
        passwordCheckButton.isSelected = !passwordCheckButton.isSelected
        if !passwordCheckButton.isSelected {
            passwordTextInput.text = ""
        }
    }
    
    @IBAction func adultSwitchChangedAction(_ sender: AnyObject) {
        self.isAdult = adultSwitch.isOn
    }
    @IBAction func sliderChanged(_ sender: UISlider) {
        self.maxViewerCount = Int(sender.value) * 10
        viewersNumLabel.text = "\(self.maxViewerCount)" + I18N.ui_numOfPerson.localized
    }
}


extension EditBroadSettingPopupView : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let oneLineField = textField as? OneLineTextField {
            oneLineField.lineColor.normal = UIColor.celuvPupleColor()
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let oneLineField = textField as? OneLineTextField {
            oneLineField.lineColor.normal = defaultLineColor
        }
    }
    
    
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

        if textField == passwordTextInput {
            let cs = NSCharacterSet(charactersIn: legalSecretText).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            if string != filtered {
                return false
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
        
        let maxNums = textField == titleTextInput ? self.maximumLengthOfTitle : self.maximumLengthOfPassword
        
        return newLength <= maxNums
    }
}
