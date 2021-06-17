//
//  MemberInfoCell.swift
//  PopkonAir
//
//  Created by Steven on 14/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class MemberInfoCell: UITableViewCell {

    @IBOutlet weak var mainView: UIStackView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var fanIcon: LevelIconButton!
    @IBOutlet weak var levelIcon: LevelIconButton!
    
    @IBOutlet weak var gradeView: UIView!
    @IBOutlet weak var gradeIcon: UIImageView!
    @IBOutlet weak var nicknameLabel02: UILabel!
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    open func setInfo(member : MemberInfo, isGrade: Bool) {
        dispatchMain.async {
            self.mainView.isHidden = isGrade ? true : false
            self.gradeView.isHidden = isGrade ? false : true
        }

        if isGrade {
            if member.roomLevel == .manager {
                gradeIcon.image = #imageLiteral(resourceName: "managerFan")
            } else {
                gradeIcon.image = member.level.iconImage()
            }
            nicknameLabel02.text = member.nickname
            nicknameLabel02.textColor = member.nicknameColor
        } else {
            nicknameLabel.text = member.nickname
            nicknameLabel.textColor = member.nicknameColor
            self.levelInit(fan: member.levelFan, service: member.levelService)
        }
    }
    
    /// 팬레벨, 서비스레벨 초기화
    open func levelInit(fan: Int, service: Int) {
        fanIcon.setupLevelInfo(type: .fan, level: fan)
        levelIcon.setupLevelInfo(type: .service, level: service)
    }
}
