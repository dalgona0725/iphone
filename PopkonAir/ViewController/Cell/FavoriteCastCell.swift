//
//  FavoriteCastCell.swift
//  PopkonAir
//
//  Created by Steven on 31/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import FLAnimatedImage

class FavoriteCastCell: UICollectionViewCell {
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var textContainerView: UIView!
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: SingleShotResetLabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var hotIconImageView: UIImageView!
    @IBOutlet weak var textBackPanelImageView: UIImageView!
    
    @IBOutlet weak var timeView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var liveImageView: UIImageView!
    @IBOutlet var flagImageViews: [UIImageView]!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var fanImageView: UIImageView!
    @IBOutlet weak var chargeImageView: UIImageView!
    @IBOutlet weak var mcLevelIcon: LevelIconButton!    

    @IBOutlet weak var gifImageView: FLAnimatedImageView!
    @IBOutlet weak var gifImageBackgorundView: UIView!
    
    private(set) public var cast : CastInfo = CastInfo()
    
    var isEditing : Bool = false
    
    var deleteAction : (_ cast : CastInfo) -> Void = {cast in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setLayerOutLine(borderWidth: 0, cornerRadius: 2, borderColor: #colorLiteral(red: 0.8156862745, green: 0.8352941176, blue: 0.8588235294, alpha: 1).withAlphaComponent(0.5))
    }
    
    open func setInfo(cast : CastInfo) {
        
        self.cast = cast
        
        self.updateContent()
        
    }
    
    
    //MARK: - Update content
    func updateContent() {
        loadAnniversaryEffect(url: cast.anniversaryImgFile, gifView: gifImageView)
        
        self.postTitleLabel.attributedText = nil
        self.postTitleLabel.text = cast.castTitle
        
        if cast.isCommerce {
            let title = self.postTitleLabel.text ?? ""
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = #imageLiteral(resourceName: "IcoCommerce")
            let size = imageAttachment.image?.size ?? .zero
            let mid = (self.postTitleLabel.font.capHeight - size.height*0.8) * 0.5
            imageAttachment.bounds = CGRect(x: 0, y: mid, width: size.width*0.8, height: size.height*0.8)
            let attrString = NSAttributedString(attachment: imageAttachment)
            let fullString = NSMutableAttributedString(attributedString: attrString)
            fullString.append(NSAttributedString(string:" " + title))
            self.postTitleLabel.attributedText = fullString
        }
        
        //Cast Image
        self.postImageView.sd_setImage(with: URL(string: cast.pFileName.urlQueryAllowedString), placeholderImage:appData.defProImage.images[cast.categoryCode] )
        self.postImageView.backgroundColor = UIColor.clear
        
        self.postTitleLabel.type = .leftRight
        self.postTitleLabel.animationCurve = .easeInOut
        
        //MC nickname
        self.authorLabel.text = cast.nickName
        
        //Live
        switch cast.castStatus {
        case .off:
            liveImageView.isHidden = true
            timeView.isHidden = false
            self.timeLabel.text = getLastCastTime()
            break
        default:
            liveImageView.isHidden = false
            timeView.isHidden = false
            self.timeLabel.attributedText = CellUtil.getTimeAndWatchCntAttributeString(from: cast)
            break
        }
        
        //DeleteButton & flagImageViews
        self.updateEditStatus()
        
        self.layoutIfNeeded()
    }
    
    /// 마지막 방송일시
    private func getLastCastTime() -> String {
        if cast.castLastDate.count != 14 {
            return ""
        }
        
        var time = ""
        let inDateForm = DateFormatter()
        inDateForm.dateFormat = "yyyyMMddHHmmss"
        if let dateTime = inDateForm.date(from: cast.castLastDate) {
            let outDateForm = DateFormatter()
            outDateForm.dateFormat = "yyyy-MM-dd HH:mm"
            time = outDateForm.string(from: dateTime)
        }
        return time
    }
    
    ///Update DeleteButton & flagImageViews According to edit status
    func updateEditStatus() {
        
        let flags : [FlagType] = CellUtil.getFlags(from: cast)
        flagImageViews.forEach { (imgView) in
            imgView.isHidden = true
        }
        
        if isEditing {
            deleteButton.isHidden = false
        }else {
            deleteButton.isHidden = true
            //Flag Icon
            
            var imageSet = [UIImage]()
            if flags.contains(.adult) {
                imageSet.append(#imageLiteral(resourceName: "ico_19"))
            }
            if cast.isPrivate {
                imageSet.append(#imageLiteral(resourceName: "ico_lock"))
            }
            
            for (i,img) in imageSet.enumerated() {
                flagImageViews[i].isHidden = false
                flagImageViews[i].image = img
            }
        }
              
        fanImageView.isHidden = flags.contains(.fan) ? false : true
        chargeImageView.isHidden = flags.contains(.pay) ? false : true
        mcLevelIcon.setupLevelInfo(type: .mc, level: cast.levelMC)
        
        //Hot
        switch cast.castListNum {
        case .normal:
            hotIconImageView.isHidden = true
        case .bronze:
            hotIconImageView.isHidden = true
        case .silver:
            hotIconImageView.isHidden = false
            hotIconImageView.image = UIImage(named: "ico_silver")
        case .gold:
            hotIconImageView.isHidden = false
            hotIconImageView.image = UIImage(named: "ico_gold")
        case .special:
            hotIconImageView.isHidden = true
        }
        
        if cast.decorateType != .none {
            textBackPanelImageView.image = cast.decorateType.gridDecoImage()
        } else {
            textBackPanelImageView.image = nil
        }        
    }
    
    @IBAction func deleteAction(_ sender: AnyObject) {
        deleteAction(self.cast)
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
