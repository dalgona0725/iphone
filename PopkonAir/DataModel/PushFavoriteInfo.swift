//
//  PushFavoriteInfo.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 12. 29..
//  Copyright © 2017년 eugene. All rights reserved.
//

import UIKit
import SwiftyJSON

class PushFavoriteInfo: NSObject {
    
    /// 즐겨찾기 등록코드
    var pushCode : String           = ""
    
    /// 방송자 회원아이디
    var castSignId : String         = ""
    
    /// 방송자 파트너사 코드
    var castPartnerCode : String    = ""
    
    /// 방송자 닉네임
    var nickname    : String        = ""
    
    /// 방송자 프로필이미지 파일경로
    var pFileName   : String        = ""
    
    /// 푸시 알림여부
    var isPushOn    : Bool          = false
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        if json["regCode"].stringValue != "" {
            pushCode = json["regCode"].stringValue
        }
        
        if json["cSignId"].stringValue != "" {
            castSignId = json["cSignId"].stringValue
        }
        
        if json["cPartnerCode"].stringValue != "" {
            castPartnerCode = json["cPartnerCode"].stringValue
        }
        
        if json["cNickName"].stringValue != "" {
            nickname = json["cNickName"].stringValue
        }
        
        if json["cPfileName"].stringValue != "" {
            pFileName = json["cPfileName"].stringValue
        }

        if json["isOn"].stringValue != "" {
            isPushOn = json["isOn"].stringValue == "0" ? false : true
        }
        
    }
}
