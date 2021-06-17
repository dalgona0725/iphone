//
//  VODHotInfo.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 10. 19..
//  Copyright © 2017년 roy. All rights reserved.
//
import UIKit
import SwiftyJSON

class VODCategoryInfo: NSObject {
    
    /// VOD 코드
    var vodCode        : String            = ""
    
    /// VOD 원작자/게시자
    var vodOwner       : String            = ""
    
    /// VOD 제목
    var vodTitle       : String            = ""
    
    /// VOD 썸네일 URL
    var vodThumnail    : String            = ""
    
    /// VOD 조회수
    var viewCount      : Int              = 0
    
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        if json["vodCode"].stringValue != "" {
            vodCode = json["vodCode"].stringValue
        }
        
        if json["vodOwner"].stringValue != "" {
            vodOwner = json["vodOwner"].stringValue
        }
        
        if json["vodTitle"].stringValue != "" {
            vodTitle = json["vodTitle"].stringValue
        }
        
        if json["vodThumnail"].stringValue != "" {
            vodThumnail = json["vodThumnail"].stringValue
        }
        
        if json["viewCnt"].stringValue != "" {
            viewCount = json["viewCnt"].intValue
        }
        
    }
    
}

