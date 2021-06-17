//
//  NoticeItemCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 1. 8..
//  Copyright © 2018년 eugene. All rights reserved.
//
import UIKit

class NoticeItemCell: UITableViewCell {
    
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    
    var notice = NoticeInfo()
    var copyright = CopyrightInfo()
    var itemType : NoticeType = .notice
    
    enum NoticeType {
        case notice
        case copyright
    }
    
    open func setInfo(info : NoticeInfo ) {
        notice = info
        itemType = .notice
        self.updateContent()
    }
    
    open func setCopyrightInfo(info : CopyrightInfo) {
        copyright = info
        itemType = .copyright
        self.updateContent()
    }
    
    //MARK: - Update content
    func updateContent() {
        if itemType == .notice {
            postTitle.text = notice.title.replacingOccurrences(of: "\r\n", with: "")
            postDate.text = getDateString(with: notice.writtenDate)
        } else if itemType == .copyright {
            postTitle.text = copyright.title.replacingOccurrences(of: "\r\n", with: "")
            postDate.text = getDateString(with: copyright.writtenDate)
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

