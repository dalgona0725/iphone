//
//  FanMCInfo.swift
//  PopkonAir
//
//  Created by Steven on 13/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SwiftyJSON

enum FanLevel : Int {
    ///최상위 팬등급 (VIP)
    case vip            = 0
    ///상위 팬등급 (다이아)
    case diamond        = 1
    ///하위 팬등급 (골드)
    case gold           = 2
    ///최하위 팬등급 (실버)
    case silver         = 3
    ///팬등급 없음
    case none           = 4
    
    static let allValues = [ vip, diamond, gold, silver ]
    
    func stringValue()->String {
        switch self {
        case .none:
            return I18N.text_nofanlevel.localized
        case .silver:
            return I18N.text_siverFan.localized
        case .gold:
            return I18N.text_goldFan.localized
        case .diamond:
            return I18N.text_daiaFan.localized
        case .vip:
            return I18N.text_vipFan.localized 
        }
    }
    
    func iconImage()->UIImage? {
        switch self {
        case .none:
            return nil
        case .silver:
            return #imageLiteral(resourceName: "bronze")
        case .gold:
            return #imageLiteral(resourceName: "silver")
        case .diamond:
            return #imageLiteral(resourceName: "gold")
        case .vip:
            return #imageLiteral(resourceName: "diamond")
        }
    }
}

///시청자 기준 방송자 정보
class FanMCInfo: NSObject {
    
    ///방송자 아이디
    var signID      : String            = ""
    
    ///방송자 닉네임
    var nickname    : String            = ""
    
    ///방송자 순위
    var rank        : String            = ""
    
    ///팬 회원수
    var fanCount    : Int               = 0
    
    ///팬 회원수
    var favorCount  : Int               = 0
    
    ///즐겨찾기 상태 여부
    var isFavored   : Bool              = false
    
    ///팬등급
    var fanLevel    : FanLevel          = .none
    
    ///팬등급명
    var fanLevelName: String            = ""
    
    ///팬가입 필요코인 개수
    var needCoin    : Int               = 0
 
    /// 방송자 레벨
    var levelMC     : Int               = 0

    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        signID              = json[fmSignIdKey].stringValue
        nickname            = json[fmNicknameKey].stringValue
        rank                = json[fmRankKey].stringValue
        fanCount            = json[fmFanCntKey].intValue
        favorCount          = json[fmBmkCntKey].intValue
        isFavored           = (json[fmIsBmkKey].stringValue == "1")
        fanLevel            = FanLevel(rawValue: json[fmFanLevelKey].intValue) ?? .none
        fanLevelName        = json[fmFanLevelNameKey].stringValue
        needCoin            = json[fmNeedCoinKey].intValue
        levelMC             = json[lvCastLvKey].intValue

    }
}


