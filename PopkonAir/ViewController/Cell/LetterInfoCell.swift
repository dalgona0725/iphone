//
//  LetterInfoCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 5. 17..
//  Copyright © 2018년 eugene. All rights reserved.
//

import UIKit

class LetterInfoCell : UITableViewCell {
    
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var checkLabel: UILabel!
    
    var isReceived : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.contentView.setLayerOutLine()
    }
    
    open func setLetterType(isReceived: Bool) {
        self.isReceived = isReceived
    }
    
    open func setText(text: String) {
        senderLabel.text = " "
        timeLabel.text = " "
        checkLabel.text = " "
        messageLabel.text = text
        messageLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
    }
    
    open func setInfo(paper: PaperInfo) {
        
        // 관리자 쪽지 강조처리
        messageLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
        messageLabel.font = UIFont.notoLightFont(ofSize: 13)
        
        if paper.accountLevel == .administrator {
            senderLabel.text = I18N.text_supervisor.localized
            if isReceived {
                messageLabel.textColor = #colorLiteral(red: 0.9058823529, green: 0.3764705882, blue: 0.2901960784, alpha: 1)
                messageLabel.font = UIFont.notoBoldFont(ofSize: 13)
            }
            
        } else {
            if isReceived {
                senderLabel.text = paper.sendSignID
            } else {
                senderLabel.text = paper.receiveSignID
            }
        }
        
        /*
        if isReceived {
            
            // 관리자 쪽지 강조처리
            if paper.accountLevel == .administrator {
                senderLabel.text = "관리자"
                messageLabel.textColor = #colorLiteral(red: 0.9058823529, green: 0.3764705882, blue: 0.2901960784, alpha: 1)
                messageLabel.font = UIFont.notoBoldFont(ofSize: 13)
            } else {
                senderLabel.text = paper.sendSignID
                messageLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
                messageLabel.font = UIFont.notoLightFont(ofSize: 13)
            }
            
            senderLabel.text = paper.sendSignID
            messageLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
            messageLabel.font = UIFont.notoLightFont(ofSize: 13)

        } else { // isSent
            senderLabel.text = paper.receiveSignID
            messageLabel.textColor = #colorLiteral(red: 0.5019607843, green: 0.5019607843, blue: 0.5019607843, alpha: 1)
            messageLabel.font = UIFont.notoLightFont(ofSize: 13)
        } */
        
        var title = paper.text.replacingOccurrences(of: "\r\n", with: "")
        title = title.replacingOccurrences(of: "\t", with: "")
        messageLabel.text = title
        timeLabel.text = CellUtil.getDateString(with: paper.sendDate)
        checkLabel.text = paper.receiveDate.isEmpty ? I18N.ui_unconfirmed.localized : I18N.ui_confirmed
    }
    
}
