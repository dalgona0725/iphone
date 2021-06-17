//
//  TestHeaderCell.swift
//  Celuv
//
//  Created by seob on 08/01/2019.
//  Copyright © 2019 roy. All rights reserved.
//

import UIKit

class LiveHeaderCell: UITableViewHeaderFooterView {
	
	@IBOutlet var contView: UIView!
	@IBOutlet weak var sortBtn: SelectDropButton!

	var onClickSubMenu : (_ index : Int) ->Void = {
		index in
	}
	
	override init(reuseIdentifier: String?) {
		super.init(reuseIdentifier: reuseIdentifier)
		initFromXIB()
	}
	
	private func initFromXIB() {
		let bundle = Bundle(for: type(of: self))
		let nib = UINib(nibName: "LiveHeaderCell", bundle: bundle)
		contView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
		contView.frame = self.frame
        contView.backgroundColor = UIColor.RGBColor(red: 245, green: 245, blue: 245)
		self.addSubview(contView)
		
		let sortBy = CastSortBy.allValues.map { (item) -> String in
			return item.stringValue()
		}
		
		sortBtn.setTitle(I18N.live_sortHotest.localized, for: .normal)
		sortBtn.dataSource = sortBy
		
		sortBtn.setSelectionAction { (index, item) in
			self.onClickSubMenu(index)
			self.sortBtn.setTitle(item, for: .normal)
		}
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@IBAction func onSortBtn(_ sender: UIButton) {
		sortBtn.showDropdown()
		
	}
	
}
