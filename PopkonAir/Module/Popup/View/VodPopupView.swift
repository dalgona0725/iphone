//
//  VodPopupView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 7. 14..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit
import SDWebImage
import ReachabilitySwift

struct VodPopupAction {
    var join    : ()->Void = {}
    var buy     : ()->Void = {}
    var cancel  : ()->Void = {}
}

class VodPopupView: PopupView {
    
    private let defaultContentHeight = 46
    private let defaultViewHeight = 250
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var mcNameLabel: UILabel!
    @IBOutlet weak var vodNameLabel: UILabel!
    //@IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var joinButton: UIButton!
    @IBOutlet weak var buyButton: UIButton!
    
    @IBOutlet weak var titleBar: UIView!
    
    @IBOutlet weak var fanTitleLabel: UILabel!
    @IBOutlet weak var fanLevelLabel: UILabel!
    @IBOutlet weak var needCoinLabel: UILabel!
    @IBOutlet weak var myCoinLabel: UILabel!
    @IBOutlet weak var fanLevelImage: UIImageView!
    
    @IBOutlet weak var needCoinTitleLabel: UILabel!
    @IBOutlet weak var myCoinTitleLabel: UILabel!
    
    var buttonAction : VodPopupAction = VodPopupAction()
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
    class func instanceFromNib() -> VodPopupView {
        return (Bundle.main.loadNibNamed("VodPopupView", owner: self, options: nil)![0] as? VodPopupView)!
    }
    
    //MARK: - UI Setup
    func setup(vod:VODInfo, myInfo: FanMCInfo, netStatus: Reachability.NetworkStatus) {
        
        self.setLayerOutLine(borderWidth: 1, cornerRadius: 3)
        
        vodNameLabel.text = vod.title
        mcNameLabel.text  = vod.nickname
    
        profileImage.sd_setImage(with: URL(string: vod.pFileName))
        
        var infoText = ""
        var defaultText = ""
        let totalAttributedStr = NSMutableAttributedString()
        //infoText = "  \(myInfo.needCoin)개"
        //defaultText = "\(coinName) 가입이 필요한 컨텐츠입니다.\n\n"
        
        if infoText.isEmpty == false {
            let textRange = NSMakeRange(0, infoText.count)
            let add = NSMutableAttributedString(string: infoText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.red ])
            add.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            totalAttributedStr.append(add)
        }
        
        if defaultText.isEmpty == false {
            let textRange = NSMakeRange(0, defaultText.count)
            let add = NSMutableAttributedString(string: defaultText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 15), NSAttributedString.Key.foregroundColor : UIColor.black ])
            add.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            totalAttributedStr.append(add)
        }
        
        totalAttributedStr.append(NSAttributedString(string:noticeText + contentText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.black ]))
        
        if netStatus == .reachableViaWWAN && appData.isNoticeLTE {
            var addText = "\n\n"
            addText.append(lteText)
            totalAttributedStr.append(NSAttributedString(string: addText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 13), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.9725, green: 0.1882, blue: 0.1882, alpha: 1) ]))
        }
        contentTextView.attributedText = totalAttributedStr
        
        fanLevelLabel.text = myInfo.fanLevel.stringValue()
        
        fanLevelImage.image = myInfo.fanLevel.iconImage()
        
        needCoinLabel.text = CellUtil.getNumberCommaFormat(text: "\(myInfo.needCoin)") + "개"
        
        myCoinLabel.text = CellUtil.getNumberCommaFormat(text: "\(userInfo.coin)") + "개"
        
        self.changeInfoTextFont()
        
        //Update Frame
        self.updateFrame()
    }
    
    func setup(cast: CastInfo, castMember: CastMemberInfo, message: String, netStatus: Reachability.NetworkStatus) {
        vodNameLabel.text   = cast.castTitle
        mcNameLabel.text    = cast.nickName
        
        profileImage.sd_setImage(with: URL(string: cast.pFileName))
        
        //var infoText = ""
        var defaultText = ""
        let totalAttributedStr = NSMutableAttributedString()
        if cast.castType == .fanClub {
            joinButton.setTitle(I18N.ui_joinFanClub.localized, for: .normal)
            //infoText = "  \(castMember.watchFanLevel.stringValue())"
            //defaultText = "이상이 입장가능한 팬클럽 방송입니다.\n"
            //defaultText = message + "\n\n"
            fanLevelImage.image = castMember.fanLevel.iconImage()
        } else {
            joinButton.setTitle(String(format:I18N.ui_useCoin.localized, coinName), for: .normal)
            if cast.castType == .pay {
                //infoText = "  \(castMember.needCoin)개"
                //defaultText = "\(coinName) 유료 방송입니다.\n"
                //defaultText = message + "\n\n"
            }
            fanLevelImage.image = nil
        }
    
//        if infoText.isEmpty == false {
//            let textRange = NSMakeRange(0, infoText.characters.count)
//            let add = NSMutableAttributedString(string: infoText, attributes: [NSFontAttributeName : UIFont.notoMediumFont(ofSize: 18), NSForegroundColorAttributeName : UIColor.red ])
//            add.addAttribute(NSUnderlineStyleAttributeName , value: NSUnderlineStyle.styleSingle.rawValue, range: textRange)
//            totalAttributedStr.append(add)
//        }
        
        if defaultText.isEmpty == false {
            let textRange = NSMakeRange(0, defaultText.count)
            let add = NSMutableAttributedString(string: defaultText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 15), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0, green: 0.1961, blue: 0.2588, alpha: 1)  ])
            add.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
            totalAttributedStr.append(add)
        }
        
        var bAddedNotice = false
        if(cast.isAdult) {
            bAddedNotice = true
            totalAttributedStr.append(NSAttributedString(string:noticeText + contentText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.black ]))
        }
        
        if netStatus == .reachableViaWWAN && appData.isNoticeLTE {
            var addText = ""
            if bAddedNotice == false {
                totalAttributedStr.append(NSAttributedString(string:noticeText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 13), NSAttributedString.Key.foregroundColor : UIColor.black ]))
            } else {
                addText = "\n\n"
            }
            addText.append(lteText)
            totalAttributedStr.append(NSAttributedString(string: addText, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 13), NSAttributedString.Key.foregroundColor :#colorLiteral(red: 0.9725, green: 0.1882, blue: 0.1882, alpha: 1)  ]))
        }
        contentTextView.attributedText = totalAttributedStr
        
        
        let bHide = cast.castType == .pay ? true : false
        fanTitleLabel.isHidden = bHide
        fanLevelLabel.isHidden = bHide
        fanLevelImage.isHidden = bHide
        
        self.changeInfoTextFont()
        
        fanLevelLabel.text = castMember.fanLevel.stringValue()
        
        needCoinLabel.text = CellUtil.getNumberCommaFormat(text: "\(castMember.needCoin)") + I18N.ui_numOfCoin.localized
        
        myCoinLabel.text = CellUtil.getNumberCommaFormat(text: "\(userInfo.coin)") + I18N.ui_numOfCoin.localized
        
        //Update Frame
        self.updateFrame()
    }
    
    func changeInfoTextFont() {
        fanTitleLabel.font = UIFont.notoFont(ofSize: 13)
        fanLevelLabel.font = UIFont.notoBoldFont(ofSize: 13)
        
        needCoinTitleLabel.font = UIFont.notoFont(ofSize: 13)
        myCoinTitleLabel.font = UIFont.notoFont(ofSize: 13)
        
        needCoinLabel.font = UIFont.notoFont(ofSize: 13)
        myCoinLabel.font = UIFont.notoFont(ofSize: 13)
    }
    
    func updateFrame() {
        
        titleBar.backgroundColor = popupMainColor
        joinButton.backgroundColor = popupMainColor
        vodNameLabel.textColor = titleTextColor
        mcNameLabel.textColor  = titleTextColor
        
        let size = self.contentTextView.sizeThatFits(CGSize(width: 300, height:400))
        //self.contentLabel.frame = CGRect(x: contentLabel.frame.minX, y: contentLabel.frame.minY, width: size.width, height: size.height)
        
        //Update Frame
        var heightChanged = Int(size.height) - defaultContentHeight
        let newHeight : CGFloat = CGFloat(defaultViewHeight + heightChanged + 4)
        if newHeight > UIApplication.shared.windows[0].frame.height {
            heightChanged = Int(UIApplication.shared.windows[0].frame.height) - Int(defaultViewHeight)
        }
    
        if defaultViewHeight + heightChanged != Int(self.frame.height) {
            let newFrame = CGRect(x: 0, y: 0, width: Int(self.frame.width), height: defaultViewHeight + heightChanged + 4)
            self.frame = newFrame
        }
    }
    
    @IBAction func joinAction(_ sender: AnyObject) {
        self.hide()
        buttonAction.join()
        self.buttonAction = VodPopupAction()
    }
    
    @IBAction func buyAction(_ sender: AnyObject) {
        self.hide()
        buttonAction.buy()
        self.buttonAction = VodPopupAction()
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        self.hide()
        buttonAction.cancel()
        self.buttonAction = VodPopupAction()
    }
    
    override func closePopup() {
        dispatchMain.async {
            self.cancelAction(self)
        }
    }

}
