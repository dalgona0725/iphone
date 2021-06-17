//
//  CastMemberInfo.swift
//  PopkonAir
//
//  Created by Steven on 13/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SwiftyJSON


//시청자 권한등급
enum CWAccountLevel : Int {
    ///일반 시청자
    case normal         = 0
    ///방송자 권한
    case caster         = 1
    ///매니저 권한
    case manager        = 2
    ///운영자 권한
    case operate        = 3
    ///관리자 권한
    case admin          = 4
}

///방송보는 고객정보
class CastMemberInfo: NSObject {
    
    var accountLevel        : CWAccountLevel    = .normal
    var fanLevel            : FanLevel          = .none
    var fanLevelName        : String            = ""
    var needCoin            : Int               = 0
    var coin                : Int               = 0
    var castAddress         : String            = ""    // 0:rtmpURL 1:streamName 2: chatURL
    var watchFanLevel       : FanLevel          = .none
    
    var castHLS : String {
        get {
            let castAddr = self.castAddress.split(separator: "|")
            if castAddr.count >= 2 {
                let hls = String(castAddr[0]).replacingOccurrences(of: "rtmp", with: "http")
                return (hls + "/" + String(castAddr[1]) + "/index.m3u8")
            }
            return ""
        }
    }
    
    var castURL : String {  // rtmpURL + streamName
        get {
            let castAddr = self.castAddress.split(separator: "|")
            if castAddr.count >= 2 {
                return (String(castAddr[0]) + "/" + String(castAddr[1]))
            }
            return ""
        }
    }
    
    var chatURL : String {
        get {
            let castAddr = self.castAddress.split(separator: "|")
            if castAddr.count >= 3 {
                return String(castAddr[2])
            }
            return ""
        }
    }
    
    var castChannel : String {
        get {
            let castAddr = self.castAddress.split(separator: "|")
            return String(castAddr[0])
        }
    }
    
    /// WOWZA 연결정보
    /// ex) "rtmp://114.31.50.98/pop_cast|G3271153629703191129_P-00117_20191214160800"
    /// 호스트어드레스     114.31.50.98
    /// 애플리케이션 이름   pop_cast?AMDMASFMDSAMFASMEMMSDFMASEMFEMFMASDMFDSF
    /// 스트림 이름       G3271153629703191129_P-00117_20191214160800
    /// 호스트 어드레스
    var wzHostAddress : String? {
        get {
            let reducedComponents = self.castAddress.replacingOccurrences(of: "rtmp://", with: "").components(separatedBy: "/")
            if reducedComponents.isEmpty {
                return nil
            } else {
                return reducedComponents.first
            }
        }
    }
    /// 애플리케이션 이름 (원타임 암호키값도 포함된다)
    var wzApplicationName: String? {
        get {
            let reducedComponents = self.castAddress.replacingOccurrences(of: "rtmp://", with: "").components(separatedBy: "/")
            if reducedComponents.count > 1 {
                let subComponents = reducedComponents[1].components(separatedBy: "|")
                if subComponents.count > 1 {
                    return subComponents.first
                }
            }
            return nil
        }
    }
    /// 스트림명칭
    var wzStreamName: String? {
        get {
            let reducedComponents = self.castAddress.components(separatedBy: "|")
            if reducedComponents.count > 2 {
                return reducedComponents[1]
            }
            return nil
        }
    }
    /// 원타임 암호키값
    var wzCrytoQuery: String? {
       get {
            let reducedComponents = self.castAddress.replacingOccurrences(of: "rtmp://", with: "").components(separatedBy: "/")
            if reducedComponents.count > 1 {
                let subComponents = reducedComponents[1].components(separatedBy: "|")
                if subComponents.count > 1 {
                    if let urltext = subComponents.first {
                        let querys = urltext.components(separatedBy: "?")
                        if querys.count > 1 {
                            return querys.last
                        }
                    }
                }
            }
            return nil
        }
    }
    
    var wzCastHLS : String? {
        get {
            let reducedComponents = self.castAddress.replacingOccurrences(of: "rtmp://", with: "").components(separatedBy: "/")
            if reducedComponents.count > 1 {
                let subComponents = reducedComponents[1].components(separatedBy: "|")
                if subComponents.count > 1 {
                    if let urltext = subComponents.first {
                        let querys = urltext.components(separatedBy: "?")
                        if querys.count > 1 {
                            return "http://\(subComponents[0])/\(querys.first!)/\(wzStreamName!)/index.m3u8?\(wzCrytoQuery!)"
                        } else {
                            return "http://\(subComponents[0])/\(querys.first!)/\(wzStreamName!)/index.m3u8?"
                        }
                    }
                }
            }
            return nil
        }
    }
    
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        accountLevel            = CWAccountLevel(rawValue: json[cwAccountLevelKey].intValue) ?? .normal
        fanLevel                = FanLevel(rawValue: json[cwFanLevelKey].intValue) ?? .none
        fanLevelName            = json[cwFanLevelNameKey].stringValue
        needCoin                = json[cwNeedCoinKey].intValue
        coin                    = json[cwCoinKey].intValue
        castAddress             = json[cwCastAddressKey].stringValue
        watchFanLevel           = FanLevel(rawValue: json[cwWatchFanLevelKey].intValue) ?? .none
    }
    
    func isManager() -> Bool {
        return accountLevel == .manager
    }
    
    func isCaster() -> Bool {
        return accountLevel == .caster
    }
}
