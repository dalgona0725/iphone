//
//  PolicyPopupView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 10. 12..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit
import UserNotifications


class PolicyPopupView : PopupView {
    let mainTitle = String(format:I18N.text_loginPolicyMainTitle.localized, appName)
    let loginPolicyTitle = I18N.text_loginPolicySubTitle01.localized
    let loginPolicyContent = String(format:I18N.text_loginPolicyContent.localized, appName, appName, appName, appName, appName)
    
    let broadcastPolicyTitle = I18N.text_loginPolicySubTitle02.localized
    let broadcastPolicyContent = String(format:I18N.text_broadcastPolicyContent.localized, coinName)
    
    let eventPushTitle = I18N.text_eventPushTitle.localized
    let eventPushContent = String(format:I18N.text_eventPushContent.localized, appName)

    
    @IBOutlet weak var mainTitleLabel: UILabel!
    //@IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var topTextView: UITextView!
    @IBOutlet weak var topCheckButton: UIButton!
    
    //@IBOutlet weak var bottomTitleLabel: UILabel!
    @IBOutlet weak var bottomTextView: UITextView!
    @IBOutlet weak var bottomCheckButton: UIButton!
    @IBOutlet weak var bottonDisagreeButton: UIButton!
    
    @IBOutlet weak var allConfirmButton: UIButton!
	
	@IBOutlet weak var topAgreeLabel: UILabel!
	@IBOutlet weak var bottomAgreeLabel: UILabel!
	@IBOutlet weak var notAgreeLabel: UILabel!
	
    
    let defaultWidth = UIScreen.main.bounds.width
    let defaultHeight = UIScreen.main.bounds.height
    
    var buttonActions : [(_ checked : Bool)->Void] = []
    
    var enablePushService : Bool = false
    
    //MARK: - Class Func
    class func instanceFromNib() -> PolicyPopupView {
        return (Bundle.main.loadNibNamed("PolicyPopupView", owner: self, options: nil)![0] as? PolicyPopupView)!
    }
    
    //MARK: - UI Setup
    func setup() {
        self.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        
        mainTitleLabel.text = mainTitle
        mainTitleLabel.textColor       = popupOkButtonColor
        mainTitleLabel.backgroundColor = popupMainColor
        allConfirmButton.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        self.backgroundColor = .black
        
        //topTitleLabel.text = broadcastPolicyTitle
        let broadcastPolicy = NSMutableAttributedString()
        let policyStep01 = getItemText(title: loginPolicyTitle, titleColor: UIColor.black, bodyText: loginPolicyContent, bodyColor: UIColor.darkGray)
        let policyStep02 = getItemText(title: broadcastPolicyTitle, titleColor: UIColor.black, bodyText: broadcastPolicyContent, bodyColor: UIColor.darkGray)
        
        if policyStep01 != nil && policyStep02 != nil {
            broadcastPolicy.append(policyStep01!)
            broadcastPolicy.append(NSAttributedString(string: "\n\n\n"))
            broadcastPolicy.append(policyStep02!)
            topTextView.attributedText = broadcastPolicy
        } else {
           topTextView.text = loginPolicyContent + "\n" + loginPolicyContent + "\n\n\n" + broadcastPolicyTitle + "\n" + broadcastPolicyContent
        }
        topTextView.sizeToFit()
        topTextView.setLayerOutLine(borderWidth: 0, cornerRadius: 3, borderColor: UIColor.gray)
        
        //bottomTitleLabel.text = loginPolicyTitle
        //bottomTextView.text = loginPolicyContent
        if let eventPushPolicy = getItemText(title: eventPushTitle, titleColor: UIColor.black, bodyText: eventPushContent, bodyColor: UIColor.darkGray) {
            bottomTextView.attributedText = eventPushPolicy
        } else {
            bottomTextView.text = eventPushContent + "\n" +  eventPushContent
        }
        bottomTextView.sizeToFit()
        bottomTextView.setLayerOutLine(borderWidth: 0, cornerRadius: 3, borderColor: UIColor.gray)
        
        self.frame = CGRect(x: 0, y: 0, width: Int(defaultWidth), height: Int(defaultHeight))
        
        // 푸쉬 알림 : 푸쉬 가능 여부 체크
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { setting in
            if setting.alertSetting != .enabled {
                self.enablePushService = false
            } else {
                self.enablePushService = true
            }
        }
        
        /*
        appData.updateNotifiaction(completed: { (enablePush) in
            if enablePush {
                self.bottomCheckButton.isEnabled = true
            } else {
               self.bottomCheckButton.isEnabled = false
            }
        }) */
        
		topAgreeLabel.text = I18N.popup_agree.localized
		bottomAgreeLabel.text = I18N.popup_agree.localized
		notAgreeLabel.text = I18N.popup_not_agree.localized
		allConfirmButton.setTitle(I18N.ui_ok.localized, for: .normal)
    }
    
    private func getItemText(title: String, titleColor: UIColor, bodyText: String, bodyColor: UIColor) -> NSAttributedString? {
        let totalAttributedStr = NSMutableAttributedString()
        if title.isEmpty == false {
            let titleAttr = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: UIFont.notoMediumFont(ofSize: 17) ,NSAttributedString.Key.foregroundColor: titleColor, NSAttributedString.Key.writingDirection: [NSWritingDirection.leftToRight.rawValue | NSWritingDirectionFormatType.override.rawValue], NSAttributedString.Key.underlineStyle: 1 ])
            totalAttributedStr.append(titleAttr)
        }
        totalAttributedStr.append(NSAttributedString(string: "\n"))
        
        let idAttr = NSAttributedString(string: bodyText, attributes: [NSAttributedString.Key.font: UIFont.notoFont(ofSize: 14),NSAttributedString.Key.foregroundColor: bodyColor])
        totalAttributedStr.append(idAttr)
        return totalAttributedStr
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        dispatchMain.async {
            self.topTextView.isScrollEnabled = false
            self.topTextView.isScrollEnabled = true
            self.topTextView.setContentOffset(CGPoint.zero, animated: false)

            self.bottomTextView.isScrollEnabled = false
            self.bottomTextView.isScrollEnabled = true
            self.bottomTextView.setContentOffset(CGPoint.zero, animated: false)
        }
    }
    
    
    @IBAction func allConfirm(_ sender: Any) {
        
        if topCheckButton.isSelected && (bottomCheckButton.isSelected || bottonDisagreeButton.isSelected) {
            self.hide()
            if self.buttonActions.count > 0 {
                self.buttonActions[0](bottomCheckButton.isSelected)
            }
            self.buttonActions.removeAll()
        } else {
            self.makeToast(I18N.text_needAgreement02.localized, duration: 1.0, position: .center)
        }
        
    }
    
    func updateConfirmButton(sender: UIButton) {
        if sender.isSelected {
            if sender == bottomCheckButton {
                bottonDisagreeButton.isSelected = false
            } else if sender == bottonDisagreeButton {
                bottomCheckButton.isSelected = false
            }
        }
        
        if topCheckButton.isSelected && (bottomCheckButton.isSelected || bottonDisagreeButton.isSelected) {
            UIView.animate(withDuration: 0.5, animations: {
                self.allConfirmButton.backgroundColor = popupMainColor
				self.allConfirmButton.setTitleColor(popupOkButtonColor, for: .normal)
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.allConfirmButton.backgroundColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
				self.allConfirmButton.setTitleColor(.darkText, for: .normal)
            })
        }
    }
    
    @IBAction func checkPolicy(_ sender: UIButton) {
        if sender == bottomCheckButton {
            appData.updateNotifiaction(completed: { (enablePush) in
                if enablePush {
                    sender.isSelected = !sender.isSelected
                    self.updateConfirmButton(sender: sender)
                } else {
                    
                    self.makeToast(I18N.text_needPushOn.localized, duration: 1.0, position: .center)
                    /*
                    popupManager.showAlert(content: "알림 기능이 꺼져 있습니다. 확인을 누르시면 설정으로 이동합니다.", buttonTitles: ["확인","취소"], buttonActions: [{
                        if UIApplicationOpenSettingsURLString.isEmpty == false  {
                            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                                UIApplication.shared.openURL(url)
                            }
                        }
                        },{}])
                    */
                }
            })
        } else {
            sender.isSelected = !sender.isSelected
            updateConfirmButton(sender: sender)
        }
    }
    
    override func closePopup() {
        dispatchMain.async {
            self.hide()
            self.buttonActions.removeAll()
        }
    }
}

