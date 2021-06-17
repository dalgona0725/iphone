//
//  CoinStatusInfo.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 6. 7..
//  Copyright © 2018년 eugene. All rights reserved.
//


import UIKit
import SwiftyJSON

class CoinStatusInfo: NSObject {
    
    /// 당일 한도
    var dayLimit : Int = 0
    
    /// 당월 한도
    var monthLimit : Int = 0
    
    /// 당일 사용갯수
    var dayUse : Int = 0
    
    /// 당월 사용갯수
    var monthUse : Int = 0
    
    /// VIP 유무 (0:일반, 1:VIP)
    var isVip : Bool = false
    
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        dayLimit        = json["dayLimit"].intValue
        monthLimit      = json["monthLimit"].intValue
        dayUse          = json["dayUse"].intValue
        monthUse        = json["monthUse"].intValue
        isVip           = json["isVip"].intValue == 1 ? true : false
        
    }
}

