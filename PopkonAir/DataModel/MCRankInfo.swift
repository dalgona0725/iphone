//
//  MCRankInfo.swift
//  PopkonAir
//
//  Created by Steven on 13/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SwiftyJSON

class MCRankInfo: NSObject {
    
    ///방송여부 (0 : OFF , 1 : ON)
    var castStatus  : String            = ""
    
    ///순위
    var rankNum     : String            = ""
    
    var channelName : String            = ""
    
    var mc : MCInfo = MCInfo()
    
    /// 방송 카테고리
    var category    : String            = ""
    
    open func setInfo(json : JSON) {
        
        //log.debug(json)
        
        mc.signID           = json[mcSignIdKey].stringValue
        mc.partnerCode      = json[mcPartnerCodeKey].stringValue
        mc.nickname         = json[mcNickNameKey].stringValue
        mc.pFileName        = json[mcPFileNameKey].stringValue
        
        castStatus          = json[mcCastStatusKey].stringValue
        rankNum             = json[mcRankNumKey].stringValue
        channelName         = json[mcChannelKey].stringValue
        category            = json[cmCategory].stringValue
    }
        
    var isCommerce : Bool {
        return category == cmeCategoryCommerce
    }
}
