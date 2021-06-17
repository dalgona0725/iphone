//
//  LiveTableviewCell.swift
//  PopkonAir
//
//  Created by Brian Park on 04/09/2019.
//  Copyright © 2019 The E&M. All rights reserved.
//

import UIKit
import FLAnimatedImage

class LiveTableviewCell: UITableViewCell {
	
	@IBOutlet weak var vodTitleLabel: UILabel!
	@IBOutlet weak var vodSubTitleLabel: UILabel!
	@IBOutlet weak var vodThumbImageView: UIImageView!
	@IBOutlet weak var cntImgView: UIImageView!
	@IBOutlet weak var watchCntLb: UILabel!
    @IBOutlet weak var mcLevelIcon: LevelIconButton!
        
    /// 팬방아이콘
    @IBOutlet weak var fanImageView: UIImageView!
    /// 유료방 아이콘
    @IBOutlet weak var chargeImageView: UIImageView!
    /// 비밀/19금 아이콘관련
    @IBOutlet var topFlagImageViews: [UIImageView]!
	/// 기념일
    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    @IBOutlet weak var gifImageBackgorundView: UIView!
    /// 리스트꾸미기
    @IBOutlet weak var textBackPanelImageView: UIImageView!
    /// 핫 아이콘  이미지
    @IBOutlet weak var hotIconImageView: UIImageView!
    // 타임
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    
	var celuvList : CastInfo = CastInfo() {
		didSet {
			udpateContent()
		}
	}
    
    var replayInfo = ReplayVodInfo() {
        didSet {
            udpateReplayContent()
        }
    }
	
	func udpateContent() {
		var url:String
		
		url = celuvList.pFileName != "" ? celuvList.pFileName : celuvList.thumbFileName
		
        loadAnniversaryEffect(url: celuvList.anniversaryImgFile, gifView: gifImageView)
        self.vodTitleLabel.attributedText = nil
		vodTitleLabel.text = celuvList.castTitle

        if celuvList.isCommerce {
            let title = self.vodTitleLabel.text ?? ""
            let attributesDictionary = [NSAttributedString.Key.font : self.vodTitleLabel.font]
            let fullAttributedString = NSMutableAttributedString(string: "", attributes: attributesDictionary as [NSAttributedString.Key : Any])
            
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = #imageLiteral(resourceName: "IcoCommerce")
            let size = imageAttachment.image?.size ?? .zero
            let mid = (self.vodTitleLabel.font.capHeight - size.height) * 0.5
            imageAttachment.bounds = CGRect(x: 0, y: mid, width: size.width, height: size.height)
            let attrString = NSAttributedString(attachment: imageAttachment)
            let fullString = NSMutableAttributedString(attributedString: attrString)
            fullString.append(NSAttributedString(string:"\t" + title,attributes: attributesDictionary as [NSAttributedString.Key : Any]))
            
            var paragraphStyle: NSMutableParagraphStyle
            let interval: CGFloat = 25
            paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
            paragraphStyle.lineBreakMode = .byTruncatingTail
            paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: interval, options: NSDictionary() as! [NSTextTab.OptionKey : AnyObject])]
            paragraphStyle.defaultTabInterval = interval
            paragraphStyle.firstLineHeadIndent = 0
            paragraphStyle.headIndent = interval
            fullString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, fullString.length))
            fullAttributedString.append(fullString)
            vodTitleLabel.attributedText = fullAttributedString
        }
        cntImgView.image = UIImage(named: "countbIc")
		vodSubTitleLabel.text = celuvList.nickName
        vodThumbImageView.sd_setImage(with: URL(string: url.urlQueryAllowedString))
        vodThumbImageView.contentMode = .scaleAspectFill
		vodThumbImageView.clipsToBounds = true
//		watchCntLb.text = celuvList.watchCnt >= celuvList.limitNumber ? "Full" : "\(celuvList.watchCnt)".getDecimalString
        timeLabel.attributedText = CellUtil.getTimeAndWatchCntAttributeString(from: celuvList, textColor: UIColor.white)
        
        /// Hot
        switch celuvList.castListNum {
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
        
        let flags : [FlagType] = CellUtil.getFlags(from: celuvList)
        fanImageView.isHidden = flags.contains(.fan) ? false : true
        chargeImageView.isHidden = flags.contains(.pay) ? false : true
        mcLevelIcon.setupLevelInfo(type: .mc, level: celuvList.levelMC)
        
        var imageSet = [UIImage]()
        if flags.contains(.adult) {
            imageSet.append(#imageLiteral(resourceName: "ico_19"))
        }
        if celuvList.isPrivate {
            imageSet.append(#imageLiteral(resourceName: "ico_lock"))
        }        
        topFlagImageViews.forEach { (imgView) in
            imgView.isHidden = true
        }
        for (i,img) in imageSet.enumerated() {
            topFlagImageViews[i].isHidden = false
            topFlagImageViews[i].image = img
        }
        
//        self.celuvList.decorateType = .pink
        
        dispatchMain.async {
            self.textBackPanelImageView.image = self.celuvList.decorateType.listDecoImage()
            self.layoutIfNeeded()
        }
        
	}
	
    private func udpateReplayContent() {
        let url = replayInfo.vPfileName
        
        loadAnniversaryEffect(url: "", gifView: gifImageView)
        self.vodTitleLabel.attributedText = nil
        vodTitleLabel.text = replayInfo.vCastTitle

        let title = self.vodTitleLabel.text ?? ""
        let attributesDictionary = [NSAttributedString.Key.font : self.vodTitleLabel.font]
        let fullAttributedString = NSMutableAttributedString(string: "", attributes: attributesDictionary as [NSAttributedString.Key : Any])
        
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = #imageLiteral(resourceName: "IcoCommerce")
        let size = imageAttachment.image?.size ?? .zero
        let mid = (self.vodTitleLabel.font.capHeight - size.height) * 0.5
        imageAttachment.bounds = CGRect(x: 0, y: mid, width: size.width, height: size.height)
        let attrString = NSAttributedString(attachment: imageAttachment)
        let fullString = NSMutableAttributedString(attributedString: attrString)
        fullString.append(NSAttributedString(string:"\t" + title,attributes: attributesDictionary as [NSAttributedString.Key : Any]))
        
        var paragraphStyle: NSMutableParagraphStyle
        let interval: CGFloat = 25
        paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.tabStops = [NSTextTab(textAlignment: .left, location: interval, options: NSDictionary() as! [NSTextTab.OptionKey : AnyObject])]
        paragraphStyle.defaultTabInterval = interval
        paragraphStyle.firstLineHeadIndent = 0
        paragraphStyle.headIndent = interval
        fullString.addAttributes([NSAttributedString.Key.paragraphStyle: paragraphStyle], range: NSMakeRange(0, fullString.length))
        fullAttributedString.append(fullString)
        vodTitleLabel.attributedText = fullAttributedString
        
        vodSubTitleLabel.text = replayInfo.vNickName
        vodThumbImageView.sd_setImage(with: URL(string: url.urlQueryAllowedString))
        vodThumbImageView.contentMode = .scaleAspectFill
        vodThumbImageView.clipsToBounds = true
        
        timeLabel.text = CellUtil.getDateString(with: replayInfo.vRegDate) + " | " + String(format: I18N.text_view_count, replayInfo.vViewCnt.getDecimalString)
        
        hotIconImageView.isHidden = true
        
        fanImageView.isHidden =  true
        chargeImageView.isHidden =  true
        if let lv = Int(replayInfo.brdcrLvl) {
            mcLevelIcon.setupLevelInfo(type: .mc, level: lv)
        }
        
        topFlagImageViews.forEach { (imgView) in
            imgView.isHidden = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	static var nib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
	
	static var identifier: String {
		return String(describing: self)
	}
		
    func getFlags(from cast:CastInfo)-> [FlagType] {
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
