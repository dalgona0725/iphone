//
//  TitleLabelCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 1. 11..
//  Copyright © 2018년 eugene. All rights reserved.
//

import UIKit

class TitleLabelCell : UITableViewCell {
    
    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.contentView.setLayerOutLine()
    }
    
    open func setInfo(titleName: String, title: String) {
        sectionLabel.text = titleName
        titleLabel.text = title
    }
}
