//
//  CastInfo.swift
//  PopkonAir
//
//  Created by Steven on 12/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SwiftyJSON

enum CastListNum : Int {
    ///방송목록 일반 정렬
    case normal = 0
    ///방송목록 우선 정렬 (일반 리스트업 아이템)
    case bronze = 1
    ///방송목록 실버 정렬 (실버 리스트업 아이템)
    case silver = 2
    ///방송목록 골드 정렬 (실버 리스트업 아이템)
    case gold   = 3
    ///방송목록 최상단 특별방송
    case special = 4
}

enum CastType : Int {
    
    ///라이브 방송 ( 1:N )
    case live = 0
    ///일대일방송(1:1)
    case oneToOne = 1
    ///미사용
    case notUse = 2
    ///3자방송 (3:N)
    case three = 3
    ///녹화방송(1:N)
    case vod = 4
    ///팬클럽 방송 ( 1:N )
    case fanClub = 5
    ///라이브 방송 ( 1:N )
    case live2 = 6
    ///유료방송 (1:N)
    case pay = 7
    ///VR (1:N)
    case vr = 8
}

enum CastStatus : Int {
    ///방송없음
    case off            = -1
    ///방송진행중
    case playing        = 0
    ///방송 일시정지중
    case paused         = 1
    ///일대일방송 대기중
    case waitOneToOne   = 2
}

enum ChatType : String {
    ///None
    case none  = " "
    ///wowza 채팅 시스템
    case wowza  = "A"
    ///nodeJS 채팅 시스템
    case nodeJs = "B"
}

enum DecorateType : Int{
    case none  = 0
    case pink  = 1
    case green = 2
    case blue  = 3
    
    func gridDecoImage() -> UIImage? {
        switch self {
        case .none:
            return nil
        case .pink:
            return #imageLiteral(resourceName: "img_pattern_main_1")
        case .green:
            return #imageLiteral(resourceName: "img_pattern_main_2")
        case .blue:
            return #imageLiteral(resourceName: "img_pattern_main_3")
        }
    }
    
    func listDecoImage() -> UIImage? {
        switch self {
        case .none:
            return nil
        case .pink:
            return #imageLiteral(resourceName: "img_pattern_1")
        case .green:
            return #imageLiteral(resourceName: "img_pattern_2")
        case .blue:
            return #imageLiteral(resourceName: "img_pattern_3")
        }
    }
}

class CastInfo: NSObject {
    
    ///방송코드
    var castCode            : String    = ""
    
    ///방송자 아이디
    var castSignId          : String    = ""
    
    ///시청수
    var watchCnt            : Int       = 0
    
    ///방송상태 (참조)
    var castStatus          : CastStatus = .playing
    
    ///방송제목
    var castTitle           : String    = ""
    
    ///방송 비공개여부 (0: 공개방송, 1: 비공개방송)
    var isPrivate           : Bool      = false
    
    ///시청제한 인원수
    var limitNumber         : Int    = 0
    
    ///방송카테고리 (참조)
    var categoryCode        : String    = ""
    
    ///방송경로 (참조)
    var castPath            : String    = ""
    
    ///방송자 파트너 코드
    var castPartnerCode     : String    = ""
    
    ///방송형태 (참조)
    var castType            : CastType  = .live
    
    ///방송 종량과금 시간 (단위:초)
    var accountSecond       : String    = ""
    
    ///방송 종량과금 코인값
    var timeCoin            : String    = ""
    
    ///유료방송 입장 코인값
    var ticketCoin          : String    = ""
    
    ///방송자 닉네임
    var nickName            : String    = ""
    
    ///방송자 프로필이미지
    var pFileName           : String    = ""
    
    ///방송자 OS정보
    var castOS              : String    = ""
    
    ///채팅서비스 형식 (참조)
    var chatType            : ChatType  = .wowza
    
    ///방송 시작 시간코드
    var castStartDate       : String    = ""
    
    ///성인방송여부 (참조)
    var isAdult             : Bool      = false
    
    ///방송자대상 팬등급
    var fanLevel            : FanLevel    = .none
    
    var castListNum         : CastListNum    = .normal

    var mFileName           : String    = ""
    
    var ch_title            : String    = ""
    
    var ch_mcName           : String    = ""
    
    var ch_Contents         : String    = ""
    
    var ch_time             : String    = ""
    
    var ch_week             : String    = ""
    
    /// 방송 비밀번호
    var castPassword        : String    = ""
    
    ///리스트꾸미기 타입
    var decorateType      : DecorateType = .none
    
    /// 방송 기념일 이미지
    var anniversaryImgFile : String     = ""
	
	/// 썸네일
	var thumbFileName = ""
	
	/// VOD 사용자 게시일자코드 (YYYYmmDDhhNNss)
	var vSetDate = ""
    
    /// 방송자 레벨
    var levelMC             : Int       = 0
    
    /// 마지막 방송일시코드
    var castLastDate        : String    = ""
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        castCode        = json[castCodeKey].stringValue
        castSignId      = json[castSignIdKey].stringValue
        watchCnt        = json[watchCntKey].intValue
        if json[castStatusKey].stringValue == "" {
            castStatus = .off
        }else {
            castStatus      = CastStatus(rawValue: json[castStatusKey].intValue) ?? .off
        }
        
        castTitle       = json[castTitleKey].stringValue
        isPrivate       = (json[isPrivateKey].stringValue == "1")
        limitNumber     = json[limitNumberKey].intValue
        categoryCode    = json[categoryKey].stringValue
        castPath        = json[castPathKey].stringValue
        castPartnerCode = json[castPartnerCodeKey].stringValue
        castType        = CastType(rawValue: json[castTypeKey].intValue)!
        accountSecond   = json[accountSecondKey].stringValue
        timeCoin        = json[timeCoinKey].stringValue
        ticketCoin      = json[ticketCoinKey].stringValue
        nickName        = json[nickNameKey].stringValue
        pFileName       = json[pFileNameKey].stringValue
        castOS          = json[castOSKey].stringValue
        castStartDate   = json[castStartDateKey].stringValue.replacingOccurrences(of: " ", with: "")
        isAdult         = (json[isAdultKey].stringValue == "1")
        mFileName       = json[mFileNameKey].stringValue
        ch_title        = json["ch_title"].stringValue
        ch_mcName       = json["ch_mcName"].stringValue
        ch_Contents     = json["ch_Contents"].stringValue
        ch_time         = json["ch_time"].stringValue
        ch_week         = json["ch_week"].stringValue
		thumbFileName	= json["thumbFileName"].stringValue
		vSetDate		= json["vSetDate"].stringValue
        castLastDate    = json["castLastDate"].stringValue
        
        anniversaryImgFile = json[anniversaryImgKey].stringValue
        
        let deco = json[listDecoKey].intValue
        decorateType = DecorateType(rawValue: deco) ?? .none

        if json[chatTypeKey].stringValue.replacingOccurrences(of: " ", with: "") != "" {
            chatType = ChatType(rawValue: json[chatTypeKey].stringValue) ?? .none
        }else {
            chatType = .none
        }
        
        if json[fanLevelkey].stringValue.replacingOccurrences(of: " ", with: "") != "" {
            fanLevel = FanLevel(rawValue: json[fanLevelkey].intValue) ?? .none
        }else {
            fanLevel = .none
        }
        
        if json[castListNumKey].stringValue.replacingOccurrences(of: " ", with: "") != "" {
            castListNum = CastListNum(rawValue: json[castListNumKey].intValue) ?? .normal
        }else {
            castListNum = .normal
        }
                
        levelMC     = json[lvCastLvKey].intValue
    }
    
    var isCommerce: Bool {
        return categoryCode == cmeCategoryCommerce
    }

}
