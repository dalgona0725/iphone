//
//  BCPrepareInfo.swift
//  PopkonAir
//
//  Created by Steven on 07/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SwiftyJSON

class BCPrepareInfo: NSObject {
    ///방송제목
    var title       : String {
        get {
            if let string = UserDefaults.standard.string(forKey: "BCPrepareInfo_Title") {
                return string
            }else {
                return ""
            }
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "BCPrepareInfo_Title")
            UserDefaults.standard.synchronize()
        }
    }
    ///비밀번호
    var password    : String {
        get {
            if let string = UserDefaults.standard.string(forKey: "BCPrepareInfo_Password") {
                return string
            }else {
                return ""
            }
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "BCPrepareInfo_Password")
            UserDefaults.standard.synchronize()
        }
    }
    ///방송형태
    var broadType   : BCType = .freeBroad01
    ///유료방 입장코인
    var entryCoin   : Int {
        get {
            let count = UserDefaults.standard.integer(forKey: "BCPrepareInfo_EntryCoin")
            if count == 0 {
                return 0
            }
            return count
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "BCPrepareInfo_EntryCoin")
            UserDefaults.standard.synchronize()
        }
    }
    ///팬방 입장 팹등급
    var fanLevel    : FanLevel = .none
    ///방송주제 분류
    var category    : String = ""
    ///방송화질
    var quality     : BCQuality  {
        get {
            return BCQuality(rawValue: UserDefaults.standard.integer(forKey: "BCPrepareInfo_Quality")) ?? .high
        }
        set(newValue) {
            UserDefaults.standard.set(newValue.rawValue, forKey: "BCPrepareInfo_Quality")
            UserDefaults.standard.synchronize()
        }
    }

    ///방송 영상비트레이트
    var videoBitrate : Int = BCQuality.high.getBitrates().first ?? 0
    
    ///리스트업 아이템
    var listupItem  : BCListNum = .normal
    
    ///방송모드
    var castMode    : BCCastType = .wowza
    
    ///방송송출모드
    var castTarget  : BCTarget = .all
    
    ///최대 시청인원 제한수
    var maxViewrCnt : Int = 1000
    ///시청인원
    var viewerCnt   : Int {
        get {
            let count = UserDefaults.standard.integer(forKey: "BCPrepareInfo_ViewerCnt")
            if count == 0 {
                return 1000
            }
            return count
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "BCPrepareInfo_ViewerCnt")
            UserDefaults.standard.synchronize()
        }
    }
    ///19세 방송
    var isAdult     : Bool {
        get {
            let result = UserDefaults.standard.bool(forKey: "BCPrepareInfo_IsAdult")
            return result
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "BCPrepareInfo_IsAdult")
            UserDefaults.standard.synchronize()
        }
    }
    
    var castCode : String = ""
    var live_cast : String = ""  //
    var live_watch : String = ""
    var live_channel : String = ""
    
    /// WOWZA 연결정보
    /// ex) "rtmp://114.31.50.98/pop_cast|G3271153629703191129_P-00117_20191214160800"
    /// 호스트어드레스     114.31.50.98
    /// 애플리케이션 이름   pop_cast
    /// 스트림 이름       G3271153629703191129_P-00117_20191214160800
    var wzHostAddress : String? {
        get {
            let reducedComponents = self.live_cast.replacingOccurrences(of: "rtmp://", with: "").components(separatedBy: "/")
            if reducedComponents.isEmpty {
                return nil
            } else {
                return reducedComponents.first
            }
        }
    }
    var wzApplicationName: String? {
        get {
            let reducedComponents = self.live_cast.replacingOccurrences(of: "rtmp://", with: "").components(separatedBy: "/")
            if reducedComponents.count > 1 {
                let subComponents = reducedComponents[1].components(separatedBy: "|")
                if subComponents.count > 1 {
                    return subComponents.first
                }
            }
            return nil
        }
    }
    var wzStreamName: String? {
        get {
            let reducedComponents = self.live_cast.replacingOccurrences(of: "rtmp://", with: "").components(separatedBy: "/")
            if reducedComponents.count > 1 {
                let subComponents = reducedComponents[1].components(separatedBy: "|")
                if subComponents.count > 1 {
                    return subComponents.last
                }
            }
            return nil
        }
    }
    
    ///방송공지
    var castNotice    : String {
        get {
            if let string = UserDefaults.standard.string(forKey: "BCPrepareInfo_castNotice") {
                return string
            }else {
                return ""
            }
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: "BCPrepareInfo_castNotice")
            UserDefaults.standard.synchronize()
        }
    }
    
    ///방송 촬영타입
    var castOrientation : BCOrientation {
        get {
            let intValue = UserDefaults.standard.integer(forKey: "BCPrepareInfo_castOrientation")
            return BCOrientation(rawValue: intValue) ?? .portrait
        }
        set {
            UserDefaults.standard.set(newValue.rawValue, forKey: "BCPrepareInfo_castOrientation")
            UserDefaults.standard.synchronize()
        }
    }
    
    let minimumViewerNum = 10
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        title = json["castTitle"].stringValue
        maxViewrCnt = json["maxWatchCnt"].intValue
        viewerCnt = json["limitNumber"].intValue
        category = json["category"].stringValue
        
        isAdult = false
        broadType = .freeBroad01
        
        // isAdult = (json["isAdult"].stringValue == "1")
        // broadType = BCType(rawValue: json["castType"].intValue ) ?? .freeBroad01
        // entryCoin = json["tiketCoin"].stringValue
        // fanLevel = FanLevel(rawValue: json["fanLevel"].intValue) ?? .none
        
        // 시청자수 증가아이템 효과가 사라질시 현재 설정된 시청자수가 더 많을 경우 변경처리
        if viewerCnt > maxViewrCnt {
            viewerCnt = maxViewrCnt
        }
        
        // 시청자수가 최소값보다 작을시 최소값으로 수정
        if viewerCnt < minimumViewerNum {
            viewerCnt = minimumViewerNum
        }
    }
    
}


