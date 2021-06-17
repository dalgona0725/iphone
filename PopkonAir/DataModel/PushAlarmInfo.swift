//
//  PushAlarmInfo.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 12. 27..
//  Copyright © 2017년 eugene. All rights reserved.
//


import UIKit
import SwiftyJSON

class PushAlarmInfo: NSObject {
    
    /// 알림 On/Off
    var isON            : Bool            = false
    
    /// 알림제외 시작시간
    var offTimeStart    : String          = ""
    
    /// 알림제외 종료시간
    var offTimeEnd      : String          = ""
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        if json["isOn"].stringValue != "" {
            isON = json["isOn"].stringValue == "0" ? false : true
        }
        
        if json["offTimeStart"].stringValue != "" {
            offTimeStart = json["offTimeStart"].stringValue
        }
        
        if json["offTimeEnd"].stringValue != "" {
            offTimeEnd = json["offTimeEnd"].stringValue
        }
    }
}


class PushEventInfo: NSObject {
    
    /// event push on/off
    var isON            : Bool            = false
    
    /// event 등록일
    var eventDate       : String          = ""
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        if json["isEventOn"].stringValue != "" {
            isON = json["isEventOn"].stringValue == "0" ? false : true
        }
        
        if json["EventOn_regdate"].stringValue != "" {
            eventDate = json["EventOn_regdate"].stringValue
        }
    }
}
