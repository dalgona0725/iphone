//
//  VodAdInfo.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 6. 20..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit
import SwiftyJSON

enum AdType : String {
    /// 단일 full 영상광고
    case singleFull     = "0"
    /// 단일 skip 영상광고
    case singleSkip     = "1"
    /// 복수 full 영상광고
    case multipleFull   = "2"
    /// 방송스타트 단일 영상광고
    case startVodAd     = "3"
}

enum AdViewType : String {
    // 스타트 영상 광고
    case start          = "1"
    // 중간 영상 광고
    case middle         = "2"
}

enum AdViewEvent : String {
    case view          = "1"
    case skip          = "2"
    case link          = "3"
}

enum ImgAdType : String {
    case exeAD         = "S"
    case endAD         = "E"
    case listAD        = "MLB"
}

enum ImgAdViewEvent : String {
    case view          = "1"
    case link          = "2"
}

class VodAdInfo: NSObject {
    
    /// 광고코드
    var adCode          : String       = ""
    
    /// 광고 스트림 URL
    var adVodURL        : String       = ""
    
    /// 광고 Link URL
    var adLinkURL       : String       = ""
    
    /// 링크광고 적용여부 (0:미적용, 1:적용)
    var isLink          : Bool         = false
    
    /// 영상 시간 (단위/초)
    var adVodTime       : UInt32       = 0
    
    /// skip 시간 (단위/초)
    var adSkipTime      : UInt32       = 0
    
    /// skip 적용 여부 (0:미적용, 적용)
    var isSkip          : Bool         = false
    
    
    open func setInfo(json: JSON) {
        log.debug(json)
        
        adCode          = json[vaAdId].stringValue
        adVodURL        = json[vaVodURL].stringValue
        adLinkURL       = json[vaLinkURL].stringValue
        isLink          = (json[vaIsLink].stringValue == "1")
        adVodTime       = UInt32(json[vaVodTime].intValue)/1000
        adSkipTime      = UInt32(json[vaSkipTime].intValue)/1000
        isSkip          = (json[vaIsSkip].stringValue == "1")
        
    }

}
