//
//  ReplyCell.swift
//  PopkonAir
//
//  Created by Brian Park on 2019/12/19.
//  Copyright © 2019 The E&M. All rights reserved.
//

import UIKit

class ReplyCell: UITableViewCell {
	
	var comment : VODCommentInfo = VODCommentInfo() {
		didSet {
			self.updateContent()
		}
	}
	
	@IBOutlet private weak var profileImageView: UIImageView!
    @IBOutlet private weak var levelIcon: LevelIconButton!
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var commentLabel: UILabel!
	@IBOutlet private weak var dateLabel: UILabel!
	
	var moreAction : (_ comment: VODCommentInfo) -> Void = { code in }

    override func awakeFromNib() {
        super.awakeFromNib()
		
        setupCell()
    }

	static var nib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
	
	static var identifier: String {
		return String(describing: self)
	}
	
	func setupCell() {
		nameLabel.text = ""
		commentLabel.text = ""
		dateLabel.text = ""
		
		self.selectionStyle = .none
	}
	
	//MARK: - Update content
	func updateContent() {
		let urlString = comment.urlProfileImg.urlQueryAllowedString
		
		profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
		profileImageView.clipsToBounds = true
		profileImageView.layer.masksToBounds = true
		profileImageView.setLayerOutLine(borderWidth: 2, cornerRadius: profileImageView.frame.height / 2, borderColor: UIColor.RGBColor(red: 159, green: 172, blue: 191))
		
		profileImageView.sd_setImage(with: URL(string: urlString ), placeholderImage:basicLogoImage )
		nameLabel.text = comment.userNick
		commentLabel.text = comment.comment
		dateLabel.text = comment.writeDate
        levelIcon.setupLevelInfo(type: .service, level: comment.levelService)
	}
	
	@IBAction func onMoreAction(_ sender: UIButton) {
		moreAction(comment)
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
