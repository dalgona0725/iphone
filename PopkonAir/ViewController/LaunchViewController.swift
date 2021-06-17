//
//  LaunchViewController.swift
//  PopkonAir
//
//  Created by Steven on 13/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import ReachabilitySwift

class LaunchViewController: BaseViewController {
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    let reachability = Reachability()!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        loadingIndicator.isHidden = true
        
        self.view.backgroundColor = launchBackColor

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        selectServerDomain()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Steps
    
    func loadAppData(finished:@escaping ()->Void) {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        ConnectionManager.manager.loadAppData { (succeed, json, resultInfo) in
            if succeed {
                log.debug("\n\n loadAppData Succeed")
                
                finished()
                
                
            }else {
                //
                log.debug("\n\n loadAppData Failed")
            }
        }
    }
    
    /// 상용서버가 아닐 경우 개발/스테이지 서버 선택
    private func selectServerDomain() {
        if serverDomain != productDomain {
            popupManager.selectionServerDomain() {
                self.step1()
            }
        } else {
            self.step1()
        }
    }
    
    func step1() {
        
        log.debug("start step1")
        checkLTEData {
            self.step2()
        }
    }
    
    func step2() {
        
        log.debug("start step2")
        self.loadAppData {
            self.step3()
        }
    }
    
    func step3() {
        
        log.debug("start step3")
        self.checkNeedUpdate {
            self.step4()
        }
        
    }
    
    func step4() {
        log.debug("start step4")
        
        self.checkLoginInfo{
            self.step5()
        }
    }
    
    func step5() {
        
        log.debug("start step5")
        
        self.loadMainAdImages {
            self.step6()
        }
    }
    
    func step6() {
        log.debug("start step6")
        
        self.loadDefaultProfileImages {
            self.step7()
        }
    }
    
    func step7() {
        log.debug("start step7")
        
        ///auto login and go to main view
        userInfo.checkAppLock {
            self.step8()
        }
    }
    
    func step8() {
        log.debug("start step8")
        userInfo.loadPushInfo(finished: {
            self.allFinished()
        })
    }
    
    
    
	override func openBroadcastStart(_ notification: NSNotification) {
		
	}
    
    
    //MARK: - Private Method
    //MARK: Login
    func autoLogin(finished: @escaping ()->Void) {
        //log.debug("\n\n[start auto login]\n\n")
        connection.login(userID: userInfo.userID, userPw: userInfo.userPW, showErrorMsg: false) { (succeed, resultInfo) in
            if succeed {
                finished()
            } else {
                userInfo.isAutoLogin = false
                dispatchMain.async(execute: {
                    if resultInfo.message.isEmpty {
                        finished()
                    } else {
                        popupManager.showAlert(content: resultInfo.message, buttonTitles: [I18N.ui_ok.localized], buttonActions:  [{
                            finished()
                            }])
                    }
                })
            }
        }
    }
    
   
    
    //MARK: Load Main AD images
    func loadMainAdImages(finished : @escaping ()->Void) {
        
        let downloadImages = {
            let myGroup = DispatchGroup.init()
            
            for info in appData.adMainImages {
                myGroup.enter()
                
                self.downloadImage(fromURL: info.imageURL) { (image) in
                    if image != nil {
                        info.image = image
                    }
                    myGroup.leave()
                }
            }
            
            myGroup.notify(queue: DispatchQueue.main) {
                
                finished()
            }
        }
        
        connection.loadMainAdImages { (succeed, imageInfoList, resultInfo) in
            if succeed {
                appData.adMainImages = imageInfoList
                
                downloadImages()
            }else {
                
            }
        }
    }
    
    
    //MARK: Load category images
    func loadCategoryImages(finished : @escaping ()->Void) {
        
        let myGroup = DispatchGroup.init()
        
        for info in appData.adultCategoryArr {
            myGroup.enter()
            
            self.downloadImage(fromURL: info.categoryThumb) { (image) in
                if image != nil {
                    info.categoryImage = image
                }
                myGroup.leave()
            }
        }
        
        myGroup.notify(queue: DispatchQueue.main) {
            
            finished()
        }
        
    }
    
    func checkLTEData(finished: @escaping ()->Void) {
        
        let nextStep = {
            finished()
        }
        
        let notifyReachable = {
            self.reachability.whenReachable = {
                reachability in
                dispatchMain.async {
                    nextStep()
                    self.reachability.stopNotifier()
                }
            }
            
            do {
                try self.reachability.startNotifier()
            } catch {
                print("Unable to start notifier")
            }
            
        }
        
        if reachability.currentReachabilityStatus == .notReachable {
            popupManager.showAlert(content: I18N.err_disableNetwork.localized, buttonTitles: [I18N.ui_ok.localized], buttonActions: [{
                self.reachability.stopNotifier()
                self.step1()
                }])
            
            notifyReachable()
        }else {
            nextStep()
        }
    }
    
    func checkNeedUpdate(finished: @escaping ()->Void) {
        if appData.needUpdate {
            popupManager.showAlert(content: I18N.err_needUpdate.localized, buttonTitles: [I18N.ui_ok.localized,I18N.ui_cancel.localized], buttonActions: [{
                if appData.updateURL.count > 0 {
					if let url = URL(string: appData.updateURL) {
						UIApplication.shared.open(url)
					}
                } else {
                    log.debug("No update url")
                    exit(0)
                }

                },{
                    exit(0)
                }])

        } else {
            finished()
        }
    }
    
    func loadDefaultProfileImages(finished: @escaping ()->Void) {
        appData.loadDefaultProfileImg(completeHandler: {
            finished()
        })
    }
    
    func checkLoginInfo(finished: @escaping ()->Void){
        if userInfo.userID.count > 0 && userInfo.userPW.count > 0 && userInfo.isAutoLogin {
            //Auto login
            self.autoLogin {
                finished()
            }
        }else {
            //Finished
            finished()
        }
    }
    
    func allFinished() {
        //goto MainView
        let deadlineTime = DispatchTime.now() + .seconds(1)
        
        let finished = {
            dispatchMain.asyncAfter(deadline: deadlineTime, execute: {
                self.loadingIndicator.stopAnimating()
                self.changeRootViewController(with: "TabBarController")
            })
        }
        
        if( serverDomain == developDomain || serverDomain == stageDomain) {
            var alertText = ""
            if serverDomain == developDomain {
                alertText = "개발서버 버전(\(appData.currentVersion)-\(appData.currentBuild))입니다."
            } else if serverDomain == stageDomain {
                alertText = "스테이지서버 버전(\(appData.currentVersion)-\(appData.currentBuild))입니다."
            }
            dispatchMain.async {
                popupManager.defalutOKAction(title: I18N.ui_notice.localized, subject: alertText, btnTitle: I18N.ui_ok.localized) {
                    finished()
                }
            }
        } else {
            finished()
        }
    }
    
    
    private func downloadImage(fromURL:String, complete:@escaping (_ image : UIImage?)-> Void) {
        DispatchQueue.global().async {
            let image = URL(string: fromURL)
                .flatMap { (try? Data(contentsOf: $0)) }
                .flatMap { UIImage(data: $0) }
            
            if image != nil {
                log.debug("fromURL: \(fromURL) -> succeed")
            }else {
                log.debug("fromURL: \(fromURL) -> failed")
            }
            
            complete(image)
            
        }
    }
}
