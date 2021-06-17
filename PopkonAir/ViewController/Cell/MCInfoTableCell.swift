//
//  MCInfoTableCell.swift
//  PopkonAir
//
//  Created by Steven on 26/12/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class MCInfoTableCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var mcNameLabel: UILabel!
    @IBOutlet weak var vodCntLabel: UILabel!
    @IBOutlet weak var viewCntLabel: UILabel!
    
    private(set) public var mc : MCInfo = MCInfo()
    
    
    open func setInfo(mc : MCInfo) {
        
        self.mc = mc
        
        self.updateContent()
    }
    
    //MARK: - Update content
    func updateContent() {
        
        //Cast Image
        self.postImageView.sd_setImage(with: URL(string: mc.pFileName), placeholderImage:basicLogoImage )
        
        //MC nickname
        self.mcNameLabel.text = mc.nickname
        
        //VOD count
        self.vodCntLabel.text = String(format: I18N.ui_numOfContent.localized, mc.vodCnt)
        
        //info
        self.viewCntLabel.text = "\(mc.viewCnt)\(I18N.text_viewerCount.localized)"
        
    }
}
