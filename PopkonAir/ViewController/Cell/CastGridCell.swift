//
//  CastGridCell.swift
//  PopkonAir
//
//  Created by Steven on 03/01/2017.
//  Copyright © 2017 roy. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage

class CastGridCell: UICollectionViewCell {
    
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var textContainer: UIView!
    @IBOutlet weak var textBackPanelImageView: UIImageView!
    
    @IBOutlet weak var fanImageView: UIImageView!
    @IBOutlet weak var chargeImageView: UIImageView!
    @IBOutlet weak var fanCastImageWidth: NSLayoutConstraint!
    @IBOutlet weak var paidCastImageWidth: NSLayoutConstraint!
    @IBOutlet var authonLabelLeadTerms: [NSLayoutConstraint]!
    @IBOutlet weak var authorLabelBottomMargin: NSLayoutConstraint!
    @IBOutlet weak var authorLabelLeadMargin: NSLayoutConstraint!
    
    @IBOutlet weak var postTitleLabelTopMargin: NSLayoutConstraint!
    @IBOutlet weak var postTitleLabelLeadMargin: NSLayoutConstraint!
    @IBOutlet weak var postTitleLabelHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var postTitleLabelTrailConstraint: NSLayoutConstraint!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var previewButton: UIButton!
    @IBOutlet weak var preViewButtonWidth: NSLayoutConstraint!
    
    @IBOutlet weak var hotIconImageView: UIImageView!
    @IBOutlet weak var hotIconImageWidth: NSLayoutConstraint!
    @IBOutlet weak var hotIconImageHeight: NSLayoutConstraint!
    
    var imageContainerBottom    : NSLayoutConstraint?
    var imageContainerTrail     : NSLayoutConstraint?
    var textContainerTop        : NSLayoutConstraint?
    var textContainerLead       : NSLayoutConstraint?
    
    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    @IBOutlet weak var gifImageBackgorundView: UIView!
    @IBOutlet weak var gifImageLead  : NSLayoutConstraint!
    @IBOutlet weak var gifImageTrail : NSLayoutConstraint!
    
    @IBOutlet var topFlagImageViews: [UIImageView]!
    @IBOutlet weak var topFlagLeadMargin: NSLayoutConstraint!
    @IBOutlet weak var topFlagTopMargin: NSLayoutConstraint!
    @IBOutlet weak var topFlagSideMargin: NSLayoutConstraint!
    
    
    
    var displayType : CastDisplayType = .grid {
        didSet {
            updateLayout()
        }
    }
    
    var previewAction : (_ sender : UIButton)->Void = {send in}
    
    private(set) public var cast : CastInfo = CastInfo()
    
    private(set) public var mcInfo : MCInfo = MCInfo()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setLayerOutLine(borderWidth: 0, cornerRadius: 2, borderColor: #colorLiteral(red: 0.8156862745, green: 0.8352941176, blue: 0.8588235294, alpha: 1).withAlphaComponent(0.5))
    }

    open func setInfo(cast : CastInfo) {
        
        self.cast = cast
        
        self.updateContent()
        
    }
    
    open func setMcInfo(mc : MCInfo) {
        self.mcInfo = mc
        self.updateMcInfo()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if (self.bounds.width / self.bounds.height) > 1.4 {
            if self.displayType != .table {
                self.displayType = .table
            }
        }else {
            
            if self.displayType != .grid {
                self.displayType = .grid
            }
        }
    }
    
    //MARK: - Update content
    func updateContent() {
        loadAnniversaryEffect(url: cast.anniversaryImgFile, gifView: gifImageView)
        
        self.postTitleLabel.attributedText = nil
        if cast.isAdult && userInfo.isNameCheck == false {
            self.postTitleLabel.text = I18N.err_needAdultCertForUse.localized
        } else {
            //Cast name
            self.postTitleLabel.text = cast.castTitle
        }
        
        if cast.isCommerce {
            let title = self.postTitleLabel.text ?? ""
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = #imageLiteral(resourceName: "IcoCommerce")
            let size = imageAttachment.image?.size ?? .zero
            let mid = (self.postTitleLabel.font.capHeight - size.height) * 0.5
            imageAttachment.bounds = CGRect(x: 0, y: mid, width: size.width, height: size.height)
            let attrString = NSAttributedString(attachment: imageAttachment)
            let fullString = NSMutableAttributedString(attributedString: attrString)
            fullString.append(NSAttributedString(string:" " + title))
            self.postTitleLabel.attributedText = fullString
        }
        
        // Cast Image
        // 한글URL 인경우를 대비하여 인코딩.
        let urlStr = cast.pFileName
        let encoded = urlStr.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        self.postImageView.sd_setImage(with: URL(string: encoded!), placeholderImage:appData.defProImage.images[cast.categoryCode] )
        //self.postImageView.sd_setImage(with: URL(string: encoded!), placeholderImage:appData.defProImage.images[cast.categoryCode], options: SDWebImageOptions.refreshCached )
        
        self.postImageView.backgroundColor = UIColor.clear
        
        //MC nickname
        self.authorLabel.text = cast.nickName
        
        //info
        self.timeLabel.attributedText = CellUtil.getTimeAndWatchCntAttributeString(from: cast, textColor: UIColor.white)
        // self.postTimeLabel.attributedText = CellUtil.getTimeAndWatchCntAttributeString(from: cast, textColor:self.postTimeLabel.textColor)
        
        //Hot
        switch cast.castListNum {
        case .normal:
            hotIconImageView.isHidden = true
        case .bronze:
            hotIconImageView.isHidden = true
        case .silver:
            hotIconImageView.isHidden = false
            hotIconImageView.image = #imageLiteral(resourceName: "ico_silver")
        case .gold:
            hotIconImageView.isHidden = false
            hotIconImageView.image = #imageLiteral(resourceName: "ico_gold")
        case .special:
            hotIconImageView.isHidden = false
            hotIconImageView.image = #imageLiteral(resourceName: "ico_main_best")
        }
        
        /*
        //Adult & Lock
        var flags : [FlagType] = CellUtil.getFlags(from: cast)
        
        if flags.contains(.adult) {
            lockIconImageView.isHidden = false
        } else {
            lockIconImageView.isHidden = true
        }
        
        //Lock
        lockIconImageView.isHidden = !cast.isPrivate
        */
        
        //Adult & Lock
        let flags : [FlagType] = CellUtil.getFlags(from: cast)
        var imageSet = [UIImage]()
        if flags.contains(.adult) {
            imageSet.append(#imageLiteral(resourceName: "ico_19"))
        }
        if cast.isPrivate {
            imageSet.append(#imageLiteral(resourceName: "ico_lock"))
        }
        topFlagImageViews.forEach { (imgView) in
            imgView.isHidden = true
        }
        for (i,img) in imageSet.enumerated() {
            topFlagImageViews[i].isHidden = false
            topFlagImageViews[i].image = img
        }
        
        /*
        if flags.contains(.fan) == false && flags.contains(.pay) == false {
            authonLabelLeadTerms.forEach { (constraint) in
                constraint.constant = 0
            }
            fanCastImageWidth.constant = 0
            paidCastImageWidth.constant = 0
        } */
        
        if flags.contains(.fan) {
            fanCastImageWidth.constant = 14
            authonLabelLeadTerms[1].constant = 2
        } else {
            fanCastImageWidth.constant = 0
            authonLabelLeadTerms[1].constant = 0
        }
        
        if flags.contains(.pay) {
            paidCastImageWidth.constant = 24
            authonLabelLeadTerms[0].constant = 5
        } else {
            paidCastImageWidth.constant = 0
            authonLabelLeadTerms[0].constant = 0
        }
        
        /*
        for i in 0...2
        {
            if flags.count > i {
                let flag = flags[i]
                flagImageViews[i].isHidden = false
                flagImageViews[i].image = flag.iconImage()
            }else {
                flagImageViews[i].isHidden = true
            }
        } */
        
        if cast.isAdult || cast.isPrivate || cast.castType == .fanClub || cast.castType == .pay {
            previewButton.isHidden = true
            preViewButtonWidth.constant = 0
        }else {
            previewButton.isHidden = false
            preViewButtonWidth.constant = 30
        }
        
        dispatchMain.async {
            if self.displayType == .grid {
                self.textBackPanelImageView.image = self.cast.decorateType.gridDecoImage()
                // change image for Grid
                self.fanImageView.image = #imageLiteral(resourceName: "ico_main_fen")
                self.chargeImageView.image  = #imageLiteral(resourceName: "ico_main_charge")
            } else {
                self.textBackPanelImageView.image = self.cast.decorateType.listDecoImage()
                self.fanImageView.image = #imageLiteral(resourceName: "ico_fen")
                self.chargeImageView.image  = #imageLiteral(resourceName: "ico_charge")
            }
            self.layoutIfNeeded()
        }
        
        /*
        if cast.decorateType != .none {
            dispatchMain.async {
                if self.displayType == .grid {
                    self.textBackPanelImageView.image = self.cast.decorateType.gridDecoImage()
                } else {
                    self.textBackPanelImageView.image = self.cast.decorateType.listDecoImage()
                }
                self.layoutIfNeeded()
            }
        } else {
            textBackPanelImageView.image = nil
        } */
        
        self.layoutIfNeeded()
    }
    
    
    private func updateMcInfo()
    {
        var randomImage = appData.defProImage.getImage(with: "default")
        if appData.defProImage.images.isEmpty == false {
            let index = Int(arc4random_uniform(UInt32(appData.defProImage.images.count)))
            randomImage = Array(appData.defProImage.images.values)[index]
        }
        
        if mcInfo.nickname.isEmpty == false {
            
            let nameSize : CGFloat = 12
            let descSize : CGFloat = 10
            
//            if displayType == .table {
//                nameSize = 16
//                descSize = 13
//            }
            
            let str = NSMutableAttributedString(string: mcInfo.nickname, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: nameSize), NSAttributedString.Key.foregroundColor : UIColor.black ])
            let add = NSAttributedString(string: I18N.mc_fanclub.localized, attributes: [NSAttributedString.Key.font : UIFont.notoFont(ofSize: descSize) , NSAttributedString.Key.foregroundColor : UIColor.darkGray ])
            
            str.append(add)
            self.postTitleLabel.attributedText = str
            self.postTitleLabelTrailConstraint.constant =  -1 * previewButton.frame.width
        }
        //self.postTitleLabel.text = mcInfo.nickname + "님의 팬클럽 채널"
        //self.postTitleLabel.font = UIFont.notoMediumFont(ofSize:(16.0))
        
        self.authorLabel.text = String(format: I18N.ui_numOfContent.localized, mcInfo.vodCnt) //"총 \(mcInfo.vodCnt)개 컨텐츠"
        self.self.postImageView.sd_setImage(with: URL(string: mcInfo.pFileName), placeholderImage:randomImage )
        
        let timeText = CellUtil.getDateString(with: mcInfo.maxDate.replacingOccurrences(of: "-", with: ""))  + " | \(I18N.text_watch.localized): " + CellUtil.getNumberCommaFormat(text: mcInfo.viewCnt) + I18N.text_viewerCount.localized
        self.timeLabel.text = timeText
        //self.postTimeLabel.text = timeText
        
        previewButton.isHidden = true
        hotIconImageView.isHidden = true
        topFlagImageViews.forEach { (imgView) in
            imgView.isHidden = true
        }
        
        let flags : [FlagType] = CellUtil.getFlags(from: cast)
        if flags.contains(.fan) {
            fanCastImageWidth.constant = 14
            authonLabelLeadTerms[1].constant = 2
        } else {
            fanCastImageWidth.constant = 0
            authonLabelLeadTerms[1].constant = 0
        }
        
        if flags.contains(.pay) {
            paidCastImageWidth.constant = 24
            authonLabelLeadTerms[0].constant = 5
        } else {
            paidCastImageWidth.constant = 0
            authonLabelLeadTerms[0].constant = 0
        }
        
        loadAnniversaryEffect(url: cast.anniversaryImgFile, gifView: gifImageView)
    }

    
    func updateLayout() {
        
        if imageContainerBottom != nil {
            self.removeConstraint(imageContainerBottom!)
        }
        
        if imageContainerTrail != nil {
            self.removeConstraint(imageContainerTrail!)
        }
        
        if textContainerTop != nil {
            self.removeConstraint(textContainerTop!)
        }
        
        if textContainerLead != nil {
            self.removeConstraint(textContainerLead!)
        }
        
        gifImageLead.constant = displayType == .grid ? 24.0 : 17.0
        gifImageTrail.constant = displayType == .grid ? 24.0 : 17.0
        
        //        self.begin
        if displayType == .grid {
            //bottom
            imageContainerBottom    = NSLayoutConstraint.init(item: imageContainer as Any, attribute: .bottom, relatedBy: .equal, toItem: textContainer, attribute: .top, multiplier: 1, constant: 0)
            imageContainerTrail     = NSLayoutConstraint.init(item: imageContainer as Any, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0)
            
            textContainerLead       = NSLayoutConstraint.init(item: textContainer as Any, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0)
            textContainerTop        = nil
            
            self.addConstraint(imageContainerBottom!)
            self.addConstraint(imageContainerTrail!)
            self.addConstraint(textContainerLead!)
            
            postTitleLabelLeadMargin.constant = 9
            authorLabelLeadMargin.constant    = 9
            postTitleLabelTopMargin.constant  = 3
            authorLabelBottomMargin.constant  = 2
            
            topFlagLeadMargin.constant  = 9
            topFlagTopMargin.constant   = 7
            topFlagSideMargin.constant  = 3
            postTitleLabelHeightConstraint = postTitleLabelHeightConstraint.setMultiplier(multiplier: 1)
            
            if hotIconImageView.isHidden {
                hotIconImageWidth.constant  = 0
            }  else {
                hotIconImageWidth.constant   = 15
                hotIconImageHeight.constant  = 24
            }
            
            // change image for Grid
            //fanImageView.image = #imageLiteral(resourceName: "ico_main_fen")
            //chargeImageView.image  = #imageLiteral(resourceName: "ico_main_charge")
            
            self.timeView.isHidden = false
        }else {
            
            //bottom
            imageContainerBottom    = NSLayoutConstraint.init(item: imageContainer as Any, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0)
            imageContainerTrail     = NSLayoutConstraint.init(item: imageContainer as Any, attribute: .trailing, relatedBy: .equal, toItem: textContainer, attribute: .leading, multiplier: 1, constant: 0)
            
            textContainerLead       = nil
            textContainerTop        = NSLayoutConstraint.init(item: textContainer as Any, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0)
            
            self.addConstraint(imageContainerBottom!)
            self.addConstraint(imageContainerTrail!)
            self.addConstraint(textContainerTop!)
            
            postTitleLabelLeadMargin.constant = 21
            authorLabelLeadMargin.constant    = 21
            postTitleLabelTopMargin.constant  = 14
            authorLabelBottomMargin.constant  = 14
            
            topFlagLeadMargin.constant  = 5
            topFlagTopMargin.constant   = 6
            topFlagSideMargin.constant  = 2
            
            if hotIconImageView.isHidden {
                hotIconImageWidth.constant  = 0
            }  else {
                hotIconImageWidth.constant  = 21
                hotIconImageHeight.constant  = 33
            }
            
            // change image for List
            //fanImageView.image = #imageLiteral(resourceName: "ico_fen")
            //chargeImageView.image  = #imageLiteral(resourceName: "ico_charge")
            
            postTitleLabelHeightConstraint = postTitleLabelHeightConstraint.setMultiplier(multiplier: 2)
            //self.timeView.isHidden = true
        }
        
        dispatchMain.async {
            if self.displayType == .grid {
                self.textBackPanelImageView.image = self.cast.decorateType.gridDecoImage()
                // change image for Grid
                self.fanImageView.image = UIImage(named: "ico_main_fen")
                self.chargeImageView.image  = UIImage(named: "ico_main_charge")
            } else {
                self.textBackPanelImageView.image = self.cast.decorateType.listDecoImage()
                // change image for List
                self.fanImageView.image = UIImage(named: "ico_fen")
                self.chargeImageView.image  = UIImage(named: "ico_charge") 
            }
            self.layoutIfNeeded()
        }
        
        /*
        if cast.decorateType != .none {
            dispatchMain.async {
                if self.displayType == .grid {
                    self.textBackPanelImageView.image = self.cast.decorateType.gridDecoImage()
                } else {
                    self.textBackPanelImageView.image = self.cast.decorateType.listDecoImage()
                }
                self.layoutIfNeeded()
            }
        }*/
        
        self.layoutIfNeeded()
    }
    
    //MARK: - IBAction
    @IBAction func previewAction(_ sender: AnyObject) {
        previewAction(sender as! UIButton)
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


extension NSLayoutConstraint {
    func setMultiplier(multiplier: CGFloat) -> NSLayoutConstraint {
        NSLayoutConstraint.deactivate([self])
        
        let newConstraint = NSLayoutConstraint(item: firstItem as Any, attribute: firstAttribute, relatedBy: relation, toItem: secondItem, attribute: secondAttribute, multiplier: multiplier, constant: constant)
        
        newConstraint.priority = priority
        newConstraint.shouldBeArchived = shouldBeArchived
        newConstraint.identifier = identifier
        
        NSLayoutConstraint.activate([newConstraint])
        return newConstraint
    }
}
