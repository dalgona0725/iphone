//
//  AlarmTimeCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 1. 1..
//  Copyright © 2018년 eugene. All rights reserved.
//


import UIKit

protocol ReferenceItemClear {
    func clear()
}

class AlarmTimeCell : UITableViewCell, ReferenceItemClear {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
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
    
        titleLabel.text = option.title
        
        let dateform = DateFormatter()
        dateform.dateFormat = "HHmm"
        if let datetime = dateform.date(from: option.text) {
            let outform = DateFormatter()
            outform.dateFormat = "a hh:mm"
            dateLabel.text = outform.string(from: datetime)
        }
        
    }
    
}
