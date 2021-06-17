//
//  PopkonAir.swift
//  PopkonAir
//
//  Created by roy on 2016. 8. 14..
//  Copyright © 2016년 roy. All rights reserved.
//
import UIKit
import XCGLogger
import SDWebImage

//MARK: - global properties
let isTestMode              = false
let broadcastEnabled        = false
let coinName                = "LUV"
let guestWatchEnabled       = true
let adsEnabled              = true
let webLinkEnabled          = true
let screenRecordBlock       = true
let useBlockList            = false
let reconnectedPlayWhenSwitchApp = true
let pushEnabled             = true
let bioAuthEnabled          = false
let videoBitrateEnabled     = false
let enrollMembershipEnabled = true
let webRTCEnabled           = true

let useDevJsonDomain = false /// 해당값은 항상 false, 로컬 작업 필요시에만 true하여 연결하여 쓴다.
let developDomain = "http://devsys.popkontv.kr:9001/AS"
let stageDomain = "https://stagesys.popkontv.com:9002/AS"
let productDomain = "https://api.popkontv.kr:9002/AS"
let devJsonDomain = stageDomain


var defaultGridDisplayType = CastDisplayType.grid

//MARK: - Color

let mainColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) //FFCC00
let subColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
let statusBarBgColor = UIColor.white
let tabUnderBarColor = #colorLiteral(red: 0.3960784314, green: 0.2705882353, blue: 0.9019607843, alpha: 1)
let tabBarTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
let tabBarSelectedTintColor = #colorLiteral(red: 0.3960784314, green: 0.2705882353, blue: 0.9019607843, alpha: 1)
let tabBarUnselectedTintColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

let roundBorderColor = #colorLiteral(red: 0.3960784314, green: 0.2705882353, blue: 0.9019607843, alpha: 1)
let roundTextColor   = #colorLiteral(red: 0.3019607843, green: 0.2901960784, blue: 0.2901960784, alpha: 1)

let catergoryTextColor =  #colorLiteral(red: 0.3019607843, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
let catergorySelectedTextColor = #colorLiteral(red: 0.3019607843, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
let titleTextColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1) // #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

let textFieldLineNormalColor = #colorLiteral(red: 0.3019607843, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
let textFieldLineEditColor = #colorLiteral(red: 0.3960784314, green: 0.2705882353, blue: 0.9019607843, alpha: 1)
let textFieldTextColor = #colorLiteral(red: 0.3019607843, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
let baseBartextFieldTextColor = #colorLiteral(red: 0.3019607843, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
let textFieldHoldTextColor = #colorLiteral(red: 0.6157, green: 0.6784, blue: 0.6314, alpha: 1)

let infoTextColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
let infoColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) 

let popupMainColor = #colorLiteral(red: 0.3960784314, green: 0.2705882353, blue: 0.9019607843, alpha: 1)
let popupOkButtonColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
let launchBackColor = #colorLiteral(red: 0.3960784314, green: 0.2705882353, blue: 0.9019607843, alpha: 1)

//MARK: - ASP TabBar Color
//let tabBarTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//let tabBarUnselectedTintColor = #colorLiteral(red: 0.4156862745, green: 0.4196078431, blue: 0.4196078431, alpha: 1)
//let buttonBorderColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)

//MARK: - Log
let log = XCGLogger.default

//MARK: - Module
let appData : AppData = AppData.sharedInstance
let connection : ConnectionManager = ConnectionManager.manager
let userInfo   : UserInfoManager = UserInfoManager.manager
let popupManager : PopupManager = PopupManager.manager
let socketManager : SocketIOManager = SocketIOManager.sharedInstance
let fb : FirebaseManager = FirebaseManager.manager
let realmManager : DBManager = DBManager.manager

//MARK: - Dispatch
let dispatchMain = DispatchQueue.main
let dispatchGlobal = DispatchQueue.global()

//MARK: - AES
let aesAdapter = AESKeyAdapter.adapter
let verAES = "2"

//MARK: - Orientation
func currentOrientation() ->UIDeviceOrientation {
    return UIDevice.current.orientation
}

var appName: String {
    get {
        if let info = Bundle.main.infoDictionary,
            let displayName = info["CFBundleDisplayName"] as? String {
            return displayName
        }
        return "CeluvTV"
    }
}
var partnerCode: String {
    get {
        if let info = Bundle.main.infoDictionary,
            let aspInfo = info["ASPInfo"] as? [String: Any], let code = aspInfo["PartnerCode"] as? String {
            return code
        }
        return "P-00117"
    }
}

// API Server Domain
var serverDomain: String = "https://api.popkontv.kr:9002/AS"
