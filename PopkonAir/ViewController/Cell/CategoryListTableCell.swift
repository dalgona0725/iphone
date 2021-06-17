//
//  CategoryListTableCell.swift
//  PopkonAir
//
//  Created by Steven on 14/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage

class CategoryListTableCell: UITableViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!

    @IBOutlet weak var fanImageView: UIImageView!
    @IBOutlet weak var chargeImageView: UIImageView!
    @IBOutlet weak var mcLevelIcon: LevelIconButton!
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var hotIconImageView: UIImageView!
    @IBOutlet var flagImageViews: [UIImageView]!
    @IBOutlet weak var previewButton: UIButton!
    
    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    @IBOutlet weak var gifImageBackgorundView: UIView!
    
    var previewAction : (_ sender : UIButton)->Void = {send in}
    
    private(set) public var cast : CastInfo = CastInfo()
    
    private(set) public var mcVOD : MCInfo = MCInfo()
    
    private(set) public var celuvVOD : CeluvVODInfo = CeluvVODInfo()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    open func setInfo(cast : CastInfo) {
        
        self.cast = cast
        
        self.updateContent()
    }
    
    open func setInfo(category : CategoryInfo) {
        
        self.postImageView.sd_setImage(with: URL(string: category.basicThumb), placeholderImage:basicLogoImage )
        
        self.postTitleLabel.text = "\(category.week) \(category.time)"
        
        self.authorLabel.text = category.label
        
        self.timeLabel.text = ""
        
        hotIconImageView.isHidden = true
        //lockIconImageView.isHidden = true
        
        for imageView in flagImageViews {
            imageView.isHidden = true
        }
        
        previewButton.isHidden = true
        
        infoView.isHidden = true
    }
    
    open func setInfo(celuv: CeluvVODInfo) {
        self.celuvVOD = celuv
        self.updateCeluvVODInfo()
    }
    
    open func setInfo(vod : MCInfo) {
        self.mcVOD = vod
        self.updateMcInfo()
    }
    
    private func updateCeluvVODInfo() {
        showAnniversaryEffect(show: false )
        
        var randomImage = appData.defProImage.getImage(with: "default")
        if appData.defProImage.images.isEmpty == false {
            let index = Int(arc4random_uniform(UInt32(appData.defProImage.images.count)))
            randomImage = Array(appData.defProImage.images.values)[index]
        }
        guard let vodThumnail = celuvVOD.vodThumnail else { return }
		
        self.postTitleLabel.text = celuvVOD.vodTitle
        self.authorLabel.text = celuvVOD.vodOwner
        self.postImageView.sd_setImage(with: URL(string: vodThumnail), placeholderImage:randomImage )
        self.timeLabel.text = ""
        
        if previewButton != nil {
            previewButton.isHidden = true
        }
        
        if hotIconImageView != nil {
            hotIconImageView.isHidden = true
        }
        
        flagImageViews.forEach { (imgView) in
            imgView.isHidden = true
        }
        
        self.hideCastAttribute()
    }
    
    private func updateMcInfo() {
        loadAnniversaryEffect(url: cast.anniversaryImgFile, gifView: gifImageView)
        
        var randomImage = appData.defProImage.getImage(with: "default")
        if appData.defProImage.images.isEmpty == false {
            let index = Int(arc4random_uniform(UInt32(appData.defProImage.images.count)))
            randomImage = Array(appData.defProImage.images.values)[index]
        }
        
        if mcVOD.nickname.isEmpty == false {
            let str = NSMutableAttributedString(string: mcVOD.nickname, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.black ])
            let add = NSAttributedString(string: I18N.mc_fanclub.localized, attributes: [NSAttributedString.Key.font : UIFont.notoFont(ofSize: 13) , NSAttributedString.Key.foregroundColor : UIColor.darkGray ])
            
            str.append(add)
            self.postTitleLabel.attributedText = str
        }

        self.authorLabel.text = String(format: I18N.ui_numOfContent.localized, mcVOD.vodCnt)
        self.postImageView.sd_setImage(with: URL(string: mcVOD.pFileName), placeholderImage:randomImage )
        
        let timeText = CellUtil.getDateString(with: mcVOD.maxDate.replacingOccurrences(of: "-", with: ""))  + " | " + CellUtil.getNumberCommaFormat(text: mcVOD.viewCnt) + I18N.text_viewerCount.localized
        self.timeLabel.text = timeText
        self.timeLabel.adjustsFontSizeToFitWidth = true
        self.timeLabel.minimumScaleFactor = 0.8

        if previewButton != nil {
            previewButton.isHidden = true
        }
        
        if hotIconImageView != nil {
            hotIconImageView.isHidden = true
        }
    
        flagImageViews.forEach { (imgView) in
            imgView.isHidden = true
        }
        
        self.hideCastAttribute()
    }
    
    
    //MARK: - Update content
    func updateContent() {
        loadAnniversaryEffect(url: cast.anniversaryImgFile, gifView: gifImageView)
        
        infoView.isHidden = false
                
        self.postTitleLabel.attributedText = nil
        if cast.isAdult && userInfo.isNameCheck == false {
            //self.postImageView.backgroundColor = UIColor.darkGray
            //self.postImageView.image = nil
            self.postTitleLabel.text = I18N.err_needAdultCertForUse.localized
        } else {
            //Cast name
            self.postTitleLabel.text = cast.castTitle
        }
        
        if cast.isCommerce {
            let title = self.postTitleLabel.text ?? ""
            let attributesDictionary = [NSAttributedString.Key.font : self.postTitleLabel.font]
            let fullAttributedString = NSMutableAttributedString(string: "", attributes: attributesDictionary as [NSAttributedString.Key : Any])
            
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = #imageLiteral(resourceName: "IcoCommerce")
            let size = imageAttachment.image?.size ?? .zero
            let mid = (self.postTitleLabel.font.capHeight - size.height) * 0.5
            imageAttachment.bounds = CGRect(x: 0, y: mid, width: size.width, height: size.height)
            let attrString = NSAttributedString(attachment: imageAttachment)
            let fullString = NSMutableAttributedString(attributedString: attrString)
            fullString.append(NSAttributedString(string:"\t" + title,attributes: attributesDictionary as [NSAttributedString.Key : Any]))
            
            var paragraphStyle: NSMutableParagraphStyle
            let interval: CGFloat = 25
            paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: interval, options: NSDictionary() as! [NSTextTab.OptionKey : AnyObject])]
            paragraphStyle.defaultTabInterval = interval
            paragraphStyle.firstLineHeadIndent = 0
            paragraphStyle.headIndent = interval
            fullString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, fullString.length))
            fullAttributedString.append(fullString)
            self.postTitleLabel.attributedText = fullAttributedString
        }
        
        //Cast Image
        self.postImageView.sd_setImage(with: URL(string: cast.pFileName), placeholderImage:basicLogoImage )
        self.postImageView.backgroundColor = UIColor.clear
        
        //MC nickname
        self.authorLabel.text = cast.nickName
        
        //info
        self.timeLabel.attributedText = CellUtil.getTimeAndWatchCntAttributeString(from: cast)
        
        //Hot
        switch cast.castListNum {
        case .normal:
            hotIconImageView.isHidden = true
        case .bronze:
            hotIconImageView.isHidden = true
            //hotIconImageView.image = UIImage(named: "hot_icon3")
        //lockTopConstraint.constant = 3 + 19//hotIconImageView.frame.height
        case .silver:
            hotIconImageView.isHidden = false
            hotIconImageView.image = UIImage(named: "ico_silver")
        //lockTopConstraint.constant = 3 + 19//hotIconImageView.frame.height
        case .gold:
            hotIconImageView.isHidden = false
            hotIconImageView.image = UIImage(named: "ico_gold")
            //lockTopConstraint.constant = 3 + 19//hotIconImageView.frame.height
        case .special:
            hotIconImageView.isHidden = true
        }
        
        //Flag Icon
        let flags : [FlagType] = self.getFlags()
        var imageSet = [UIImage]()
        if flags.contains(.adult) {
            imageSet.append(#imageLiteral(resourceName: "ico_19"))
        }
        if cast.isPrivate {
            imageSet.append(#imageLiteral(resourceName: "ico_lock"))
        }
        flagImageViews.forEach { (imgView) in
            imgView.isHidden = true
        }
        for (i,img) in imageSet.enumerated() {
            flagImageViews[i].isHidden = false
            flagImageViews[i].image = img
        }
        
        fanImageView.isHidden = flags.contains(.fan) ? false : true
        chargeImageView.isHidden = flags.contains(.pay) ? false : true
        mcLevelIcon.setupLevelInfo(type: .mc, level: cast.levelMC)
        
        self.previewButton.isHidden = true
        self.layoutIfNeeded()
    }
    
    func hideCastAttribute() {
        if hotIconImageView != nil {
            hotIconImageView.isHidden = true
        }
        flagImageViews.forEach { (imgView) in
            imgView.isHidden = true
        }
        
        fanImageView.isHidden = true
        chargeImageView.isHidden = true
        mcLevelIcon.setupLevelInfo(type: .mc, level: 0)
    }
    
    //MARK: - IBAction
    @IBAction func previewAction(_ sender: AnyObject) {
        previewAction(sender as! UIButton)
    }
    
    //MARK: - Private
    fileprivate func getTimeText(dateString : String) -> String {
        let subStr1 = dateString
        let str1 = subStr1[subStr1.index(subStr1.startIndex, offsetBy: 8)...subStr1.index(subStr1.startIndex, offsetBy: 9)]
        let str2 = subStr1[subStr1.index(subStr1.startIndex, offsetBy: 10)...subStr1.index(subStr1.startIndex, offsetBy: 11)]
        var strTime = ""
        
        if Int(str1)! > 12 {
            let strCalc = Int(str1)! - 12
            strTime = "PM " + String(strCalc) + ":" + str2 + " | "
        }else{
            strTime = "AM " + str1 + ":" + str2 + " | "
        }
        
        return strTime
    }
    
    fileprivate func getFlags()-> [FlagType] {
        var flags : [FlagType] = []
        if cast.castType == .pay {
            flags.append(.pay)
        }
        if cast.castType == .fanClub {
            flags.append(.fan)
        }
        if cast.isAdult {
            flags.append(.adult)
        }
        return flags
    }
    
    //MARK: - Anniversary Load & Show
    private func loadAnniversaryEffect(url: String, gifView: FLAnimatedImageView) {
        if url.isEmpty {
            return showAnniversaryEffect(show: false)
        }
        if let fileURL = URL(string: url) {
            gifView.setImage(with: fileURL)
            showAnniversaryEffect(show: true)
        } else {
            log.debug("No file with specified name exists - \(url)")
            showAnniversaryEffect(show: false)
        }
    }
    
    private func showAnniversaryEffect(show: Bool) {
        gifImageView.isHidden           = show ? false : true
        gifImageBackgorundView.isHidden = show ? false : true
    }
}
