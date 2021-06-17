//
//  MCFanInfoCell.swift
//  PopkonAir
//
//  Created by Steven on 01/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class MCFanInfoCell: UITableViewCell {

    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var fanIcon: LevelIconButton!
    @IBOutlet weak var levelIcon: LevelIconButton!
    @IBOutlet weak var levelStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    open func setInfo(fan : FanInfo, nickColor : UIColor, type: FanRankType = .fanLevel) {

        rankLabel.text = fan.rank
        
        switch fan.rank {
        case "1":
            rankLabel.textColor = UIColor.rankingColor(.first)
        case "2":
            rankLabel.textColor = UIColor.rankingColor(.second)
        case "3":
            rankLabel.textColor = UIColor.rankingColor(.third)
        default:
            rankLabel.textColor = UIColor.rankingColor(.etc)
        }
        
        iconImageView.image = fan.level.iconImage()
        let userText = fan.nickname.trimmingCharacters(in: CharacterSet.init(charactersIn: "\0 \\ \t \n \r \" \' "))
        /// 팬레벨 추가되며 아이디 삭제
        // + "(" + fan.printID + ")"
        nicknameLabel.text = userText //protectUserID(with: userText, to: "*")
        
        /*
        if fan.sex {
            nicknameLabel.textColor = UIColor(hexString: nickBoy)
        } else {
            nicknameLabel.textColor = UIColor(hexString: nickGirl)
        } */
        nicknameLabel.textColor = nickColor
        
        levelInit(fan: fan.sFanLevel, service: fan.sSvcLevel)
        
        dispatchMain.async {
            self.iconImageView.isHidden = type == .bigFan ? false : true
            self.levelStackView.isHidden = type == .bigFan ? true : false
        }
    }
    
    func protectUserID(with message: String, to : String) -> String {
        if let part = message.range(of: "\\([^)]+\\)", options: .regularExpression) {
            if part.isEmpty == false {
                let distance = message.distance(from: part.lowerBound, to: part.upperBound)
                let length = distance/2
                let cStr = String(repeating: to, count: length)
                
                if length > 0  {
                    let start = message.index(part.upperBound, offsetBy: -length)
                    let end = message.index(part.upperBound, offsetBy: -1)
                    let idRange = Range(uncheckedBounds: (start, end))
                    let total = message.replacingCharacters(in: idRange, with: cStr)
                    return total
                }
            }
        }
        return message
    }
    
    /// 팬레벨, 서비스레벨 초기화
    private func levelInit(fan: Int, service: Int) {
        fanIcon.setupLevelInfo(type: .fan, level: fan)
        levelIcon.setupLevelInfo(type: .service, level: service)
    }
}
