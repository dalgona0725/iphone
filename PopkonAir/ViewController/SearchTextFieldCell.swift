//
//  SearchTextFieldCell.swift
//  PopkonAir
//
//  Created by Brian Park on 2020/06/08.
//  Copyright © 2020 The E&M. All rights reserved.
//

import UIKit
class SearchTextFieldCell: UITableViewCell {
	// MARK: - Properties
	// MARK: var
	var searchDB: SearchHistoryList? {
		didSet {	// 데이터가 추가되면 셀 초기화
			self.setupCell()
		}
	}
    
	// MARK: IBOutlet
	@IBOutlet private weak var textLb: UILabel!
	@IBOutlet private weak var dateLb: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!

	// MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
	
	static var nib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
	
	static var identifier: String {
		return String(describing: self)
	}
	
	// MARK: Function
	func setupCell() {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "MM/dd"
		
		if let db = searchDB {
			textLb.text = db.content
			dateLb.text = dateFormatter.string(from: db.time)
		}
	}
}
