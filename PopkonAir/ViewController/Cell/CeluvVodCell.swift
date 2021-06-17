//
//  CeluvVodCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 20/08/2019.
//  Copyright © 2019 The E&M. All rights reserved.
//

import UIKit

class CeluvVodCell: UICollectionViewCell {
    
    @IBOutlet weak var vodImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var viewCountLabel: UILabel!
    
    private(set) public var mcInfo : MCInfo = MCInfo()
    private(set) public var vodInfo : CeluvVODInfo = CeluvVODInfo()
    
    var displayType : CastDisplayType = .grid {
        didSet {
            updateLayout()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    open func setVodInfo(vod : CeluvVODInfo) {
        self.vodInfo = vod
        self.updateVodInfo()
    }
    
    open func setMcInfo(mc : MCInfo) {
        self.mcInfo = mc
        self.updateMcInfo()
    }
    
    private func updateLayout() {
        
    }
    
    private func updateVodInfo() {
        var randomImage = appData.defProImage.getImage(with: "default")
        if appData.defProImage.images.isEmpty == false {
            let index = Int(arc4random_uniform(UInt32(appData.defProImage.images.count)))
            randomImage = Array(appData.defProImage.images.values)[index]
        }
		guard let vodThumnail = vodInfo.vodThumnail else { return }
		guard let vodOwner = vodInfo.vodOwner else { return }
		self.vodImageView.sd_setImage(with: URL(string: vodThumnail.urlQueryAllowedString))
        self.titleLabel.text = vodInfo.vodTitle
        
        self.viewCountLabel.text = CellUtil.getNumberCommaFormat(text: vodInfo.viewCnt ?? "0" )
        
        
        let attributedStr = NSMutableAttributedString(string: vodOwner,
                                                      attributes: [NSAttributedString.Key.font : nicknameLabel.font, NSAttributedString.Key.foregroundColor : nicknameLabel.textColor])
        
        // vSetDate  "20190729125324"
        if let date = vodInfo.vSetDate {
            let timeGapText = getDataString(dateString: date)
            if timeGapText.isEmpty == false  {
                let timeAttributed = NSAttributedString(string:  " · " + timeGapText, attributes: [NSAttributedString.Key.font : nicknameLabel.font, NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.5518978834, green: 0.5519112945, blue: 0.5519040227, alpha: 1)])
                attributedStr.append(timeAttributed)
            }
        }
        
        self.nicknameLabel.attributedText = attributedStr
        
    }
    
    func getDataString(dateString: String) -> String {
        let inDateForm = DateFormatter()
        inDateForm.dateFormat = "yyyyMMddHHmmss"
        if let startDate = inDateForm.date(from: dateString) {
            let today = Date()
            let calendar = Calendar.current
            let dateGap = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: startDate, to: today)
            
            if let year = dateGap.year, year > 0 {
                return "\(year)" + "년 전"
            } else if let month = dateGap.month, month > 0 {
                return "\(month)" + "개월 전"
            } else if let day = dateGap.day, day > 0 {
                return "\(day)" + "일 전"
            } else if let hour = dateGap.hour, hour > 0 {
                return "\(hour)" + "시간 전"
            } else if let min = dateGap.minute, min > 0 {
                return "\(min)" + "분 전"
            }
        }
        return ""
    }
    
    private func updateMcInfo()
    {
        var randomImage = appData.defProImage.getImage(with: "default")
        if appData.defProImage.images.isEmpty == false {
            let index = Int(arc4random_uniform(UInt32(appData.defProImage.images.count)))
            randomImage = Array(appData.defProImage.images.values)[index]
        }
        
        if mcInfo.nickname.isEmpty == false {
            self.vodImageView.sd_setImage(with: URL(string: mcInfo.pFileName.urlQueryAllowedString))
            
            
            let nameSize : CGFloat = 12
            let descSize : CGFloat = 10
            
            let str = NSMutableAttributedString(string: mcInfo.nickname, attributes: [NSAttributedString.Key.font : UIFont.notoMediumFont(ofSize: nameSize), NSAttributedString.Key.foregroundColor : UIColor.black ])
            let add = NSAttributedString(string: I18N.mc_fanclub.localized, attributes: [NSAttributedString.Key.font : UIFont.notoFont(ofSize: descSize) , NSAttributedString.Key.foregroundColor : UIColor.darkGray ])
            
            str.append(add)
            self.titleLabel.attributedText = str
        }
        self.nicknameLabel.text = String(format: I18N.ui_numOfContent.localized, mcInfo.vodCnt) //"총 \(mcInfo.vodCnt)개 컨텐츠"
        let timeText = CellUtil.getDateString(with: mcInfo.maxDate.replacingOccurrences(of: "-", with: ""))  + " | \(I18N.text_watch.localized): " + CellUtil.getNumberCommaFormat(text: mcInfo.viewCnt) + I18N.text_viewerCount.localized
        self.viewCountLabel.text = timeText

    }

}
