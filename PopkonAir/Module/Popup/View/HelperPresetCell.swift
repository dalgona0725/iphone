//
//  HelperPresetCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2020/10/10.
//  Copyright © 2020 The E&M. All rights reserved.
//



class HelperPresetCell: UITableViewCell {
    
    @IBOutlet weak var checkBoxButton: UIButton!
    @IBOutlet weak var presetLabel: UILabel!
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //checkBoxButton.isEnabled = false
    }
 
    @IBAction func clickPreset(_ sender: UIButton) {
        /// sender.isSelected.toggle()
    }
}
