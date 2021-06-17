//
//  MemberInfo.swift
//  PopkonAir
//
//  Created by Steven on 14/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SwiftyJSON

enum RoomLevel : Int {
    case normal     = 0
    case manager    = 2
}

class MemberInfo: NSObject {

    
    ///팬아이디
    var signID          : String = ""
    
    ///팬닉네임
    var nickname        : String = ""
    
    ///팬성별 (0: 여성 , 1: 남성)
    var sex             : Bool = false
    
    ///시청경로
    var signPath        : String = ""
    
    ///파트너코드
    var partnerCode     : String = ""
    
    ///시청권한
    var accountLevel    : CWAccountLevel = .normal
    
    ///팬등급
    var level           : FanLevel = .none
    
    ///매니저권한 (0 : 일반등급, 2 : 매니저등급)
    var roomLevel       : RoomLevel = .normal
    
    /// 선물여부
    var isGifter        : Bool = false
    
    /// 경고 횟수
    var warnCount       : Int = 0
    
    /// 입장시간
    var entranceTime    : Int = 0
    
    /// 첫선물을 했는지 여부
    var isFirstGifter   : Bool = false
    
    /// 첫선물준 시간
    var firstGiftTime   : TimeInterval = 0
    
    /// 팬레벨
    var levelFan        : Int = 0
    /// 서비스 레벨
    var levelService    : Int = 0
    
    open func setInfo(json : JSON) {
        
        log.debug("\n-- \(String(describing: type(of: self))) --\n\(json)\n-----------------------------------------")
        
        signID          = json[mSignIDKey].stringValue
        nickname        = json[mNickNameKey].stringValue
        sex             = json[mMemberSexKey].stringValue == "1"
        signPath        = json[mSignPathKey].stringValue
        partnerCode     = json[mPartnerCodeKey].stringValue
        accountLevel    = CWAccountLevel(rawValue: json[mAccountLevelKey].intValue) ?? .normal
        level           = FanLevel(rawValue: json[mFanLevelKey].intValue) ?? .none
        roomLevel       = RoomLevel(rawValue: json[mRoomLevelKey].intValue) ?? .normal
        
        entranceTime    = json["inTime"].intValue
        isGifter        = json["isGifter"].stringValue == "1"
        warnCount       = json["warnCnt"].intValue
   
        levelFan        = json[lvFanLevelKey].intValue
        levelService    = json[lvServiceLevelKey].intValue
    }

    
    /// 멤버 닉네임 색상값
    var nicknameColor : UIColor {
        get {
            if roomLevel == .manager {
                return UIColor.yellow
            }
            if isFirstGifter {
                return #colorLiteral(red: 0, green: 0.6902, blue: 0.698, alpha: 1) /* #00b0b2 */
            }
            return UIColor.white
        }
    }
    
}
