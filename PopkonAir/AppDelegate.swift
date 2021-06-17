//
//  AppDelegate.swift
//  PopkonAir
//
//  Created by roy on 2016. 8. 14..
//  Copyright © 2016년 roy. All rights reserved.
//

import UIKit
import AVFoundation
import UserNotifications
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import KakaoSDKAuth
import NaverThirdPartyLogin


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var onPushRegister : ((Bool) -> Void)? = nil
    
    let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        application.isStatusBarHidden = true

        setServerDomainURL()
        #if compiler(>=5.1)
        if #available(iOS 13.0, *) {
            window?.overrideUserInterfaceStyle = .light
        }
        #endif // compiler>=5.1
        


        let filemgr = FileManager.default
        let documentURL = filemgr.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let logPath = documentURL.appendingPathComponent("Log.txt")
        
        //Logger Setup
        log.setup(level: .debug,
                  showThreadName: true,
                  showLevel: true,
                  showFileNames: true,
                  showLineNumbers: true,
                  writeToFile: logPath,
                  fileLevel: .debug)
        
        do {
            try AVAudioSession.sharedInstance().setPreferredSampleRate(44_100)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
            try AVAudioSession.sharedInstance().setMode(AVAudioSession.Mode.default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
        }
        
        if bioAuthEnabled == false {
            appData.isLockApp = false
        }
        
        appData.isAuthenFailed = false
        
        registerForPushNotifications()
        
        HTTPCookieStorage.shared.cookieAcceptPolicy = HTTPCookie.AcceptPolicy.always
        
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        fb.setupRemoteConfig()
		
		ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
//		LineSDK.LoginManager.shared.setup(channelID: lineChannelID, universalLinkURL: nil)
        
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
      
        if appData.isAuthenFailed {
            return
        }
        userInfo.checkAppLock {
            log.debug("check app Lock....")
        }
      
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
		AppEvents.activateApp()
    }

    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return .all
    }
    
    //MARK: - 푸시알림 Register 및 실패.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        // 푸쉬 디바이스 토큰 저장.
        /*
         let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
         // Print it to console
         print("APNs device token: \(deviceTokenString)") */
        //log.debug("[PUSH] didRegisterForRemoteNotificationsWithDeviceToken")
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        let token = tokenParts.joined()
        //print("Device token: \(token)")
        userInfo.remoteDeviceToken = token
        
        if let completeHandler = onPushRegister {
            completeHandler(true)
            onPushRegister = nil
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        //log.debug("[PUSH] Failed to register: \(error)")
        if let completeHandler = onPushRegister {
            completeHandler(false)
            onPushRegister = nil
        }
    }
    
    private func setServerDomainURL() {
        if useDevJsonDomain {
            serverDomain = devJsonDomain
            return
        }
        
        if let info = Bundle.main.infoDictionary,
           let aspInfo = info["ASPInfo"] as? [String: Any], let serverURL = aspInfo["ServerURL"] as? String {
            serverDomain = serverURL
            return
        }
    }
    
    /*
     func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
     
     popupManager.defaultAlert(title: "", subject: "fetchCompletionHandler 버젼입니다.", btn1Title: "확인", btn2title: "")
     
     log.debug("[PUSH] didReceiveRemoteNotification userInfo _ fetchCompletionHandler  ")
     /*let aps = userInfo["aps"] as! [String: AnyObject]
     if aps["content-available"] as? Int == 1 {
     // 2. Refresh PodCast
     //completionHandler(didLoadNewItems ? .newData : .noData)
     } else {
     completionHandler(.newData)
     } */
     
     //let userInfo = userInfo["aps"] as! [String: AnyObject]
     if let pushData = userInfo["aps"] as? [String: AnyObject] {
     if let payload = pushData["payload"] as? [String: AnyObject] {
     self.processPushPayload(payload: payload)
     }
     }
     completionHandler(.newData)
     }*/
    
    //MARK : - Remote Notification Delegate <= iOS 9.x
    // iOS 9.0 이하 delegate 처리
    // 푸시데이터가 들어오오는 함수
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        log.debug("[PUSH] didReceiveRemoteNotification - ignore current push data. it'll process by another way ")
    }
    
    // iOS 7.0 이후 앱이 실행 중이었는지 아니면 백그라운드 모드였는지를 확인
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        switch UIApplication.shared.applicationState {
        case .active:
            fallthrough
        case .inactive:
            fallthrough
        case .background:
            log.debug("state: \(UIApplication.shared.applicationState)")
        @unknown default:
            log.debug("fatal Error - didReceiveRemoteNotification ")
        }
        
        if let messageID = userInfo[gcmMessageIDKey] {
            log.debug("Message ID (\(messageID))")
        }
        log.debug(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    /// APNS에 원격알림 디바이스 등록
    /// - Note: iOS 10.0 이상일 경우 시스템 알림권한 여부에 따라 원격알림 등록 처리
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            log.debug("[PUSH] ermission granted: \(granted)")
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    /// 알림 권한 설정 체크후 APNS 원격알림 등록
    /// - Note: iOS 10.0 이상일 경우 시스템 알림권한 여부에 따라 원격알림 등록 처리
    @available(iOS 10.0, *)
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            log.debug("[PUSH] Notification settings: \(settings)")
            DispatchQueue.main.async { // Correct
                guard settings.authorizationStatus == .authorized else { return }
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func verifyURL(urlString : String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    /// 푸시 Notification Payload 데이터 처리
    /// - Note: Payload type에따른 이벤트 처리
    /// - Parameters:
    ///     - payload: Push 페이로드 데이타
    func processPushPayload(payload :  [String: AnyObject]) {
        log.debug("[PUSH] processPushPayload")
        if let notiType = payload[PushContentKey.MessageType.rawValue] as? String {
            guard let type = Int(notiType) else {
                return
            }
            
            var message = payload[PushContentKey.Message.rawValue] as? String
            if message == nil {
                message = ""
            }
            
            switch type {
            case 0: //   일반
                //NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPushNormalMessage), object:nil)
                fallthrough
            case 2: //  방송자 알림
                // =>  방송보기
                guard let SignID = payload[PushContentKey.SignID.rawValue] as? String else {
                    log.debug("[Push] CastID is Null")
                    return
                }
                guard let PartnerCode = payload[PushContentKey.PartnerCode.rawValue] as? String else {
                    log.debug("[Push] CastPartnerCode is Null")
                    return
                }
                
                // 방송 시청 예약
                // Sending Request WatchCast
                if SignID.isEmpty == false && PartnerCode.isEmpty == false {                    
                    appData.pushDataInfo = PushInfo(castSignID: SignID, castPartnerCode: PartnerCode, webLinkUrl: "") // message: message!)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPushBroadStart), object:nil, userInfo: payload)
                }
            case 1: //  이벤트 알림 (내부링크)
                // => 이벤트 웹뷰
                guard let linkURL = payload[PushContentKey.URL.rawValue] as? String else {
                    log.debug("[Push] WebURL is Null")
                    return
                }
                // Sending Request OpenEventWebView
                if verifyURL(urlString: linkURL ) {
                    appData.pushDataInfo = PushInfo(castSignID: "", castPartnerCode: "", webLinkUrl: linkURL) //, message: message!)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPushShowEventView), object:nil, userInfo: payload)
                }
            case 3: //  이벤트 알림 (외부링크)
                guard let linkURL = payload[PushContentKey.URL.rawValue] as? String else {
                    log.debug("[Push] External Link URL is Null")
                    return
                }
                
                if let encoded  = linkURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let encodedURL = URL(string: encoded){
                    //appData.pushDataInfo = PushInfo(castSignID: "", castPartnerCode: "", webLinkUrl: linkURL, message: message!)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kPushLinkOut), object:nil, userInfo: payload)
                    
                    UIApplication.shared.open(encodedURL)
                }
                            
            default :
                break
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        log.debug("[TEST] URL : \(url.absoluteString)")
//        let queryItems = URLComponents(string: url.absoluteString)?.queryItems
//        if let pathParam = queryItems?.filter({$0.name == "linkPath"}).first {
//            jsonDomain = param1.value
//        }
		
		if userInfo.snsCode == .kakao {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                return AuthController.handleOpenUrl(url: url)
            }
			return true
		}
		
		if userInfo.snsCode == .facebook {
            return  ApplicationDelegate.shared.application(
                app,
                open: url,
                sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                annotation: options[UIApplication.OpenURLOptionsKey.annotation]
            )
		}
		
		if userInfo.snsCode == .google {
			return GIDSignIn.sharedInstance().handle(url)
		}

//		if userInfo.snsCode == .line {
//			return LoginManager.shared.application(app, open: url)
//		}
		
		if userInfo.snsCode == .naver {
			let resultType = NaverThirdPartyLoginConnection.getSharedInstance().receiveAccessToken(url)
			
			if resultType == SUCCESS {
				return true
			} else {
				return false
			}
		}
		
        return true
    }

}

//MARK: - Notification Delegate iOS 10.0 message handling.
@available(iOS 10.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 앱이 실행되고 있을 때 푸시 데이터 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
//        let userInfo = notification.request.content.userInfo
//        if let messageID = userInfo[gcmMessageIDKey] {
//            log.debug("Message ID (\(messageID))")
//        }
        completionHandler(.alert) // [.alert, .sound]
    }
    
    // 앱이 백그라운드나 종료상태에서 푸시 알람 누를시 데이터 처리
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
//        if let messageID = userInfo[gcmMessageIDKey] {
//            log.debug("Message ID (\(messageID))")
//        }
//        log.debug(userInfo)
        if let apsPayload = userInfo["aps"] as? [String: AnyObject] {
            log.debug(apsPayload.debugDescription)
            self.processPushPayload(payload: apsPayload)
        }
        completionHandler()
    }
}


//MARK: - FCM MessaginDelegate.
extension AppDelegate: MessagingDelegate {
    // start refresh_token
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        //log.debug("FCM registration token: \(fcmToken)")
        userInfo.fcmPushToken = fcmToken ?? ""
    }
    
}
