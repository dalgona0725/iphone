//
//  FooterTableViewCell.swift
//  Celuv
//
//  Created by BumSoo Park on 17/01/2019.
//  Copyright © 2019 roy. All rights reserved.
//

import UIKit

class FooterTableViewCell: UITableViewCell {
	
	@IBOutlet weak var termBtn: UIButton!
	@IBOutlet weak var policyBtn: UIButton!
	@IBOutlet weak var faqBtn: UIButton!
	
	
	var onSelect : () -> Void = {}
	
	var onClick : (_ sender: UIButton) -> Void = {
		sender in
	}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
		termBtn.setTitle(I18N.bottom_terms_of_use.localized, for: .normal)
		policyBtn.setTitle(I18N.bottom_privacy_policy.localized, for: .normal)
		faqBtn.setTitle(I18N.bottom_faq.localized, for: .normal)
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
	
	// MARK: 하단 버튼 액션
	@IBAction func snsAction(_ sender: UIButton) {
		onClick(sender)
	}
	

}
