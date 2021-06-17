//
//  CounselNoContentCell.swift
//  PopkonAir
//
//  Created by Brian Park on 2020/07/16.
//  Copyright © 2020 The E&M. All rights reserved.
//

import UIKit

class CounselNoContentCell: UITableViewCell {
	
	@IBOutlet weak var label: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
		
		label.text = I18N.text_noContentCounsel.localized
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	static var nib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
	
	static var identifier: String {
		return String(describing: self)
	}
    
}
