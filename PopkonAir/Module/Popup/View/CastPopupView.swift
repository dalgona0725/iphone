//
//  CastPopupView.swift
//  PopkonAir
//
//  Created by Steven on 21/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SDWebImage
import ReachabilitySwift

struct ButtonAction {
    var ok      : ()->Void = {}
    var cancel  : ()->Void = {}
}

struct InputButtonAction {
    var ok      : (_ popup: PopupView, _ text : String)->Void = { (popup,text) in }
    var cancel  : ()->Void = {}
}


class CastPopupView: PopupView {
    
    ///ContentLabel Default Height
    private let defaultTopSectionHeight    : CGFloat = 90
    private let defaultButtonSectionHeight : CGFloat = 51
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var roomNameLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var mcLevelIcon: LevelIconButton!

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var pwTextField: OneLineTextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var titleBar: UIView!
    
    @IBOutlet weak var pwTextFieldHeight: NSLayoutConstraint!
    @IBOutlet weak var errorLabeldHeight: NSLayoutConstraint!
    
    @IBOutlet weak var contentLabeldTop: NSLayoutConstraint!
    @IBOutlet weak var contentLabeldBottom: NSLayoutConstraint!
    @IBOutlet weak var pwTextFieldBottom: NSLayoutConstraint!
    @IBOutlet weak var errorLabeldBottom: NSLayoutConstraint!

    @IBOutlet weak var loadSectionView: UIView!
    @IBOutlet weak var loadIndicator: UIActivityIndicatorView!
    

    var buttonAction : InputButtonAction = InputButtonAction()
    
    fileprivate let maximumLengthOfPassword = 10
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    let lteText = I18N.text_useLTEData.localized
    let noticeText = I18N.text_watchNotice.localized
    let contentText = I18N.text_watchContent.localized
    
    //MARK: - Class Func
    class func instanceFromNib() -> CastPopupView {
        return (Bundle.main.loadNibNamed("CastPopupView", owner: self, options: nil)![0] as? CastPopupView)!
    }
    
    //MARK: - UI Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardChanged(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapToHideKeyboard(_:)))
        self.addGestureRecognizer(tap)
		pwTextField.placeholder = I18N.text_Password.localized
    }
	
    func setup(celuv: CeluvVODInfo, netStatus: Reachability.NetworkStatus) {
        self.setLayerOutLine(borderWidth: 1, cornerRadius: 3)
        
        roomNameLabel.text = celuv.vodTitle
        nicknameLabel.text = celuv.vodOwner
        roomNameLabel.textColor = popupOkButtonColor
        nicknameLabel.textColor = popupOkButtonColor
        mcLevelIcon.setupLevelInfo(type: .mc, level: 0)
        
        titleBar.backgroundColor = popupMainColor
        okButton.backgroundColor = popupMainColor
		okButton.setTitleColor(popupOkButtonColor, for: .normal)
        
        pwTextField.isSecureTextEntry = true
        pwTextField.isHidden = true
//        pwTextFieldHeightContraint.constant = 0
        
		guard let vodThumnail = celuv.vodThumnail else { return }
		profileImageView.sd_setImage(with: URL(string: vodThumnail.urlQueryAllowedString))
        
        var bAddedNotice = false
        let totalAttributedStr = NSMutableAttributedString()
        /*
        if(cast.isAdult) {
            bAddedNotice = true
            totalAttributedStr.append(NSAttributedString(string:noticeText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.black ]))
            totalAttributedStr.append(NSAttributedString(string:contentText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.black ]))
        } */
        
        if netStatus == .reachableViaWWAN && appData.isNoticeLTE {
            var addText = ""
            if bAddedNotice == false {
                totalAttributedStr.append(NSAttributedString(string:noticeText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.black ]))
            } else {
                addText = "\n\n"
            }
            addText.append(lteText)
            totalAttributedStr.append(NSAttributedString(string: addText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 13), NSAttributedString.Key.foregroundColor :#colorLiteral(red: 0.9725, green: 0.1882, blue: 0.1882, alpha: 1) ]))
        }
        contentLabel.attributedText = totalAttributedStr
        //Update Frame
        self.updateFrame()
        
    }
    
    func setup(cast:CastInfo, netStatus: Reachability.NetworkStatus, error: String = "") {
        
        self.setLayerOutLine(borderWidth: 1, cornerRadius: 15)
        
        roomNameLabel.text = cast.castTitle
        nicknameLabel.text = cast.nickName
        roomNameLabel.textColor = popupOkButtonColor
        nicknameLabel.textColor = popupOkButtonColor
        mcLevelIcon.setupLevelInfo(type: .mc, level: cast.levelMC)
        
        titleBar.backgroundColor = popupMainColor
        okButton.backgroundColor = popupMainColor
        okButton.setTitleColor(popupOkButtonColor, for: .normal)
        
        self.hideLoadingView()
        
        pwTextField.isSecureTextEntry = true
		pwTextField.autocorrectionType = .no
        
		if cast.isPrivate {
            pwTextField.isHidden = false
            pwTextField.lineColor.normal = textFieldLineNormalColor // #colorLiteral(red: 0.9804, green: 0.2157, blue: 0.4863, alpha: 1)
            pwTextField.lineMargin = 0
        } else {
            pwTextField.isHidden = true
            pwTextFieldHeight.constant = 0
            pwTextFieldBottom.constant = 0
            contentLabeldBottom.constant = 0
        }
        errorLabel.text = ""
        errorLabel.isHidden = true
        errorLabeldHeight.constant = 0
        
        profileImageView.sd_setImage(with: URL(string: cast.pFileName.urlQueryAllowedString))
        profileImageView.setLayerOutLine(borderWidth: 0, cornerRadius: 2, borderColor: .clear)
        
        var bAddedNotice = false
        let totalAttributedStr = NSMutableAttributedString()
        if(cast.isAdult) {
            bAddedNotice = true
            totalAttributedStr.append(NSAttributedString(string:noticeText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 13), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1) ]))
            totalAttributedStr.append(NSAttributedString(string:contentText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 13), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1) ]))
        }
        
        if netStatus == .reachableViaWWAN && appData.isNoticeLTE {
            var addText = ""
            if bAddedNotice == false {
                totalAttributedStr.append(NSAttributedString(string:noticeText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 13), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1) ]))
            } else {
                addText = "\n\n"
            }
            addText.append(lteText)
            totalAttributedStr.append(NSAttributedString(string: addText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 13), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.8666666667, green: 0.2078431373, blue: 0.09411764706, alpha: 1) ]))
        }

        contentLabel.attributedText = totalAttributedStr
        
        //Update Frame
        self.updateBounds()
		
		okButton.setTitle(I18N.ui_ok.localized, for: .normal)
		cancelButton.setTitle(I18N.ui_cancel.localized, for: .normal)
    }
    
    func updateErrorText(error: String) {
        
        if error.isEmpty {
            errorLabel.text = ""
            errorLabel.isHidden = true
            errorLabeldHeight.constant = 0
        } else {
            errorLabel.text = error
            errorLabel.isHidden = false
        }
        
        self.updateBounds(animationDuration: 0.3)
    }
    
    func caculateViewHeight() -> CGFloat {
        let contentLength = self.contentLabel.attributedText?.length ?? 0
        var measuredContentHeight : CGFloat = contentLabeldTop.constant
        if contentLength > 0 {
            let size = self.contentLabel.sizeThatFits(CGSize(width: 280, height: 400))
            measuredContentHeight += size.height + contentLabeldBottom.constant + 10
        } else {
            contentLabeldBottom.constant = 0
        }
        
        measuredContentHeight += pwTextFieldHeight.constant
        measuredContentHeight += pwTextFieldBottom.constant
        
        let errorLength = self.errorLabel.text?.count ?? 0
        if errorLength > 0 {
            let size = self.errorLabel.sizeThatFits(CGSize(width: 280, height: 400))
            errorLabeldHeight.constant = size.height + 5
        } else {
            errorLabeldHeight.constant = 0
        }
        measuredContentHeight += errorLabeldHeight.constant
        measuredContentHeight += errorLabeldBottom.constant
        
        return defaultTopSectionHeight + defaultButtonSectionHeight + measuredContentHeight
    }
    
    func updateBounds(animationDuration: TimeInterval = 0.1) {
        let newHeight = caculateViewHeight()
        let newBounds = CGRect(x: 0, y: 0, width: self.frame.width, height: newHeight )
        UIView.animate(withDuration: animationDuration) {
            self.bounds = newBounds
        }
    }
    
    func updateFrame() {
        let newHeight = caculateViewHeight()
        let newFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: newHeight )
        self.frame = newFrame
    }
    
    func showLoadingView() {
        loadSectionView.isHidden = false
        loadIndicator.startAnimating()
    }
    
    func hideLoadingView() {
        loadSectionView.isHidden = true
        loadIndicator.stopAnimating()
    }
    
    
    //MARK: - IBAction Event Handler
    @IBAction func okAction(_ sender: AnyObject) {
        // self.hide()
        _ = self.pwTextField.resignFirstResponder()
        self.showLoadingView()
        buttonAction.ok(self, pwTextField.text ?? "")
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        _ = self.pwTextField.resignFirstResponder()
        self.hide()
        buttonAction.cancel()
    }
    
    override func closePopup() {
        dispatchMain.async {
            self.cancelAction(self)
        }
    }
    
    //MARK: - Keyboard Event
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
}

extension CastPopupView : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text!.count > 0 {
            _ = textField.resignFirstResponder()
            buttonAction.ok(self, textField.text ?? "")
        }
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= maximumLengthOfPassword
    }
    
}
