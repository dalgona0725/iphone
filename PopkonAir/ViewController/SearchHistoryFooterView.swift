//
//  SearchHistoryFooterView.swift
//  PopkonAir
//
//  Created by Brian Park on 2020/06/11.
//  Copyright © 2020 The E&M. All rights reserved.
//

import UIKit

class SearchHistoryFooterView: UITableViewHeaderFooterView {
	
	@IBOutlet private weak var commentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
       
		setupUI()
    }
	
	static var nib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
	
	static var identifier: String {
		return String(describing: self)
	}
	
	private func setupUI() {
		commentLabel.text = I18N.text_searchHistory.localized
	}
}
