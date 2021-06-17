//
//  CounselHeaderView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 1. 9..
//  Copyright © 2018년 eugene. All rights reserved.
//

import Foundation

class CounselHeaderView : UITableViewHeaderFooterView {
    @IBOutlet weak var writeDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var replyedLabel: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        writeDateLabel.text = I18N.text_writtenDate.localized
        titleLabel.text = I18N.text_headerTitle.localized
        replyedLabel.text = I18N.text_isReplyed.localized
        
        self.setLayerOutLine(borderWidth: 0, cornerRadius: 0, borderColor: UIColor.darkGray)
    }
}

