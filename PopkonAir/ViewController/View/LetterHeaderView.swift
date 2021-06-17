//
//  LetterHeaderView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 5. 11..
//  Copyright © 2018년 eugene. All rights reserved.
//

import Foundation

class LetterHeaderView : UITableViewHeaderFooterView {
    
    @IBOutlet weak var letterOwnerLabel: UILabel!
    @IBOutlet weak var letterContentLabel: UILabel!
    @IBOutlet weak var letterTimeLabel: UILabel!
    @IBOutlet weak var letterReceiveLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        
        self.setLayerOutLine(borderWidth: 0, cornerRadius: 0, borderColor: UIColor.darkGray)
    }
    
    func setLetterType(isReceived: Bool) {
        letterOwnerLabel.text = isReceived ? I18N.text_sender.localized : I18N.text_receiver.localized
        letterTimeLabel.text = isReceived ? I18N.text_receiveDate.localized : I18N.text_sendDate.localized
        letterContentLabel.text = I18N.text_letterContent.localized
        letterReceiveLabel.text = I18N.text_isReceived.localized
    }
}
