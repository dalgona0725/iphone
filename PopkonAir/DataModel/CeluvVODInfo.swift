//
//  CeluvVODInfo.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 27/08/2019.
//  Copyright © 2019 The E&M. All rights reserved.
//

import UIKit
import SwiftyJSON

struct CeluvVODInfo: Codable {

    /// VOD 코드
    var vodCode         : String?
    
    /// VOD 사용자 게시일자코드 (YYYYmmDDhhNNss)
    var vSetDate        : String?
    
    /// VOD 누적 시청수
    var viewCnt        : String?

    /// 원작자/게시자
    var vodOwner         : String?
    
    /// 방송제목
    var vodTitle      : String?
    
    /// 방송자 파트너사 코드
    var vPartnerCode    : String?
    
    /// 방송자 회원 닉네임
    var vNickName       : String?
    
    /// 방송자 프로필 이미지 파일 경로 
    var vodThumnail      : String?
    
    /// VOD경로
    var vodPath         : String?

    
    init() {
    }
    
    init(cast : CastInfo) {
        self.vodTitle = cast.castTitle
        self.vPartnerCode = cast.castPartnerCode
        self.vodThumnail = cast.thumbFileName
        self.viewCnt = "\(cast.watchCnt)"
        
        self.vodOwner = cast.nickName
        self.vodCode = cast.castCode
        self.vodPath = cast.castPath
		self.vSetDate = cast.vSetDate
    }
    
}


