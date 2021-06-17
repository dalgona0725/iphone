//
//  LiveCell.swift
//  Test
//
//  Created by  seob on 22/11/2018.
//  Copyright © 2018 seob. All rights reserved.
//

import UIKit
import SDWebImage

class LiveCell: UITableViewCell {

    @IBOutlet weak var liveImageView: UIImageView!
    @IBOutlet weak var liveTitleLabel: UILabel!
    @IBOutlet weak var liveSubTitleLabel: UILabel!
    @IBOutlet weak var liveLabel: UILabel!
    @IBOutlet weak var liveCntButton: UIButton!

    @IBOutlet weak var moreButtonView: UIView!
    @IBOutlet weak var moreButton: UIButton!
    @IBAction func moreButtonAction(_ sender: Any) {
        print("\n---------- [ 더보기 클릭 ] ----------\n")
    }
    
    @IBOutlet weak var mcLevelIcon: LevelIconButton!
    /// 팬방아이콘
    @IBOutlet weak var fanImageView: UIImageView!
    /// 유료방 아이콘
    @IBOutlet weak var chargeImageView: UIImageView!
    /// 비밀/19금 아이콘관련
    @IBOutlet var topFlagImageViews: [UIImageView]!
    
    var liveList : CastInfo = CastInfo() {
        didSet {
            udpateContent()
        }
    }
    
    var onClick : (_ live : CastInfo) -> Void = {
        live in
    }
    
    func udpateContent(){
        
        liveTitleLabel.attributedText = nil
        liveTitleLabel.text = liveList.castTitle
        if liveList.isCommerce {
            let title = self.liveTitleLabel.text ?? ""
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = #imageLiteral(resourceName: "IcoCommerce")
            let size = imageAttachment.image?.size ?? .zero
            let mid = (self.liveTitleLabel.font.capHeight - size.height) * 0.5
            imageAttachment.bounds = CGRect(x: 0, y: mid, width: size.width, height: size.height)
            let attrString = NSAttributedString(attachment: imageAttachment)
            let fullString = NSMutableAttributedString(attributedString: attrString)
            fullString.append(NSAttributedString(string:" " + title))
            self.liveTitleLabel.attributedText = fullString
        }
        
        liveSubTitleLabel.text = liveList.nickName
		// 썸네일 업데이트 안되는 이슈 수정
        guard let url = URL(string: liveList.pFileName.urlQueryAllowedString) else { return }
		// Live 모바일 방송에서 썸네일이 생기기 전에는 기본셀럽이미지로 보이고 썸네일이 생기면 썸네일로 보여주도록 로직 수정
		dispatchGlobal.async {
            let data = try? Data(contentsOf: url)
			
			dispatchMain.async {
				if data != nil {
					self.liveImageView.image = UIImage(data: data!)
				} else {
					self.liveImageView.image = UIImage(named: "LivePlaceHolder")
				}
			}
		}
//		self.LiveImageView.sd_setImage(with: URL(string: liveList.pFileName))
		liveCntButton.setTitle("\(liveList.watchCnt)".getDecimalString, for: UIControl.State.normal)
		liveCntButton.layer.cornerRadius = 10
        liveCntButton.clipsToBounds = true
        liveImageView.contentMode = .scaleAspectFill
		liveImageView.clipsToBounds = true
        
        
        let flags : [FlagType] = CellUtil.getFlags(from: liveList)
        fanImageView.isHidden = flags.contains(.fan) ? false : true
        chargeImageView.isHidden = flags.contains(.pay) ? false : true
        mcLevelIcon.setupLevelInfo(type: .mc, level: liveList.levelMC)
        
        var imageSet = [UIImage]()
        if flags.contains(.adult) {
            imageSet.append(#imageLiteral(resourceName: "ico_19"))
        }
        if liveList.isPrivate {
            imageSet.append(#imageLiteral(resourceName: "ico_lock"))
        }
        topFlagImageViews.forEach { (imgView) in
            imgView.isHidden = true
        }
        for (i,img) in imageSet.enumerated() {
            topFlagImageViews[i].isHidden = false
            topFlagImageViews[i].image = img
        }
     }
	
    override func awakeFromNib() {
        super.awakeFromNib()
        let mScreenSize = UIScreen.main.bounds
        let mSeparatorHeight = CGFloat(16.0) // Change height of speatator as you want
        let mAddSeparator = UIView.init(frame: CGRect(x: 0, y: self.frame.size.height, width: mScreenSize.width, height: mSeparatorHeight))
        mAddSeparator.backgroundColor = UIColor.RGBColor(red: 224, green: 224, blue: 224)
        self.addSubview(mAddSeparator)
     }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func clickAction(_ sender: Any) {
        onClick(liveList)
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
}
