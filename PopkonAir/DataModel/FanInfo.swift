//
//  FanInfo.swift
//  PopkonAir
//
//  Created by Steven on 25/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SwiftyJSON

class FanInfo: NSObject {
    
    ///팬순위
    var rank        : String = ""
    
    ///팬닉네임
    var nickname    : String = ""
    
    ///팬아이디
    var signID      : String = ""
    
    ///팬등급
    var level       : FanLevel = .none
    
    ///팬성별 (0: 여성 , 1: 남성)
    var sex         : Bool = false
    
    ///팬순위
    var printID     : String = ""
    
    /// 서비스 레벨
    var sSvcLevel   : Int = 0
    
    /// 팬 레벨
    var sFanLevel   : Int = 0
    
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        rank            = json[fRankKey].stringValue
        nickname        = json[fNickNameKey].stringValue
        signID          = json[fSignIDKey].stringValue
        level           = FanLevel(rawValue: json[fLevelKey].intValue) ?? .none
        sex             = (json[fSexKey].stringValue == "1")
        printID         = json[fPrintIdKey].stringValue
        sSvcLevel         = json[lvServiceLevelKey].intValue
        sFanLevel         = json[lvFanLevelKey].intValue
    }
}
