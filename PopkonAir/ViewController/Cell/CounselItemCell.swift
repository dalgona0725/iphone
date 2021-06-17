//
//  CounselItemCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 1. 8..
//  Copyright © 2018년 eugene. All rights reserved.
//

import UIKit

class CounselItemCell: UITableViewCell {
    
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postReply: UILabel!
    
    var counsel = CounselInfo()
    
    open func setInfo(info : CounselInfo ) {
        counsel = info
        self.updateContent()
    }
    
    //MARK: - Update content
    func updateContent() {
        
        postTitle.text = counsel.title.replacingOccurrences(of: "\r\n", with: "")
        postDate.text = getDateString(with: counsel.writtenDate)
        
        if counsel.isAnswer {
            postReply.text = I18N.ui_replyDone.localized
            postReply.font = UIFont.notoMediumFont(ofSize: 15)
            postReply.textColor = #colorLiteral(red: 0, green: 0.5294, blue: 0.9373, alpha: 1)
        } else {
            postReply.text = I18N.ui_replyWaiting.localized
            postReply.font = UIFont.notoFont(ofSize: 15)
            postReply.textColor = postTitle.textColor
        }
    }

    func getDateString(with dateString: String) -> String {
        var result = ""
        let dateform = DateFormatter()
        dateform.dateFormat = "yyyyMMdd"
        dateform.calendar = Calendar(identifier: .gregorian)
        
        let index = dateString.index(dateString.startIndex, offsetBy: 8)
        let shortDate = String( dateString[..<index] )
        
        if let datetime = dateform.date(from: shortDate) {
            let outform = DateFormatter()
            outform.dateFormat = "yyyy-MM-dd"
            outform.calendar = Calendar(identifier: .gregorian)
            result = outform.string(from: datetime)
        }
        return result
    }
}
