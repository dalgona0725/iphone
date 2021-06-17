//
//  TestHeaderCell.swift
//  Celuv
//
//  Created by seob on 08/01/2019.
//  Copyright © 2019 roy. All rights reserved.
//

import UIKit

class TestHeaderCell: UITableViewHeaderFooterView {
	@IBOutlet var contView: UIView!
	@IBOutlet weak var titleLb: UILabel!
	@IBOutlet weak var liveLb: UILabel!
	@IBOutlet weak var viewAllBtn: UIButton!
	
  var onSelect : () -> Void = {}
	
  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)
    initFromXIB()
  }
  
  private func initFromXIB() {
    let bundle = Bundle(for: type(of: self))
    let nib = UINib(nibName: "TestHeaderCell", bundle: bundle)
	contView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
    contView.frame = self.frame
  	contView.backgroundColor = .white
    self.addSubview(contView)
	
	viewAllBtn.setTitle(I18N.text_view_all.localized + " >>", for: .normal)
  }
	
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  @IBAction func onViewAllBtn(_ sender: UIButton) {
    onSelect()
  }
	
}
