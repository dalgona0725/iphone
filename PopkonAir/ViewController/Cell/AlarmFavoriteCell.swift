//
//  AlarmFavoriteCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 1. 1..
//  Copyright © 2018년 eugene. All rights reserved.
//

import UIKit

class AlarmFavoriteCell : UITableViewCell, ReferenceItemClear {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var castNameLabel: UILabel!
    @IBOutlet weak var alarmOnOffSwitch: UISwitch!
    
    var onChange : (String,Bool) -> Void = { (pushCode,onOff) in }
    var pushInfo = PushFavoriteInfo()
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func clear() {
        pushInfo = PushFavoriteInfo()
        onChange = { _,_ in }
    }
        
    func setInfo(option: PushFavoriteInfo) {
        
        //Cast Image
        //self.profileImageView.sd_setImage(with: URL(string: option.pFileName))
        profileImageView.setLayerOutLine(borderWidth: 1, cornerRadius: 2, borderColor: UIColor.lightGray )
        profileImageView.contentMode = .scaleAspectFill
		profileImageView.clipsToBounds = true
		
        profileImageView.sd_setImage(with: URL(string: option.pFileName), completed: { (image, error, cacheType, url) in
            dispatchMain.async {
                if let img = image {
                    let ratio = img.size.height / img.size.width
                    let newHeight = ratio * self.profileImageView.frame.width
                    self.profileImageView.frame.size = CGSize(width: self.profileImageView.frame.width, height: newHeight)
                }
            }
        })
        
        
        //Cast name
        self.castNameLabel.text = option.nickname
        
        alarmOnOffSwitch.isOn = option.isPushOn
        
        pushInfo = option
        
    }
    
    @IBAction func onChangeValued(_ sender: UISwitch) {
        if userInfo.isLogined {
            //connection.setFavoritePushOnOff(pushCode: pushInfo.pushCode, isOn: sender.isOn, complete: { (succeed, resultInfo) in
            //})
            onChange(pushInfo.pushCode, sender.isOn)
        } else {
            alarmOnOffSwitch.isOn = !sender.isOn
        }
        
    }
}

