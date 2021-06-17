//
//  VodCommentCell
//  TVTen
//
//  Created by Eugene Jeong on 2017. 10. 24..
//  Copyright © 2017년 roy. All rights reserved.
//
import UIKit

class VodCommentCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var answerButton: UIButton!
    @IBOutlet weak var recommendUpButton: UIButton!
    @IBOutlet weak var recommendDownButton: UIButton!
    
    private(set) public var comment : VODCommentInfo = VODCommentInfo()
    
    var gotoRelpy : (_ comment: VODCommentInfo) -> Void = { code in }
    var voteAction : (_ comment : VODCommentInfo, _ isGood : Bool)->Void = { comment,good in }
    
    
//    private(set) public var mc : MCInfo = MCInfo()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        profileImageView.setLayerOutLine(borderWidth: 0, cornerRadius: 2, borderColor: UIColor.clear)
        answerButton.setLayerOutLine(borderWidth: 1, cornerRadius: 2, borderColor: UIColor.lightGray)
        recommendUpButton.setLayerOutLine(borderWidth: 1, cornerRadius: 2, borderColor: UIColor.lightGray)
        recommendDownButton.setLayerOutLine(borderWidth: 1, cornerRadius: 2, borderColor: UIColor.lightGray)
        
        answerButton.addTarget(self, action: #selector(showReply), for: .touchUpInside)
        recommendUpButton.addTarget(self, action: #selector(voteGood), for: .touchUpInside)
        recommendDownButton.addTarget(self, action: #selector(voteBad), for: .touchUpInside)
        
        let upImage = UIImage(named: "ic_like")
        let downImage = UIImage(named: "ic_dislike")
        self.recommendUpButton.imageView?.contentMode = .scaleAspectFit
        self.recommendDownButton.imageView?.contentMode = .scaleAspectFit
        
        self.recommendUpButton.setImage(upImage, for: .normal)
        self.recommendDownButton.setImage(downImage, for: .normal)
    }
    
    func resetAction() {
        gotoRelpy = { _ in }
        voteAction = { _,_ in }
    }
    
    open func setInfo(info: VODCommentInfo, hideAnswerBtn: Bool = false ) {
        
        comment = info
        self.answerButton.isHidden = hideAnswerBtn
        self.updateContent()
        
    }
    
    open func updateCount(info: VODCommentInfo) {
        comment = info
        
        dispatchMain.async {
            
            self.answerButton.setTitle("\(I18N.text_replyLetter.localized) \(CellUtil.getNumberCommaFormat(numeral:self.comment.replyCount))", for: UIControl.State.normal)
            self.recommendUpButton.setTitle("\(CellUtil.getNumberCommaFormat(numeral:self.comment.goodCount))", for: UIControl.State.normal)
            self.recommendDownButton.setTitle("\(CellUtil.getNumberCommaFormat(numeral:self.comment.badCount))", for: UIControl.State.normal)
            
        }
        
    }
    
    //MARK: - Update content
    func updateContent() {
       
        let urlString = comment.urlProfileImg.urlQueryAllowedString
        
        self.profileImageView.sd_setImage(with: URL(string: urlString ), placeholderImage:basicLogoImage )
        
        self.nameLabel.text = comment.userNick
        
        self.commentLabel.text = comment.comment
        
        self.dateLabel.text = comment.writeDate
        
        self.answerButton.setTitle("\(I18N.text_replyLetter.localized) \(CellUtil.getNumberCommaFormat(numeral:comment.replyCount))", for: UIControl.State.normal)

        
        centerButtonAndImageAlign(with: recommendUpButton, spcaing: recommendUpButton.frame.width * 0.4, margin: recommendUpButton.frame.width * 0.1)
        centerButtonAndImageAlign(with: recommendDownButton, spcaing: recommendDownButton.frame.width * 0.4, margin: recommendDownButton.frame.width * 0.1)
        
        
        self.recommendUpButton.setTitle("\(CellUtil.getNumberCommaFormat(numeral:comment.goodCount))", for: UIControl.State.normal)
        self.recommendDownButton.setTitle("\(CellUtil.getNumberCommaFormat(numeral:comment.badCount))", for: UIControl.State.normal)
        
    }
    
    func centerButtonAndImageAlign(with button: UIButton, spcaing : CGFloat, margin: CGFloat) {
        button.imageEdgeInsets = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: spcaing)
        if #available(iOS 13.0, *) {
            button.titleEdgeInsets = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        } else {
            button.titleEdgeInsets = UIEdgeInsets(top: margin, left: -spcaing, bottom: margin, right: margin)
        }
        
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
}

