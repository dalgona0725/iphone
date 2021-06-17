//
//  OptionInfoCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 7. 5..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit

class OptionInfoCell: UITableViewCell, ReferenceItemClear {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var onOffSwitch: UISwitch!
    
    var item : OptionItem = OptionItem()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func clear() {
        item = OptionItem()
    }

    
    func setInfo(option: OptionItem) {
        
        item = option
        
        if let attrText = option.attributedTitle {
            titleLabel.attributedText = attrText
        } else {
            titleLabel.text = option.title
        }
        
        onOffSwitch.isHidden = option.type == .slider ? false : true
        onOffSwitch.isOn = option.switchOn
        infoLabel.isHidden = option.type == .slider ? true : false
        
        if option.type == .link {
            //infoLabel.font = UIFont(name:"HelveticaNeue-Bold",size:22)
            infoLabel.font = UIFont.notoMediumFont(ofSize: 20)
            infoLabel.text = "\u{2771}"
        } else if option.type == .text {
            infoLabel.font = UIFont(name:"HelveticaNeue-Bold",size:14)
            infoLabel.text = option.text
        }
    }
    
    @IBAction func onValueChanged(_ sender: UISwitch) {
        item.onChange( sender )
    }
}
