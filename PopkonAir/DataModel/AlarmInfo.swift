//
//  AlarmInfo.swift
//  PopkonAir
//
//  Created by Steven on 27/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Time {
    var hour    : Int = 0
    var minute  : Int = 0
    
    mutating func setTime(with text : String) {
        if text.count == 4 {
           hour = Int((text as NSString).substring(to: 2))!
           minute = Int((text as NSString).substring(from: 2))!
        }else {
            hour = 0
            minute = 0
        }
    }
}

class AlarmInfo: NSObject {
    
    var isOn        : Bool = false
    var startTime   : Time = Time()
    var endTime     : Time = Time()
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        isOn            = (json[alIsOnKey].stringValue == "1")
        startTime   .setTime(with: json[alOffTimeStartKey].stringValue)
        endTime     .setTime(with: json[alOffTimeEndKey].stringValue)
    }

}
