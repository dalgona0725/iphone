//
//  VodReplyCell.swift
//  TVTen
//
//  Created by Eugene Jeong on 2017. 10. 26..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit

class VodReplyCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNickLabel: UILabel!
    @IBOutlet weak var replyLabel: UILabel!
    @IBOutlet weak var writeDateLabel: UILabel!
    
    private(set) public var comment : VODCommentInfo = VODCommentInfo()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code        
        profileImageView.setLayerOutLine(borderWidth: 0, cornerRadius: 2, borderColor: UIColor.clear)
    }
    
    open func setInfo(info: VODCommentInfo ) {
        
        comment = info
        self.updateContent()
        
    }
    
    //MARK: - Update content
    func updateContent() {
        
        self.profileImageView.sd_setImage(with: URL(string: comment.urlProfileImg.urlQueryAllowedString ), placeholderImage:basicLogoImage )
        
        self.userNickLabel.text = comment.userNick
        
        self.replyLabel.text = comment.comment
        
        self.writeDateLabel.text = comment.writeDate
    }
}
