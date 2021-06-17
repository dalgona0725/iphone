//
//  VODInfo.swift
//  PopkonAir
//
//  Created by Steven on 13/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SwiftyJSON

class VODInfo: NSObject {

    /// VOD 코드
    var vodCode         : String            = ""
    
    /// VOD 사용자 게시일자코드 (YYYYmmDDhhNNss)
    var postDateCode    : String            = ""
    
    /// VOD 누적시청수
    var viewCnt         : String            = ""
    
    /// VOD 누적추천수
    var recommendCnt    : String            = ""
    
    /// VOD 사용자 게시여부 (0:미게시,1:게시)
    var isService       : Bool              = false
    
    /// VOD 성인방송여부 (0:비성인,1:성인)
    var isAdult         : Bool              = false
    
    /// VOD 시청팬등급
    var fanLevel        : FanLevel          = .none
    
    /// 방송일자코드 (YYYYmmDDhhNNss)
    var startDateCode   : String              = ""
    
    /// 방송분량 (분단위)
    var totalMinute     : String            = ""
    
    /// 방송자 회원아이디
    var signID          : String            = ""
    
    ///방송제목
    var title           : String            = ""
    
    ///방송자 파트너사 코드 (ASP)
    var partnerCode     : String            = ""
    
    ///카테고리 (참조)
    var categoryCode    : String      = ""
    
    /// 방송자회원닉네임
    var nickname        : String            = ""

    ///썸네일 이미지 파일
    var thumbFileName : String = ""
    /// 방송자 프로필이미지 파일경로
    var pFileName       : String            = ""
    
    ///VOD경로
    var path : String = ""
    
    ///시청코인값
    var useCoinValue : String = ""
    
    ///상세정보
    var memo : String = ""

    open func setInfo(json : JSON) {
        
        //log.debug(json)
        
        if json["vodCode"].stringValue != "" {
            vodCode = json["vodCode"].stringValue
        }
        
        if json["vSetDate"].stringValue != "" {
            postDateCode        = json["vSetDate"].stringValue
        }
        
        if json["vViewCnt"].stringValue != "" {
            viewCnt = json["vViewCnt"].stringValue
        }
        
        if json["vRecommendCnt"].stringValue != "" {
            recommendCnt = json["vRecommendCnt"].stringValue
        }
        
        if json["vIsService"].stringValue != "" {
            isService = json["vIsService"].stringValue == "1"
        }
        
        if json["vIsAdultSet"].stringValue != "" {
            isAdult = json["vIsAdultSet"].stringValue == "1"
        }
        
        if json["vFanLevel"].stringValue != "" {
            fanLevel = FanLevel(rawValue:json["vFanLevel"].intValue) ?? .none
        }
        
        if json["castStartDateCode"].stringValue != "" {
            startDateCode = json["castStartDateCode"].stringValue
        }
        
        if json["castTotalminute"].stringValue != "" {
            totalMinute = json["castTotalminute"].stringValue
        }
        
        
        if json["vSignId"].stringValue != "" {
            signID = json["vSignId"].stringValue
        }
        
        if json["castTitle"].stringValue != "" {
            title = json["castTitle"].stringValue
        }
        else if json["vCastTitle"].stringValue != "" {
            title = json["vCastTitle"].stringValue
        }
        
        if json["vPartnerCode"].stringValue != "" {
            partnerCode = json["vPartnerCode"].stringValue
        }
        
        if json["category"].stringValue != "" {
            partnerCode = json["category"].stringValue
        }
        
        if json["vNickName"].stringValue != "" {
            nickname = json["vNickName"].stringValue
        }
        
        if json["vPfileName"].stringValue != "" {
            pFileName = json["vPfileName"].stringValue
        }
        
        if json["vodPath"].stringValue != "" {
            path = json["vodPath"].stringValue
        }
        
        if json["useCoinValue"].stringValue != "" {
            useCoinValue = json["useCoinValue"].stringValue
        }
        
        if json["vMemo"].stringValue != "" {
            memo = json["vMemo"].stringValue
        }

    }
}
