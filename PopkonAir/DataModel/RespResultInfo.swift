//
//  RespResultInfo.swift
//  PopkonAir
//
//  Created by Steven on 13/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SwiftyJSON

enum ResultCode : String {
    ///성공
    case succeed        =  "0"
    ///실패
    case failed         =  "1"
    ///매니저 추가 아이템 사용 가능
    case enableManagerItem = "2"
    ////이미 종료됨
    case closed         =  "3"
    ///서비스점검
    case maintenance    =  "E"
    ///휴대폰 본인인증 필요
    case authorize      =  "A"
    ///프로그램 업데이트 필요
    case needUpdate     =  "V"
    ///팬가입 코인 필요
    case needFanCoin    =  "A1"
    ///풀방입장권 필요
    case needFullTicket =  "A2"
    ///유료시청 코인 필요
    case needPayCoin    =  "A3"
    ///시스템처리 메세지
    case system         =  "SP"
    // 회원정보 불일치(로그아웃 처리)
    case mismatched     =  "L"
	///SNS 신규 가입 처리 필요
	case needJoinSNS    = "N"
	

}

class RespResultInfo: NSObject {
    ///결과코드
    var result : ResultCode = ResultCode.failed
    ///결과메세지
    var message : String = ""
    ///목록 페이지 번호
    var pageNum : Int = 0
    ///총 목록페이지 수
    var totalPageNum : Int = 0
    ///총 리스트수
    var totalListNum : Int = 0
    ///필요코인 개수
    var needCoin     : Int = 0
	/// SNS 로그인 ID
	var signId = ""
	/// SNS 로그인 PWD
	var signPwd = ""
    
    open func setInfo(json : JSON) {
        log.debug(json)
        
        result          = ResultCode(rawValue: json[rstCodeKey].stringValue) ?? .failed
        message         = json[rstMsgKey].stringValue
        pageNum         = json[pageNumKey].intValue
        totalPageNum    = json[totalPageNumKey].intValue
        totalListNum    = json[totalListNumKey].intValue
        needCoin        = json[rstNeedCoinKey].intValue
		signId			= json[rstSignID].stringValue
		signPwd			= json[rstSignPwd].stringValue
    }
}
