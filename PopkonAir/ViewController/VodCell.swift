//
//  VodCell.swift
//  Test
//
//  Created by  seob on 22/11/2018.
//  Copyright © 2018 seob. All rights reserved.
//

import UIKit
import SDWebImage

class VodCell: UITableViewCell {
	
    @IBOutlet weak var vodTitleLabel: UILabel!
    @IBOutlet weak var vodSubTitleLabel: UILabel!
    @IBOutlet weak var vodThumbImageView: UIImageView!
	@IBOutlet weak var cntImgView: UIImageView!
	@IBOutlet weak var watchCntLb: UILabel!
	
    var celuvList : CastInfo = CastInfo() {
        didSet {
            udpateContent()
        }
    }
    
    var onClick : (_ vod : CastInfo) -> Void = {
        vod in
        
     }
    
    func udpateContent() {
		var url:String
		
		url = celuvList.pFileName != "" ? celuvList.pFileName : celuvList.thumbFileName
		
		vodTitleLabel.text = celuvList.castTitle
        vodSubTitleLabel.text = celuvList.nickName
        vodThumbImageView.sd_setImage(with: URL(string: url.urlQueryAllowedString))
        vodThumbImageView.contentMode = .scaleAspectFill
		watchCntLb.text = "\(celuvList.watchCnt)".getDecimalString
    }
	
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
    
    @IBAction func clickAction(_ sender: Any) {
        onClick(celuvList)
    }
}
