//
//  RankInfoCell.swift
//  PopkonAir
//
//  Created by Steven on 01/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SDWebImage
class RankInfoCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var onAirLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var channelLabel: UILabel!    
    
    @IBOutlet weak var addFavoriteButton: UIButton!
    @IBOutlet weak var writeLetterButton: UIButton!
    
    var onWriteLetter : (_ casterID: String) -> Void = { id in }
    var onFavoriteCaster : (_ casterID: String, _ partnderCode: String) -> Void = { (McId,partner) in }
    
    var casterID : String = ""
    var casterPartnerCode : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        containerView.setLayerOutLine(borderWidth: 0, cornerRadius: 2, borderColor: #colorLiteral(red: 0.8156862745, green: 0.8352941176, blue: 0.8588235294, alpha: 1).withAlphaComponent(0.5))
        addFavoriteButton.setLayerOutLine(borderWidth: 1.5, cornerRadius: 2, borderColor: #colorLiteral(red: 0.8156862745, green: 0.8352941176, blue: 0.8588235294, alpha: 1) )
        writeLetterButton.setLayerOutLine(borderWidth: 1.5, cornerRadius: 2, borderColor: #colorLiteral(red: 0.8156862745, green: 0.8352941176, blue: 0.8588235294, alpha: 1) )
        onAirLabel.setLayerOutLine(borderWidth: 0, cornerRadius: 2, borderColor: UIColor.clear)
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.setLayerOutLine(borderWidth: 0, cornerRadius: profileImageView.bounds.height * 0.46, borderColor: UIColor.clear)
        
        //self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    open func setInfo(mcRank : MCRankInfo) {
        
        self.casterID = mcRank.mc.signID
        self.casterPartnerCode = mcRank.mc.partnerCode
        profileImageView.sd_setImage(with: URL(string: mcRank.mc.pFileName), placeholderImage: #imageLiteral(resourceName: "ico_rankProfileDefault"))
        
        onAirLabel.isHidden = (mcRank.castStatus == "0")
        nicknameLabel.text = mcRank.mc.nickname
        channelLabel.text = mcRank.channelName
        
        rankLabel.text = mcRank.rankNum
        if mcRank.rankNum == "1" || mcRank.rankNum == "2" || mcRank.rankNum == "3" {
            rankLabel.textColor = #colorLiteral(red: 0.8666666667, green: 0.2078431373, blue: 0.09411764706, alpha: 1)
        } else {
            rankLabel.textColor = #colorLiteral(red: 0.1647058824, green: 0.1647058824, blue: 0.1647058824, alpha: 1)
        }
    }
    
    @IBAction func writeLetterAction(_ sender: Any) {
        self.onWriteLetter(casterID)
    }
    @IBAction func addFavoriteAction(_ sender: Any) {
        self.onFavoriteCaster(casterID,casterPartnerCode)
    }

}
