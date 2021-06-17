//
//  MCInfo.swift
//  PopkonAir
//
//  Created by Steven on 13/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SwiftyJSON

class MCInfo: NSObject {
    
    var vodCnt      : String            = ""
    var maxDate     : String            = ""
    var signID      : String            = ""
    var partnerCode : String            = ""
    var nickname    : String            = ""
    var pFileName   : String            = ""
    var viewCnt     : String            = ""
    
    /// 방송자 레벨
    var levelMC     : Int               = 0
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        vodCnt          = json[vVodCntKey].stringValue
        maxDate         = json[vMaxDateKey].stringValue
        signID          = json[vSignIdKey].stringValue
        partnerCode     = json[vPartnerCodeKey].stringValue
        nickname        = json[vNickNameKey].stringValue
        pFileName       = json[vPfileNameKey].stringValue
        viewCnt         = json[vViewCntKey].stringValue        
        levelMC         = json[lvCastLvKey].intValue
    }
    
}
