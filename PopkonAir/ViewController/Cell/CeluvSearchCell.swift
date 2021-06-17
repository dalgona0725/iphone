//
//  CeluvSearchCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 27/08/2019.
//  Copyright © 2019 The E&M. All rights reserved.
//

import UIKit
import FLAnimatedImage

class CeluvSearchCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImageVidew: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    @IBOutlet weak var countImageView: UIImageView!
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


    private(set) public var castLive : CastInfo = CastInfo()
    private(set) public var celuvVOD : CeluvVODInfo = CeluvVODInfo()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        thumbnailImageVidew.setLayerOutLine(borderWidth: 1, cornerRadius: 2, borderColor: UIColor.clear)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    open func setInfo(celuv: CeluvVODInfo) {
        self.celuvVOD = celuv
        self.updateCeluvVODInfo()
    }
    
    open func setInfo(cast: CastInfo) {
        self.castLive = cast
        self.updateCeluvLiveInfo()
    }
    
    private func updateCeluvLiveInfo() {
//        var randomImage = appData.defProImage.getImage(with: "default")
//        if appData.defProImage.images.isEmpty == false {
//            let index = Int(arc4random_uniform(UInt32(appData.defProImage.images.count)))
//            randomImage = Array(appData.defProImage.images.values)[index]
//        }
        loadAnniversaryEffect(url: castLive.anniversaryImgFile, gifView: gifImageView)
        self.titleLabel.text = castLive.castTitle
        self.nicknameLabel.text = castLive.nickName
        self.thumbnailImageVidew.sd_setImage(with: URL(string: castLive.pFileName.urlQueryAllowedString))
		self.viewCountLabel.text = castLive.watchCnt >= castLive.limitNumber ? "Full" :  CellUtil.getNumberCommaFormat(text: "\(castLive.watchCnt)")
        self.countImageView.image = #imageLiteral(resourceName: "countbIc")
        
        let flags : [FlagType] = CellUtil.getFlags(from: castLive)
        fanImageView.isHidden = flags.contains(.fan) ? false : true
        chargeImageView.isHidden = flags.contains(.pay) ? false : true
        mcLevelIcon.setupLevelInfo(type: .mc, level: castLive.levelMC)
        
        var imageSet = [UIImage]()
        if flags.contains(.adult) {
            imageSet.append(#imageLiteral(resourceName: "ico_19"))
        }
        if castLive.isPrivate {
            imageSet.append(#imageLiteral(resourceName: "ico_lock"))
        }
        topFlagImageViews.forEach { (imgView) in
            imgView.isHidden = true
        }
        for (i,img) in imageSet.enumerated() {
            topFlagImageViews[i].isHidden = false
            topFlagImageViews[i].image = img
        }
        
        if castLive.isCommerce {
            let title = self.titleLabel.text ?? ""
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = #imageLiteral(resourceName: "IcoCommerce")
            let size = imageAttachment.image?.size ?? .zero
            let mid = (self.titleLabel.font.capHeight - size.height) * 0.5
            imageAttachment.bounds = CGRect(x: 0, y: mid, width: size.width, height: size.height)
            let attrString = NSAttributedString(attachment: imageAttachment)
            let fullString = NSMutableAttributedString(attributedString: attrString)
            fullString.append(NSAttributedString(string:" " + title))
            self.titleLabel.attributedText = fullString
        }

        
    }
    
    private func updateCeluvVODInfo() {
//        var randomImage = appData.defProImage.getImage(with: "default")
//        if appData.defProImage.images.isEmpty == false {
//            let index = Int(arc4random_uniform(UInt32(appData.defProImage.images.count)))
//            randomImage = Array(appData.defProImage.images.values)[index]
//        }
        
		guard let vodThumnail = celuvVOD.vodThumnail else { return }
		
        self.titleLabel.text = celuvVOD.vodTitle
        self.nicknameLabel.text = celuvVOD.vodOwner
        self.thumbnailImageVidew.sd_setImage(with: URL(string: vodThumnail.urlQueryAllowedString))
        self.viewCountLabel.text = CellUtil.getNumberCommaFormat(text: celuvVOD.viewCnt ?? "0")
        self.countImageView.image = UIImage(named: "playIc")
        
        self.mcLevelIcon.setupLevelInfo(type: .mc, level: 0)
        self.fanImageView.isHidden = true
        self.chargeImageView.isHidden = true
        
        topFlagImageViews.forEach { (imgView) in
            imgView.isHidden = true
        }
        showAnniversaryEffect(show: false)
        
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
