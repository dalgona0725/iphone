//
//  NSUserDefaults+Extensions.swift
//  PopkonAir
//
//  Created by roy on 2016. 8. 14..
//  Copyright © 2016년 roy. All rights reserved.
//

import Foundation

let NSUserDefaultAutoLogin = "NSUserDefaultAutoLogin"
let NSUserDefaultNoticeLTE = "NSUserDefaultNoticeLTE"
let NSUserDefaultSNSID = "NSUserDefaultSNSID"
let NSUserDefaultID = "NSUserDefaultID"
let NSUserDefaultPW = "NSUserDefaultPW"
let NSUserDefaultRemoteDeviceKey = "NSUserDefaultRemoteDeviceKey"
let NSUserDefaultFCMPushKey = "NSUserDefaultFCMPushKey"
let NSUserDefaultUUID = "NSUserDefaultUUID"
let NSUserDefaultStartAdTime = "NSUserDefaultStartAdTime"

let NSUserDefaultLockApp = "NSUserDefaultLockApp"
let NSUserDefaultAuthenResult = "NSUserDefaultAuthenResult"
let NSUserDefaultBioAutoLogin = "NSUserDefaultBioAutoLogin"

//let NSUserDefaultDidEnterBackground = "NSUserDefaultDidEnterBackground"
//let NSUserDefaultActiveFromBackground = "NSUserDefaultActiveFromBackground"

let NSUserDefaultTermAgreement = "NSUserDefaultTermAgreement"
let NSUserDefaultChatFontScale = "NSUserDefaultChatFontScale"

extension UserDefaults
{
    /// Login 유지 데이터 UserDefault 값
    /// 
    /// - returns: Login 유지값
    func isAutoLogin() -> Bool!
    {
        if self.object(forKey: NSUserDefaultAutoLogin) == nil
        {
            return false
        }
        else
        {
            return self.object(forKey: NSUserDefaultAutoLogin) as? Bool
        }
    }
    
    /// Login 유지 데이터 설정
    ///
    /// - parameter Login: 유지 설정값
    func AutoLogin(_ val: Bool)
    {
        self.set( val, forKey: NSUserDefaultAutoLogin)
        self.synchronize()
    }
    
    
    /// Login 유지 데이터 UserDefault 값
    ///
    /// - returns: Login 유지값
    func isBioAutoLogin() -> Bool!
    {
        if self.object(forKey: NSUserDefaultBioAutoLogin) == nil
        {
            return false
        }
        else
        {
            return self.object(forKey: NSUserDefaultBioAutoLogin) as? Bool
        }
    }
    
    /// Login 유지 데이터 설정
    ///
    /// - parameter Login: 유지 설정값
    func BioAutoLogin(_ val: Bool)
    {
        self.set( val, forKey: NSUserDefaultBioAutoLogin)
        self.synchronize()
    }
    
    /// 3G LTE 사용여부 UserDefault 값
    ///
    /// - returns: 3G LTE 사용여부
    func isNoticeUsingLTE() -> Bool!
    {
        if self.object(forKey: NSUserDefaultNoticeLTE) == nil
        {
            return true
        }
        else
        {
            return self.bool(forKey:NSUserDefaultNoticeLTE)
        }
    }
    
    /// 앱 잠금을 사용할지 값 여부
    ///
    /// - returns: 앱 잠금을 할지 여부
    func isLockApp() -> Bool!
    {
        if self.object(forKey: NSUserDefaultLockApp) == nil
        {
            return false
        }
        else
        {
            return self.bool(forKey:NSUserDefaultLockApp)
        }
    }
    
    func isAuthenFailed() -> Bool!
    {
        if self.object(forKey: NSUserDefaultAuthenResult) == nil
        {
            return false
        }
        else
        {
            return self.bool(forKey:NSUserDefaultAuthenResult)
        }
    }
    func setAuthenFailed(_ val: Bool)
    {
        self.set( val, forKey: NSUserDefaultAuthenResult)
        self.synchronize()
    }
    
    /// 현재 시작광고 플레이 가능한지 여부 값
    func canStartAds() -> Bool {
        if let lastTime = self.object(forKey: NSUserDefaultStartAdTime) as? Date {
            let diff = Date().timeIntervalSince(lastTime)
            if Int(diff) < 0 {
                return false
            }
        }
        return true
    }
    
    
    /// 시작 광고 다음 시작시간 설정
    ///
    /// - parameter 추가할 시간
    func setNextStartAds(addTime: Int) {
        let time = Date(timeIntervalSinceNow: TimeInterval(addTime))
        self.set(time, forKey: NSUserDefaultStartAdTime)
        self.synchronize()
    }
    
    /// 3G LTE 사용여부 설정 알림
    ///
    /// - parameter 3G LTE 사용여부 알림
    func setNoticeLTE(_ val: Bool)
    {
        self.set( val, forKey: NSUserDefaultNoticeLTE)
        self.synchronize()
    }
    
    func setTermAgreementID(_ val: String) {
        self.set( val, forKey: NSUserDefaultTermAgreement )
        self.synchronize()
    }
    func TermAgreementID() -> String? {
        return self.object(forKey: NSUserDefaultTermAgreement) as? String
    }

    
    /// 앱 잠금 설정
    ///
    /// - parameter 앱 잠금 값
    func setLockAPP(_ val: Bool)
    {
        self.set( val, forKey: NSUserDefaultLockApp)
        self.synchronize()
    }
    
    /// Login ID 데이터 UserDefault 값
    ///
    /// - returns: Login ID값
    func LoginID() -> String?
    {
        return self.object(forKey: NSUserDefaultID) as? String
    }
	
	/// SNS Login ID 데이터 UserDefault 값
	///
	/// - returns: Login snsID값
	func snsLoginID() -> String?
	{
		return self.object(forKey: NSUserDefaultSNSID) as? String
	}

    
    /// Login ID 데이터 설정
    ///
    /// - parameter Login: ID 설정값
    func setLoginID(_ val: String)
    {
        self.set( val, forKey: NSUserDefaultID)
        self.synchronize()
    }
	
	/// Login SNSID 데이터 설정
	///
	/// - parameter Login: SNSID 설정값
	func setSnsLoginID(_ val: String)
	{
		self.set( val, forKey: NSUserDefaultSNSID)
		self.synchronize()
	}
	
    /// Login PW 데이터 UserDefault 값
    ///
    /// - returns: Login PW값
    func LoginPW() -> String?
    {
        return self.object(forKey: NSUserDefaultPW) as? String
    }
    
    /// Login PW 데이터 설정
    ///
    /// - parameter Login: PW 설정값
    func setLoginPW(_ val: String)
    {
        self.set( val, forKey: NSUserDefaultPW)
        self.synchronize()
    }
    
    ///  APNS 디바이스 토큰키
    ///
    /// - returns: APNS 디바이스 토큰키
    func RemoteDeviceTokenKey() -> String?
    {
        return self.object(forKey: NSUserDefaultRemoteDeviceKey) as? String
    }
    
    /// APNS 디바이스 토큰키  데이터 설정
    ///
    /// - parameter: APNS 디바이스 토큰키
    func setRemoteDeviceTokenKey(_ key: String)
    {
        self.set(key, forKey: NSUserDefaultRemoteDeviceKey)
        self.synchronize()
    }
    
    
    /// FCM 푸쉬 Token 값
    ///
    /// - returns: FCM 푸쉬 Token 값
    func FCMPushKey() -> String?
    {
        return self.object(forKey: NSUserDefaultFCMPushKey) as? String
    }
    
    /// FCM 푸쉬 Token 데이터 설정
    ///
    /// - parameter: FCM 푸쉬 Token
    func setFCMPushKey(_ key: String)
    {
        self.set(key, forKey: NSUserDefaultFCMPushKey)
        self.synchronize()
    }
    
    func getUUID() -> String?
    {
        return self.object(forKey: NSUserDefaultUUID) as? String
    }
    
    /// Login 푸쉬 키 데이터 설정
    ///
    /// - parameter Login: 푸쉬 키
    func setUUID(_ uuid: String)
    {
        self.set(uuid, forKey: NSUserDefaultUUID)
        self.synchronize()
    }
    
    /// 모든 NSUserDefaults 값을 삭제한다
    func clearAllUserData()
    {
        for key in self.dictionaryRepresentation().keys
        {
            self.removeObject(forKey: key)
        }
        self.synchronize()
    }
    
    /// 유저 채팅 폰트 스케일 값
    func getUserFontScale() -> Double {
        var scale = self.double(forKey: NSUserDefaultChatFontScale)
        if scale == 0 {
            scale = 1
        }
        return scale
    }
    func setUserFondScale(_ scale: CGFloat)
    {
        self.set(scale, forKey: NSUserDefaultChatFontScale)
        self.synchronize()
    }
    
//    /// DidEnterBackground 여부 값
//    ///
//    /// - returns: DidEnterBackground 여부
//    func didEnterBackground() -> Bool!
//    {
//        if self.objectForKey(NSUserDefaultDidEnterBackground) == nil
//        {
//            return false
//        }
//        else
//        {
//            return self.objectForKey(NSUserDefaultDidEnterBackground) as! Bool
//        }
//    }
//    
//    /// DidEnterBackground 여부 값 설정
//    ///
//    /// - parameter: DidEnterBackground 여부 설정
//    func setDidEnterBackground(key: Bool)
//    {
//        self.setObject(key, forKey: NSUserDefaultDidEnterBackground)
//        self.synchronize()
//    }
//    
//    
//    /// BackgroundMode에서 Active 되었는지 여부 값
//    ///
//    /// - returns: BackgroundMode에서 Active 되었는지 여부
//    func isActiveFromBackground() -> Bool!
//    {
//        if self.objectForKey(NSUserDefaultActiveFromBackground) == nil
//        {
//            return false
//        }
//        else
//        {
//            return self.objectForKey(NSUserDefaultActiveFromBackground) as! Bool
//        }
//    }
//    
//    /// BackgroundMode에서 Active 되었는지 여부 값 설정
//    ///
//    /// - parameter: BackgroundMode에서 Active 되었는지 여부 설정
//    func setActiveFromBackground(key: Bool)
//    {
//        self.setObject(key, forKey: NSUserDefaultActiveFromBackground)
//        self.synchronize()
//    }
    
}
