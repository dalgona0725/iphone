//
//  ReplyCell.swift
//  PopkonAir
//
//  Created by Brian Park on 2019/12/04.
//  Copyright © 2019 The E&M. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
	
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
	@IBOutlet private weak var answerButton: UIButton!
	@IBOutlet private weak var recommendUpLabel: UILabel!
	@IBOutlet private weak var recommendDownLabel: UILabel!
	
	var gotoRelpy : (_ comment: VODCommentInfo) -> Void = { code in }
	var voteAction : (_ comment : VODCommentInfo, _ isGood : Bool)->Void = { comment,good in }
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
	
	func resetAction() {
		gotoRelpy = { _ in }
		voteAction = { _,_ in }
	}
	
	func setupCell() {
		answerButton.setLayerOutLine(borderWidth: 1, cornerRadius: 5, borderColor: UIColor.RGBColor(red: 159, green: 172, blue: 191))
		answerButton.addTarget(self, action: #selector(showReply), for: .touchUpInside)
		nameLabel.text = ""
		commentLabel.text = ""
		dateLabel.text = ""
		recommendUpLabel.text = ""
		recommendDownLabel.text = ""
		answerButton.setTitle("", for: .normal)
		
		self.selectionStyle = .none
	}
	
	open func setInfo(info: VODCommentInfo, hideAnswerBtn: Bool = false ) {
		comment = info
		self.answerButton.isHidden = hideAnswerBtn
		self.updateContent()
	}
	
    open func updateCount(info: VODCommentInfo) {
        dispatchMain.async {
            self.answerButton.setTitle("   \(I18N.text_replyLetter.localized) \(CellUtil.getNumberCommaFormat(numeral:info.replyCount))\(I18N.ui_numOfCoin.localized)   ", for: UIControl.State.normal)
			self.recommendUpLabel.text = "\(CellUtil.getNumberCommaFormat(numeral:info.goodCount))"
			self.recommendDownLabel.text = "\(CellUtil.getNumberCommaFormat(numeral:info.badCount))"
        }
    }

	
	//MARK: - Update content
	func updateContent() {
		let urlString = comment.urlProfileImg.urlQueryAllowedString
		
		profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
		profileImageView.clipsToBounds = true
		profileImageView.layer.masksToBounds = true
		profileImageView.setLayerOutLine(borderWidth: 2, cornerRadius: profileImageView.frame.height / 2, borderColor: UIColor.RGBColor(red: 159, green: 172, blue: 191))
		
		self.profileImageView.sd_setImage(with: URL(string: urlString ), placeholderImage:basicLogoImage )
		self.nameLabel.text = comment.userNick
		self.commentLabel.text = comment.comment
		self.dateLabel.text = comment.writeDate
		self.answerButton.setTitle("   \(I18N.text_replyLetter.localized) \(CellUtil.getNumberCommaFormat(numeral:comment.replyCount))\(I18N.ui_numOfCoin.localized)   ", for: UIControl.State.normal)
		self.recommendUpLabel.text = "\(CellUtil.getNumberCommaFormat(numeral:comment.goodCount))"
		self.recommendDownLabel.text = "\(CellUtil.getNumberCommaFormat(numeral:comment.badCount))"
        
        levelIcon.setupLevelInfo(type: .service, level: comment.levelService)
	}
	
	@IBAction func showReply(_ sender: Any) {
		gotoRelpy(comment)
	}
	
	@IBAction func voteGood(_ sender: Any) {
		voteAction(comment,true)
	}
	
	@IBAction func voteBad(_ sender: Any) {
		voteAction(comment,false)
	}
	
	
	@IBAction func moreAction(_ sender: UIButton) {
		moreAction(comment)
	}
	
	
	override func setSelected(_ selected: Bool, animated: Bool) {
		super.setSelected(selected, animated: animated)
		
		// Configure the view for the selected state
	}
	
}
