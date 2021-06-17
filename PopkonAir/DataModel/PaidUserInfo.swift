//
//  PaidUserInfo.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 08/01/2019.
//  Copyright © 2019 The E&M. All rights reserved.
//

import UIKit
import SwiftyJSON

class PaidUserInfo: NSObject {
    
    /// 선물회원 아이디
    var userID : String       = ""
    
    /// 선물회원 파트너 코드
    var userPartnerCode : String = ""
    
    /// 선물갯수
    var giftCoin : Int  = 0
    
    open func setInfo(json : JSON) {
        log.debug(json)
        userID = json["giftSignId"].stringValue
        userPartnerCode = json["giftPartnerCode"].stringValue
        giftCoin = json["coin"].intValue
    }
}
