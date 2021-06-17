
//
//  PopupManager.swift
//  PopkonAir
//
//  Created by Steven on 21/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import ReachabilitySwift

/* 사용하지 않음
let loginPolicyContent = "\(appName) 청소년보호정책\n\n\(appName)는 청소년들이 유해 정보에 접근할 수 없도록 방지하는 인증 장치 및 관리 조치를 취하고 있으며, 청소년이 건전한 인격체로 성장할 수 있도록 청소년 보호 정책 수립 및 시행에 최선을 다하고 있습니다.\n\n1.\(appName)는 만 19세 이상의 성인만 방송이 가능합니다.\n\n2.\(appName)는 아주 작은 욕설이나 음주 흡연도 성인 컨텐츠로 분류되어 청소년의 접근을 차단합니다.\n\n3.\(appName)의 모든 회원은 본인 인증된 회원이며 청소년의 경우 성인컨텐츠를 엄격하게 차단하여 절대 접근을 할 수 없습니다.\n\n4.\(appName)는 방송통신심의위원회의 '원스트라이크아웃제도'를 시행 및 준수하고 있으며 청소년의 불법유해정보 유통 근절을 위하여 24시간 실시간 모니터링을 진행하고 있습니다."

let broadcastPolicyContent = "\(appName) 준수사항\n\n아래 내용의 방송을 하지 않겠습니다.\n\n● 저작권 침해\n● 저속/음란한 방송\n● 사생활, 초상권 침해\n● 욕설/언어폭력\n● 19세 이상 제한 없이 사행성,음주,흡연장면\n● 19세 이상 제한 없이 잔인,폭력적인 장면\n● 공공질서 및 미풍양속에 위배되는 방송\n\n위 내용의 방송이 신고,적발될 경우\n서비스 이용에 제한을 받을 수 있으며,\n이용정지 및 선물받은 \(coinName)이 취소될 수 있습니다.\n또한, 제재조치와는 별도로 관련법에 의거형사처벌 받거나 손해배상청구를 당할 수 있습니다.\n본 방송에 출현하는 자들에 대하여 해당 방송자가 사전 동의를\n받았음을 전제로 하는바, 만약 동의를 하지 않는 경우에는\n지체 없이 이를 회사에 알려주시기 바랍니다.\n동의시 일주일간 알리지 않습니다."
*/

class PopupManager: NSObject {
    
    //MARK: - Public Params
    
    var blurView : BlurView = BlurView.standard()
    let loadingView : LoadingView = LoadingView.instanceFromNib()
    
    var popups : [PopupView] = []
    
    var loadingCount = 0
    
    var currentViewController : UIViewController?
    
    static let manager = PopupManager()
    
    //MARK: - Alert popup
    
    ///Return AlertPopupView
    func alertView(with title:String) ->AlertPopupView {
        
        let alert : AlertPopupView = AlertPopupView.instanceFromNib()
        
        alert.setup(content: title, buttonTitles: [])
        
        return alert
    }
    
    ///Return NoticePopupView
    func noticeView(with title:String) ->NoticePopupView {
        
        let alert : NoticePopupView = NoticePopupView.instanceFromNib()
        
        alert.setup(content: title)
        
        return alert
    }
    
    /*
    ///Return ChkAlertView
    func chkAlertView(content: String, chkTitle:String) -> ChkAlertPopupView {
        let alert : ChkAlertPopupView = ChkAlertPopupView.instanceFromNib()
        
        alert.setup(content: content, chkTitle: chkTitle, buttonTitles: ["확인"])
        
        return alert
    }
    
    ///Return ChkAlertView
    func longTextPopup(content: String, chkTitle:String = "" , buttonTitles: [String] = ["확인","취소"]) -> LongTextPoupView {
        let alert : LongTextPoupView = LongTextPoupView.instanceFromNib()
        
        alert.setup(content: content, chkTitle : chkTitle, buttonTitles: buttonTitles)
        
        return alert
    } */
    
    ///Return ChkAlertView
    func threeBtnInputPopupView(content: String, buttonTitles:[String]) -> ThreeBtnInputPopupView {
        let alert : ThreeBtnInputPopupView = ThreeBtnInputPopupView.instanceFromNib()
        
        alert.setup(content: content, buttonTitles: buttonTitles)
        
        return alert
    }
    
    ///Return multiButtonPoupView
    func multiButtonPoupView(title: String) -> MultiButtonPopupView {
        let alert : MultiButtonPopupView = MultiButtonPopupView.instanceFromNib()
        
        alert.titleLabel.text = title
        
        return alert
    }
    
    func policyPopupView() -> PolicyPopupView {
        let alert : PolicyPopupView = PolicyPopupView.instanceFromNib()
        
        alert.setup()
        
        return alert
    }
    
    func singlePolicyPopupView() -> SinglePolicyPopupView {
        let alert : SinglePolicyPopupView = SinglePolicyPopupView.instanceFromNib()
        
        alert.setup()
        
        return alert
    }
    
    func editBroadcastPopup(info : BCPrepareInfo) -> EditBroadSettingPopupView {
        let alert : EditBroadSettingPopupView = EditBroadSettingPopupView.instanceFromNib()
        
        alert.setup(broadcastInfo: info)
        
        return alert
    }
    
    func coinStatusPopup(info: CoinStatusInfo) -> CoinStatusPopupView {
        let alert : CoinStatusPopupView = CoinStatusPopupView.instanceFromNib()
        
        alert.setup(coinStatusInfo: info)
        
        return alert
    }
    
    func giftInputPopupView(content: String, buttonTitles:[String]) -> GiftInputPopupView {
        let alert : GiftInputPopupView = GiftInputPopupView.instanceFromNib()
        
        alert.setup(content: content, buttonTitles: buttonTitles)
        
        return alert
    }
    
    func suspensionPopupView() -> SuspensionPopupView {
        let alert : SuspensionPopupView = SuspensionPopupView.instanceFromNib()
        
        alert.setup()
        
        return alert
    }
    
    func showNotice(content:String) -> NoticePopupView? {        
        let alert : NoticePopupView = NoticePopupView.instanceFromNib()
        alert.setup(content: content)
        dispatchMain.async {
            self.blurView.dontDestory = true
            self.show(popup: alert)
        }
        
        return alert
    }
    
    func showAlert(content:String, needClear: Bool = false, buttonTitles : [String] = [], buttonActions : [()->Void] = []) {
        dispatchMain.async {
            
            let alert : AlertPopupView = AlertPopupView.instanceFromNib()
            
            
            alert.setup(content: content, buttonTitles: buttonTitles)
            //            self.alert.setup(content: content, okTitle: okTitle, cancelTitle: cancelTitle)
            self.blurView.dontDestory = true
            
            if buttonActions.count == 0 {
                alert.setButtonActions(actions: [{self.hide(popup: alert)}])
            }else {
                
                var newButtonActions : [()->Void] = []
                
                for action in buttonActions {
                    newButtonActions.append({
                        action()
                        self.hide(popup: alert)
                    })
                }
                alert.setButtonActions(actions: newButtonActions)
            }
            
            self.show(popup: alert) {
                if needClear {
                    for item in self.popups {
                        if alert != item {
                            item.closePopup()
                        }
                    }
                    self.popups.removeAll()
                    self.popups.append(alert)
                    self.loadingCount = 0
                }
            }
        }
    }
    
    func showInputAlert(title:String, buttonTitles : [String] = [], buttonActions : [(_ text : String )->Void] = [], maxInputText: Int, defaultPlaceHold: String = "", keyboardType : UIKeyboardType = .default ) {
        
        dispatchMain.async {
            let alert : PWInputPopupView = PWInputPopupView.instanceFromNib()
            
            alert.setup(content: title, buttonTitles: buttonTitles)
            
            alert.maxInputText = maxInputText
            
            alert.setPlaceHolder(text: defaultPlaceHold)
            
            alert.setKeyboardType(keyType: keyboardType)
            
            var newButtonActions : [(_ text : String )->Void] = []
            
            if buttonActions.count == 0 {
                alert.buttonActions = [{_ in self.hide(popup: alert)}]
            }else {
                for action in buttonActions {
                    newButtonActions.append({
                        text in
                        action(text)
                        self.hide(popup: alert)
                    })
                }
                alert.buttonActions = newButtonActions
            }
            
            self.show(popup: alert)
        }
    }
	
	func showInputTextviewAlert(title:String, buttonTitles : [String] = [], buttonActions : [(_ text : String )->Void] = [], maxInputText: Int, defaultPlaceHold: String = "", keyboardType : UIKeyboardType = .default ) {
		
		dispatchMain.async {
			let alert : TextviewPopupView = TextviewPopupView.instanceFromNib()
			
			alert.setup(content: title, buttonTitles: buttonTitles)
			alert.maxInputText = maxInputText
			alert.setPlaceHolder(text: defaultPlaceHold)
			alert.setKeyboardType(keyType: keyboardType)
			
			var newButtonActions : [(_ text : String )->Void] = []
			
			if buttonActions.count == 0 {
				alert.buttonActions = [{_ in self.hide(popup: alert)}]
			} else {
				for action in buttonActions {
					newButtonActions.append({
						text in
						action(text)
						self.hide(popup: alert)
					})
				}
				alert.buttonActions = newButtonActions
			}
			
			self.show(popup: alert)
		}
	}
	
    //MARK: - Popups
    func showPolicyPopup(closed: @escaping ()->Void = {  }){
        let popup = self.policyPopupView()
        
        popup.buttonActions = [{
            checked in
            //            if checked {
            //                userInfo.updateShowLoginPolicyTs()
            //            }
            
            // 푸쉬알림 : 로그인 성공시 푸쉬정보 갱신.
            if userInfo.remoteDeviceToken.isEmpty == false {
                connection.PushOnOff(command: .reset , isON: appData.pushOn, complete: { (succeed, info, resultInfo) in
                    log.debug("[PUSH] Key reset")
                })
//                connection.PushOnOff(command: .setup, isON: checked, complete: { (succeed, info, resultInfo) in
//                    log.debug("[PUSH] Normal OnOff \(checked)")
//                })
                connection.PushEventOnOff(command: .setup, isON: checked, complete: { (succeed, info, resultInfo) in
                    log.debug("[PUSH] eventPush OnOff \(checked)")
                })
            }
            //appData.pushOn = checked
            appData.pushEventOn = checked
            
            closed()
            self.hide(popup: popup)
            }]
        
        self.show(popup: popup)
    }
    
    func showSinglePolicyPopup(closed: @escaping ()->Void = {  }){
        let popup = self.singlePolicyPopupView()
        popup.buttonActions = [{
            closed()
            self.hide(popup: popup)
            }]
        self.show(popup: popup)
    }
    
    /*
    ///Show Policy popup (one week check)
    func showLoginPolicyPopup(closed: @escaping ()->Void = { _ in }){
        let popup = self.longTextPopup(content: loginPolicyContent, chkTitle: "일주일 동안 띄우지 않기", buttonTitles: [I18N.ui_ok.localized])
        popup.buttonActions = [{
            checked in
            if checked {
                userInfo.updateShowLoginPolicyTs()
            }
            closed()
            self.hide(popup: popup)
            },{checked in self.hide(popup: popup)}]
        
        self.show(popup: popup)
    }
    
    func showBroadcastPolicyPopup(agreeAction:@escaping ()->Void){
        
        let popup = self.longTextPopup(content: broadcastPolicyContent, chkTitle: "", buttonTitles: ["동의","취소"])
        
        popup.buttonActions = [{
            checked in
            if checked {
                userInfo.updateShowLoginPolicyTs()
            }
            agreeAction()
            self.hide(popup: popup)
            },{checked in self.hide(popup: popup)}]
        
        self.show(popup: popup)
        
    } */
    
    
    func showManagerPopup(addAction:@escaping (_ targetID:String)->Void, removeAction:@escaping (_ targetID:String)->Void) {
        let popup = self.threeBtnInputPopupView(content: I18N.ui_assignManager.localized, buttonTitles: [I18N.text_assign.localized,I18N.text_unassign.localized,I18N.ui_cancel.localized])
        popup.inputTextField.placeholder = I18N.ui_managerID.localized
        popup.buttonActions = [{
            targetID in
            self.hide(popup: popup)
            addAction(targetID)
            
            },{
                targetID in
                removeAction(targetID)
                self.hide(popup: popup)
            },{
                targetID in
                self.hide(popup: popup)
            }]
        
        self.show(popup: popup)
    }
    
    func showGiftInputPopup(action01:@escaping (_ targetID:String)->Void, action02:@escaping (_ targetID:String)->Void) {
        let popup = self.giftInputPopupView(content: I18N.watch_gift.localized, buttonTitles: [String(format:I18N.ui_giftSomething.localized, coinName),String(format:I18N.text_buyCoin.localized, coinName),I18N.ui_cancel.localized])
        popup.inputTextField.placeholder = String(format:I18N.watch_giftNumOfCoin01.localized, coinName)
        let text = String(format:I18N.ui_userCoin.localized, coinName) + ": " + CellUtil.getNumberCommaFormat(text: "\(userInfo.coin)") + I18N.ui_numOfCoin.localized
        popup.setInfoLabel(text: text)
        popup.maxInputText = 5
        popup.buttonActions = [{
            targetID in
            self.hide(popup: popup)
            action01(targetID)
            
            },{
                targetID in
                action02(targetID)
                self.hide(popup: popup)
            },{
                targetID in
                self.hide(popup: popup)
            }]
        
        self.show(popup: popup)
    }
    
    func showFanLevelPopup(clickAction : @escaping (_ index:Int)->Void) {
        let popup = self.multiButtonPoupView(title: I18N.text_freeze.localized)
        
        for value in FreezeLevel.allValues {
            popup.buttonTitles.append( value.stringValue() )
        }
        //popup.buttonTitles = ["전체","매니저 미만","VIP 미만","다이아몬드 미만","골드 미만","실버 미만"]
        popup.buttonAction = clickAction
        
        self.show(popup: popup)
        
    }
    
    func showCoinStatusPopup(info: CoinStatusInfo, doneAction: @escaping ()->Void ) {
        let popup = self.coinStatusPopup(info: info)
        popup.doneAction = doneAction
        self.show(popup: popup)
    }
    
    func showPresetPopup(type: PopkonHelper, infos: [HelperPresetInfo], delegate: HelperPresetDelegate?) { // }, doneAction: @escaping ()->Void ) {
        dispatchMain.async {
            let popup : PresetPopupView = PresetPopupView.instanceFromNib()
            popup.setup(preset: type, infos: infos)
            popup.delegate = delegate
            popup.center = self.currentWindow().center
            self.show(popup: popup)
        }
    }
    
    func showSuspensionPopup(inquireAction: @escaping ()->Void, doneAction: @escaping ()->Void ) {
        let popup = self.suspensionPopupView()
        popup.inquireAction = inquireAction
        popup.doneAction = doneAction
        self.show(popup: popup)
    }
    
    func showEditBroadCastSetting(broadcast: BCPrepareInfo, doneAction: @escaping (_ info: BCPrepareInfo) -> Void ) {
        let popup = self.editBroadcastPopup(info: broadcast)
        popup.doneAction = doneAction
        self.show(popup: popup)
    }
    
    func showLevelUpPopup(type: LevelType, level: Int, doneAction: @escaping ()->Void) {
        dispatchMain.async {
            let popup : LevelUpPopupView = LevelUpPopupView.instanceFromNib()
            popup.setup(type: type, level: level)
            popup.doneAction = doneAction
            popup.center = self.currentWindow().center
            self.show(popup: popup)
            
            if type == .service {
                userInfo.isServiceLvUp = false
            }
        }
    }
    
    //MARK: - LoadingView
    ///Show loadingView and start animating
    func setLoadingViewScale(scale : Float) {
        loadingView.setScale(scale: 0.5)
    }
    
    func showLoadingView() {
        loadingCount += 1
        //log.debug("[Loading] show : \(self.loadingCount)")
        
        DispatchQueue.main.async {
            if self.popups.firstIndex(of: self.loadingView) == nil {
                
                self.show(popup: self.loadingView)
                
                self.loadingView.center = self.currentWindow().center
            }
            
            self.loadingView.startAnimating()
        }
    }
    
    ///Hide loadingView and stop animating
    func hideLoadingView() {
        if loadingCount <= 0 {
            return
        }
        
        loadingCount -= 1
        
        //log.debug("[Loading] hide : \(self.loadingCount)")
        
        if loadingCount == 0 {
            dispatchMain.async {
                self.hide(popup: self.loadingView)
                
                self.loadingView.stopAnimating()
                //                self.loadingView.hide()
            }
            
        }
    }

    //MARK: - Cast Popup
    func showCastPopup(cast:CastInfo, netStatus: Reachability.NetworkStatus = .reachableViaWiFi, okAction:@escaping (_ popup:PopupView, _ text: String)->Void, cancelAction:@escaping ()->Void = {}) {
        DispatchQueue.main.async {
            let popup : CastPopupView = CastPopupView.instanceFromNib()
            
            popup.setup(cast:cast, netStatus: netStatus)
            //            self.alert.setup(content: content, okTitle: okTitle, cancelTitle: cancelTitle)
            // self.blurView.dontDestory = true
            
            popup.center = self.currentWindow().center
            
            popup.buttonAction.ok = { (popup,text) in
                okAction(popup,text)
//                self.hide(popup: popup)
                //self.hideLoadingView()
            }
            popup.buttonAction.cancel = {
                cancelAction()
                self.hide(popup: popup)
                //self.hideLoadingView()
            }
            
            self.show(popup: popup)
        }
    }
    
    ///
    func showCeluvVODPopup(vod: CeluvVODInfo, netStatus: Reachability.NetworkStatus = .reachableViaWiFi, okAction:@escaping (_ popup:PopupView, _ text: String)->Void, cancelAction:@escaping ()->Void = {}) {
        DispatchQueue.main.async {
            let popup : CastPopupView = CastPopupView.instanceFromNib()
            popup.setup(celuv: vod, netStatus: netStatus)
            popup.center = self.currentWindow().center
            popup.buttonAction.ok = { (popup,text) in
                okAction(popup,text)
                self.hide(popup: popup)
                //self.hideLoadingView()
            }
            popup.buttonAction.cancel = {
                cancelAction()
                self.hide(popup: popup)
                //self.hideLoadingView()
            }
            
            self.show(popup: popup)
        }
    }
    
    func showPaidCastPopup(cast: CastInfo, castMember: CastMemberInfo, message : String, netStatus: Reachability.NetworkStatus = .reachableViaWiFi, joinAction:@escaping ()->Void, buyAction:@escaping ()->Void, cancelAction:@escaping ()->Void = {}) {
        
        DispatchQueue.main.async {
            let popup : VodPopupView = VodPopupView.instanceFromNib()
            
            popup.setup(cast: cast, castMember: castMember, message: message, netStatus: netStatus)
            self.blurView.dontDestory = true
            popup.center = self.currentWindow().center
            
            popup.buttonAction.join = {
                joinAction()
                self.hide(popup: popup)
                //self.hideLoadingView()
            }
            popup.buttonAction.buy = {
                buyAction()
                self.hide(popup: popup)
                //self.hideLoadingView()
            }
            popup.buttonAction.cancel = {
                cancelAction()
                self.hide(popup: popup)
                //self.hideLoadingView()
            }
            self.show(popup: popup)
        }
    }
    
    //MARK: - Vod Popup
    func showVodPopup(vod: VODInfo, myfanInfo: FanMCInfo, netStatus: Reachability.NetworkStatus = .reachableViaWiFi, joinAction:@escaping ()->Void, buyAction:@escaping ()->Void, cancelAction:@escaping ()->Void = {}) {
        
        DispatchQueue.main.async {
            let popup : VodPopupView = VodPopupView.instanceFromNib()
            
            popup.setup(vod: vod, myInfo: myfanInfo, netStatus: netStatus)
            popup.center = self.currentWindow().center
            
            popup.buttonAction.join = {
                joinAction()
                self.hide(popup: popup)
                //self.hideLoadingView()
            }
            popup.buttonAction.buy = {
                buyAction()
                self.hide(popup: popup)
                //self.hideLoadingView()
            }
            popup.buttonAction.cancel = {
                cancelAction()
                self.hide(popup: popup)
                //self.hideLoadingView()
            }
            self.show(popup: popup)
        }
    }
    
    
    func getLastPopup() -> PopupView? {
        if self.popups.isEmpty {
            return nil
        }
        return self.popups.last
    }
    
    //MARK: - Shout Popup
    func showShoutPopup(itemNum: Int, okAction:@escaping (_ text: String)->Void, cancelAction:@escaping ()->Void = {}) {
        DispatchQueue.main.async {
            let popup : ShoutItemPopupView = ShoutItemPopupView.instanceFromNib()
            popup.setup(itemNum: itemNum)
            popup.center = self.currentWindow().center
            
            popup.buttonAction.ok = {
                if let text = popup.shoutTextField.text  {
                    okAction(text)
                }
                self.hide(popup: popup)
            }
            popup.buttonAction.cancel = {
                cancelAction()
                self.hide(popup: popup)
            }
            
            self.show(popup: popup)
        }
    }
    
    func showCasterNotice(notice: String, okAction:@escaping (_ text: String)->Void, cancelAction:@escaping ()->Void = {}) {
        DispatchQueue.main.async {
            let popup : CasterNoticePopupView = CasterNoticePopupView.instanceFromNib()
            popup.setup(currentNotice: notice)
            popup.center = self.currentWindow().center            
            popup.buttonAction.ok = {
                if let text = popup.noticeTextField.text  {
                    okAction(text)
                }
                self.hide(popup: popup)
            }
            popup.buttonAction.cancel = {
                cancelAction()
                self.hide(popup: popup)
            }
            
            self.show(popup: popup)
        }
    }

    
    //MARK: - Private
    
    ///Show popup view
    func show(popup: PopupView, finished: (@escaping ()->Void) = {} ) {
        
        dispatchMain.async {
            if self.popups.firstIndex(of: popup) != nil {
                self.hide(popup: popup)
            }
            
            popup.center = self.currentWindow().center
            if self.popups.firstIndex(of: popup) == nil {
                self.blurView.showInView(parentView: self.currentWindow())
                //log.debug("[Loading] blur Show")
                popup.showInView(parentView: self.currentWindow())
                self.popups.append(popup)
            }
            
            finished()
        }
    }
    
    ///Hide popup View
    func hide(popup: PopupView) {
        dispatchMain.async {
            if let index = self.popups.firstIndex(of: popup) {
                self.popups.remove(at: index)
                popup.hide()
            }
            
            if self.popups.count == 0 {
                //log.debug("[Loading] blur Hide")
                self.blurView.hide()
            }
        }
        
    }

    // Clearup All popup
    func clearAllPopup(bCancel: Bool = false) {
        
        self.blurView.removeAtOnce = true
        self.blurView.hide()
        
        if popups.isEmpty == false {
            for popup in popups {
                if bCancel {
                    popup.closePopup()
                } else {
                    popup.hide()
                }
            }
            loadingCount = 0
            popups.removeAll()
        }
    }
    
    func defaultAlert(title: String, subject: String, btn1Title: String, btn2title: String)
    {
        let alert = UIAlertController(title: title, message: subject, preferredStyle: .alert)
        
        if(btn2title != "")
        {
            alert.addAction(UIAlertAction(title: I18N.ui_cancel.localized, style: .default, handler: { (_) in
                
            }))
        }
        
        if(btn1Title != "")
        {
            alert.addAction(UIAlertAction(title: btn1Title, style: .default, handler: { (_) in
                
            }))
        }
        
        if self.currentViewController != nil {
            self.currentViewController?.present(alert, animated: true, completion: nil)
            //            self.currentViewController!.present(alert, animated: true, completion: nil)
        }
        
    }
	
	func alertAction(_ message: String, buttonAction: (() -> Void)? = nil) {
		let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
		alert.addAction(UIAlertAction(title: I18N.comm_done.localized, style: .default, handler: { (_) in
			buttonAction?()
		}))
		
		dispatchMain.async {
			self.getTopMostViewController()?.present(alert, animated: true, completion: nil)
		}
	}
    
    func defalutOKAction(title: String, subject: String, btnTitle: String, okAction:@escaping ()->Void) {
        let alert = UIAlertController(title: title, message: subject, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: btnTitle, style: .default, handler: { (_) in
            okAction()
        }))
        
        if self.currentViewController != nil {
            self.currentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func selectionServerDomain(finished: (@escaping ()->Void) = {}) {
        let alert = UIAlertController(title: "", message: "서버 선택", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Dev", style: .default, handler: { (_) in
            serverDomain = developDomain
            finished()
        }))
        
        alert.addAction(UIAlertAction(title: "Stage", style: .default, handler: { (_) in
            serverDomain = stageDomain
            finished()
        }))
        
        alert.addAction(UIAlertAction(title: "Release", style: .default, handler: { (_) in
            serverDomain = productDomain
            finished()
        }))
        
        if self.currentViewController != nil {
            self.currentViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    private func currentWindow()->UIView {
        return (UIApplication.shared.keyWindow)!
    }
	
	private func getTopMostViewController() -> UIViewController? {
		var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
		
		while let presentedViewController = topMostViewController?.presentedViewController {
			topMostViewController = presentedViewController
		}
		
		return topMostViewController
	}
    
    /*
    func showToast(message: String) {
        if let  rootVC = UIApplication.shared.keyWindow?.rootViewController {
            if rootVC.presentedViewController != nil {
                if rootVC.presentedViewController!.isKind(of: UINavigationController.self) {
                    if let naviVC = rootVC.presentedViewController as? UINavigationController {
                        if let vc = naviVC.viewControllers.last {
                            vc.view.makeToast(message, duration: 1.0, position: .center)
                        }
                    }
                } else {
                    rootVC.presentedViewController!.view.makeToast(message, duration: 1.0, position: .center)
                }
                
                
            } else {
                rootVC.view.makeToast(message, duration: 1.0, position: .center)
            }
        }
    }
*/
}

