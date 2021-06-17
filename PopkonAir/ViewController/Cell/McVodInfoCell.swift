//
//  McVodInfoCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 6. 16..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit
import SDWebImage

class McVodInfoCell: UITableViewCell {
    @IBOutlet weak var vodTitleLabel: UILabel!
    @IBOutlet weak var vodUpdateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    open func setInfo(vod: VODInfo) {
        //self.vodImageView.sd_setImage(with: URL(string: vod.pFileName), placeholderImage: basicLogoImage)
        vodTitleLabel.text = vod.title
        vodUpdateLabel.text = CellUtil.getDateString(with: vod.postDateCode)  + " | \(I18N.text_watch.localized):" + CellUtil.getNumberCommaFormat(text: vod.viewCnt) + "  \(I18N.ui_sortRecommed.localized):" + CellUtil.getNumberCommaFormat(text: vod.recommendCnt)
    }
}
