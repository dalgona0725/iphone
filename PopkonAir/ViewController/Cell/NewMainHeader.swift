//
//  NewMainHeader.swift
//  Celuv
//
//  Created by BumSoo Park on 03/01/2019.
//  Copyright © 2019 roy. All rights reserved.
//

import UIKit

class NewMainHeader: UITableViewCell {
	
	@IBOutlet weak var titleLb: UILabel!
	@IBOutlet weak var viewAllBtn: UIButton!

	var onSelect : () -> Void = {}
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    
	@IBAction func onViewAllBtn(_ sender: UIButton) {
//		gotoViewController(index: 2)
//		print("--------click")
		onSelect()
	}
	
	func gotoViewController(index: Int) {
		//onSelect()
//		sideMenuManager.select(at: index)
		
//		print("--------click")
		
	}
	
}
