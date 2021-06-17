//
//  UserControlView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 11. 21..
//  Copyright © 2017년 roy. All rights reserved.
//
// 닫기 . 매니져임명해제 신고 강퇴
class UserControlView: UIView {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var fanLevelLabel: UILabel!
    @IBOutlet weak var managerLabel: UILabel!
    
    @IBOutlet weak var fanLvImageView: UIImageView!
    @IBOutlet weak var managerButton: RoundButton!
    @IBOutlet weak var blockButton: RoundButton!
    @IBOutlet weak var reportButton: RoundButton!
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var buttonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonCenterConstraint: NSLayoutConstraint!
    @IBOutlet weak var fanLvImageWidthConstraint: NSLayoutConstraint!
    var defaultLvImageWidth : CGFloat = 0
    
    var onChangeManager : (_ user: Message) -> Void = { user in }
    var onBlockUserAction : (_ user: Message) -> Void = { user in }
    var onReportUserAction : (_ user: Message) -> Void = { user in }
    var onExitAction : () -> Void = {  }
    
    private var userInfo : Message? = nil
    private var defaultProfileSize = CGSize()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
    }
    
    private func initFromXIB() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "UserControlView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        
        self.frame.size = CGSize(width: self.frame.width, height:  contentView.frame.height)
        
        contentView.backgroundColor = mainColor
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        self.addSubview(contentView)
        
        managerButton.setRoundBorder(with: roundBorderColor)
        managerButton.setRoundText(with: roundTextColor)
        blockButton.setRoundBorder(with: roundBorderColor)
        blockButton.setRoundText(with: roundTextColor)
        reportButton.setRoundBorder(with: roundBorderColor)
        reportButton.setRoundText(with: roundTextColor)
        
        managerLabel.text = I18N.text_manager.localized
        blockButton.setTitle(I18N.text_quit.localized, for: .normal)
        reportButton.setTitle(I18N.text_warn.localized, for: .normal)
        
        defaultLvImageWidth = fanLvImageWidthConstraint.constant
        managerLabel.isHidden = true
        managerLabel.setLayerOutLine(borderWidth: 2, cornerRadius: 5, borderColor: #colorLiteral(red: 0.8667, green: 0.0078, blue: 0.3529, alpha: 1) )
//        profileImageView.setLayerOutLine(borderWidth: 1, cornerRadius: 4, borderColor: UIColor.darkGray )
//        profileImageView.contentMode = .scaleAspectFill
        defaultProfileSize = profileImageView.frame.size
    }
    
    func setup(info : Message, profileURL: String, showManagerButton: Bool ) {
        
        userInfo = info
        
        if profileURL.isEmpty {
            profileImageView.image = #imageLiteral(resourceName: "profile")
            profileImageView.frame.size = defaultProfileSize
            profileImageView.setLayerOutLine(borderWidth: 0, cornerRadius: 0, borderColor: UIColor.clear )
            self.profileImageView.layer.transform = CATransform3DIdentity
        } else {
            profileImageView.setLayerOutLine(borderWidth: 1, cornerRadius: 4, borderColor: UIColor.darkGray )
            profileImageView.contentMode = .scaleAspectFill
            profileImageView.sd_setImage(with: URL(string: profileURL.urlQueryAllowedString), completed: { (image, error, cacheType, url) in
                dispatchMain.async {
                    if let img = image {
                        let ratio = img.size.height / img.size.width
                        let newHeight = ratio * self.profileImageView.frame.width
                        self.profileImageView.frame.size = CGSize(width: self.profileImageView.frame.width, height: newHeight)
                        
                        let trans = CATransform3DMakeTranslation(0,  (self.defaultProfileSize.height-newHeight)*0.5, 0)
                        self.profileImageView.layer.transform = trans
                    }
                }
            })
        }
        
        let nickColor = getNickType(accountLevel: info.accountLevel, sex: info.userGender)
        nicknameLabel.attributedText = NSAttributedString(string: info.username, attributes: [NSAttributedString.Key.font: UIFont.notoMediumFont(ofSize: 20) ,NSAttributedString.Key.foregroundColor: UIColor(hexString: nickColor.getColorString())])
        userIDLabel.attributedText = NSAttributedString(string: "(\(info.userId))", attributes: [NSAttributedString.Key.font: UIFont.notoMediumFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor.gray])
        
        managerLabel.isHidden = true
        if showManagerButton {
            managerButton.isHidden = false
            reportButton.isHidden = false
            managerButton.setTitle(I18N.text_assignManager.localized, for: .normal)
            if let accountLv = Int(info.accountLevel) {
                if let account = CWAccountLevel(rawValue: accountLv) {
                    if account == .manager {
                        managerLabel.isHidden = false
                        managerButton.setTitle(I18N.text_dismissManager.localized, for: .normal)
                    }
                }
            }
        } else {
            managerButton.isHidden = true
            //reportButton.isHidden = true
            //buttonWidthConstraint.constant = 120
            buttonCenterConstraint.constant = -55
        }
        
        
        var bNeedHide = true
        if let fanLv = Int(info.fanLevel) {
            if let fanLevel = FanLevel(rawValue: fanLv) {
                
                switch fanLevel {
                case .none: fanLevelLabel.text = fanLevel.stringValue()
                default:
                    fanLevelLabel.text = fanLevel.stringValue() + " \(I18N.text_grade.localized)"
                }
                fanLvImageView.image = fanLevel.iconImage()
                fanLvImageWidthConstraint.constant = defaultLvImageWidth
                if fanLevel != .none {
                    bNeedHide = false
                }
            }
        }
        
        if bNeedHide {
            fanLvImageWidthConstraint.constant = 0
            fanLevelLabel.text = I18N.text_nofanlevel.localized
        }
        
    }
    
    func unSetup() {
        userInfo = nil
        onChangeManager = { msg in }
        onBlockUserAction = { msg in }
        onReportUserAction = { msg in }
        onExitAction = {  }
    }
    
    private func getAttributText(nameText: String, nameColor: UIColor, idText: String, idColor: UIColor) -> NSAttributedString? {
        let totalAttributedStr = NSMutableAttributedString()
        
        let idFont = UIFont.notoMediumFont(ofSize: 14)
        if nameText.isEmpty == false {
            let nickAttr = NSAttributedString(string: nameText, attributes: [NSAttributedString.Key.font: UIFont.notoMediumFont(ofSize: 17) ,NSAttributedString.Key.foregroundColor: nameColor])
            totalAttributedStr.append(nickAttr)
        }
        
        let idAttr = NSAttributedString(string: idText, attributes: [NSAttributedString.Key.font: idFont,NSAttributedString.Key.foregroundColor: idColor])
        totalAttributedStr.append(idAttr)
        return totalAttributedStr
    }
    
    @IBAction func doExitAction(_ sender: Any) {
        onExitAction()
    }
    @IBAction func doChangeManager(_ sender: Any) {
        guard let user = userInfo else {
            onExitAction()
            return
        }
        onChangeManager(user)
    }
    @IBAction func doReportUser(_ sender: Any) {
        guard let user = userInfo else {
            onExitAction()
            return
        }
        onReportUserAction(user)
    }
    @IBAction func doBlockUser(_ sender: Any) {
        guard let user = userInfo else {
            onExitAction()
            return
        }
        onBlockUserAction(user)
    }
    
    func getNickType(accountLevel: String, sex: String) -> NickTextColor
    {
        var nickType = NickTextColor.boy
        switch accountLevel {
        case "0":
            fallthrough
        case "2":
            fallthrough
        case "4":
            if(sex == "1"){
                nickType = .boy
            }else{
                nickType = .girl
            }
        case "1":
            if(sex == "1"){
                nickType = .masterBoy
            }else{
                nickType = .masterGirl
            }
        case "3":
            nickType = .boy
        default:
            break
        }
        return nickType
    }
}
