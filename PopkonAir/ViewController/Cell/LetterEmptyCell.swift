//
//  LetterEmptyCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 9. 20..
//  Copyright © 2018년 roy. All rights reserved.
//


import UIKit

class LetterEmptyCell : UITableViewCell {

    @IBOutlet weak var noLetterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.contentView.setLayerOutLine()
        
        noLetterLabel.text = I18N.text_noLetter.localized
    }
    
}
