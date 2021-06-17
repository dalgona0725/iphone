//
//  MCInfoCellTableViewCell.swift
//  PopkonAir
//
//  Created by Brian Park on 2020/01/03.
//  Copyright © 2020 The E&M. All rights reserved.
//

import UIKit

class MCInfoViewCell: UITableViewCell {
	
	var vodInfo: CeluvVODInfo = CeluvVODInfo() {
		didSet {
			dispatchMain.async {
				self.updateContent()
			}
		}
	}
	
	@IBOutlet private weak var titleLabel: UILabel!
	@IBOutlet private weak var profileImageView: UIImageView!
	@IBOutlet private weak var nameLabel: UILabel!
	@IBOutlet private weak var dateLabel: UILabel!
	@IBOutlet private weak var favoriteCntLabel: UILabel!
	

    override func awakeFromNib() {
        super.awakeFromNib()
		
        setupCell()
    }
	
	func setupCell() {

		titleLabel.setNotoLightLabel(text: "", size: 20, color: .RGBColor(red: 60, green: 60, blue: 60))
		dateLabel.setNotoLightLabel(text: "", size: 12, color: .RGBColor(red: 159, green: 172, blue: 191))
		nameLabel.setNotoLightLabel(text: "", size: 14, color: .black)
		favoriteCntLabel.setNotoLightLabel(text: "", size: 12, color: .RGBColor(red: 159, green: 172, blue: 191))
		
		self.selectionStyle = .none
	}
	
	func updateContent() {
		guard let urlString = vodInfo.vodThumnail?.urlQueryAllowedString else { return }
			
		profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
		profileImageView.clipsToBounds = true
		profileImageView.layer.masksToBounds = true
		profileImageView.setLayerOutLine(borderWidth: 2, cornerRadius: profileImageView.frame.height / 2, borderColor: UIColor.RGBColor(red: 159, green: 172, blue: 191))
		
		self.profileImageView.sd_setImage(with: URL(string: urlString ), placeholderImage:basicLogoImage )
		self.nameLabel.text = vodInfo.vodOwner
		self.titleLabel.text = vodInfo.vodTitle
		
		guard let viewCnt = vodInfo.viewCnt else { return }
		guard let date = vodInfo.vSetDate else { return }
		self.dateLabel.text = "\(CellUtil.getDateString(with: date)) 등록ㆍ\(CellUtil.getNumberCommaFormat(text:viewCnt))회 재생"
	}
	
	static var nib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
	
	static var identifier: String {
		return String(describing: self)
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
	
	
    
}
