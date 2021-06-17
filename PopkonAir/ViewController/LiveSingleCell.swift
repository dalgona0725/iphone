//
//  LiveSingleCell.swift
//  PopkonAir
//
//  Created by Brian Park on 05/09/2019.
//  Copyright © 2019 The E&M. All rights reserved.
//

import UIKit

class LiveSingleCell: UITableViewCell {
	
	var celuvList : CastInfo = CastInfo() {
		didSet {
			udpateContent()
		}
	}
	
	var onClick : (_ cast : CastInfo) -> Void = {
		cast in
		
	}

	@IBOutlet weak var imgView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var nickNameLabel: UILabel!
	@IBOutlet weak var cntLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

		self.selectionStyle = .none
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
	
	private func udpateContent() {
		self.imgView.sd_setImage(with: URL(string: self.celuvList.pFileName))
		self.titleLabel.text = celuvList.castTitle
		self.nickNameLabel.text = celuvList.nickName
		self.cntLabel.text = "\(celuvList.watchCnt)".getDecimalString
		
	}
	
	@IBAction func clickAction(_ sender: Any) {
		onClick(celuvList)
	}
	
}
