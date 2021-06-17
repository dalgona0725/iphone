//
//  OptionSectionView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 12. 28..
//  Copyright © 2017년 eugene. All rights reserved.
//

import Foundation

class OptionSectionView : UITableViewHeaderFooterView, ReferenceItemClear {
    
    @IBOutlet weak var panelView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var optionSwitch: UISwitch!
    
    var onChanageOptSw : (UISwitch) -> Void = { sw in }
    
    
    func setInfo(title: String, hideSwitch: Bool, onSwitchAction: @escaping (UISwitch) -> Void = { sw in } ) {
        
        //panelView.backgroundColor = self.contentView.backgroundColor
        
        titleLabel.text = title
        optionSwitch.isHidden = hideSwitch
        onChanageOptSw = onSwitchAction
    }
    
    func clear() {
        onChanageOptSw = { (sw) in }
    }
    
    @IBAction func optionChange(_ sender: UISwitch) {
        onChanageOptSw( sender )
    }
    
}
