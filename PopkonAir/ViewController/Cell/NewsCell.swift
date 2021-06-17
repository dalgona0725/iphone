//
//  NewsCell.swift
//  PopkonAir
//
//  Created by Brian Park on 26/08/2019.
//  Copyright © 2019 The E&M. All rights reserved.
//

import UIKit

class NewsCell: UITableViewCell {

	var newsData: NewsInfo? {
		didSet {
			self.setupCell()
		}
	}
	
	@IBOutlet weak var imgView: UIImageView!
	@IBOutlet weak var titleLb: UILabel!
	@IBOutlet weak var descLb: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
		self.backgroundColor = .clear
        imgView.setLayerOutLine(borderWidth: 1, cornerRadius: 2, borderColor: UIColor.clear)
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
	
	func setupCell() {
		guard let data = newsData else { return }
		dispatchMain.async {
			self.imgView.sd_setImage(with: URL(string: data.imgUrl))
		}
		titleLb.text = data.title.htmlToString
		descLb.text = data.content.htmlToString
	}
    
}
