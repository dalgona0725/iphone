//
//  VodHeaderCell.swift
//  PopkonAir
//
//  Created by Brian Park on 2019/12/20.
//  Copyright © 2019 The E&M. All rights reserved.
//

import UIKit

class VodHeaderCell: UITableViewHeaderFooterView {
	
	var totalCommentCnt = 0 {
		didSet {
			dispatchMain.async {
				self.updateContent()
			}
		}
	}
	
	var sortType = VODCommentSortBy.latest {
		didSet {
			dispatchMain.async {
				self.updateSortButton()
			}
		}
	}
	
	
	@IBOutlet private weak var commentLabel: UILabel!
	@IBOutlet private weak var commentCntLabel: UILabel!
    @IBOutlet private weak var sortHotestButton: UIButton!
    @IBOutlet private weak var sortLatestButton: UIButton!
	
    var sortByLatest : (_ sort : VODCommentSortBy) -> Void = { sort in }
	var sortByHotest : (_ sort : VODCommentSortBy) -> Void = { sort in }
	
    override func awakeFromNib() {
        super.awakeFromNib()
       
		setupCell()
    }
	
	static var nib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
	
	static var identifier: String {
		return String(describing: self)
	}
	
	func setupCell() {
		commentLabel.setNotoBoldLabel(text: I18N.ui_reply.localized, size: 16, color: .black)
		commentCntLabel.setNotoLightLabel(text: "", size: 16, color: .celuvPupleColor())
		sortLatestButton.setTitle(I18N.text_sortLatest.localized, for: .normal)
		sortHotestButton.setTitle(I18N.text_sortHotest.localized, for: .normal)
		updateSortButton()
	}
	
	//MARK: - Update content
	func updateContent() {
		self.commentCntLabel.text = "\(CellUtil.getNumberCommaFormat(numeral : totalCommentCnt))" + I18N.ui_numOfCoin.localized
	}
	
	func updateSortButton() {
		if self.sortType == .latest {
			self.sortLatestButton.setTitleColor(.celuvPupleColor(), for: .normal)
			self.sortHotestButton.setTitleColor(.lightGray, for: .normal)
			sortLatestButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Bold", size: 13)
			sortHotestButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Light", size: 13)
		} else {
			self.sortLatestButton.setTitleColor(.lightGray, for: .normal)
			self.sortHotestButton.setTitleColor(.celuvPupleColor(), for: .normal)
			sortLatestButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Light", size: 13)
			sortHotestButton.titleLabel?.font = UIFont(name: "NotoSansCJKkr-Bold", size: 13)
		}
	}
	
	//MARK: - IBAction
    @IBAction func sortByLatest(_ sender: UIButton) {
		sortByLatest(sortType)
    }
	
    @IBAction func sortByHotest(_ sender: UIButton) {
		sortByHotest(sortType)
    }
	
	
    
}
