//
//  TextViewCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 1. 11..
//  Copyright © 2018년 eugene. All rights reserved.
//

import UIKit

class CounselAnswerCell : UITableViewCell {
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.contentView.setLayerOutLine()
    }
    
    open func setInfo(text: String) {
        answerLabel.text = text
    }
    
}
