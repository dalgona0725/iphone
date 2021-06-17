//
//  SetAlarmViewController.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 12. 28..
//  Copyright © 2017년 eugene. All rights reserved.
//

import Foundation

import UIKit
import StoreKit

enum AlarmSetting {
    case freeTime
    case broadcastOnOff
    case eventOnOff
}

enum DefaultTimeType : String {
    case ignoreTime = "0000"
    case startTime  = "2300"
    case endTime    = "0900"
}

class SetAlarmViewController : BaseViewController {
    @IBOutlet weak var menuTableView: UITableView!    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var pickerMenuView: UIView!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    
    var menuType : AlarmSetting = .freeTime
    var headerTitles : [String] = []
    var items = [OptionItem]()
    
    var favoriteList : [PushFavoriteInfo] = []
    var currentPage : Int = 0
    var totalPage   : Int = 1
    let refreshControl = UIRefreshControl()
    
    var selectIndexPath : IndexPath?
    
    var oldBlockTime    = false
    var oldStartTime    = DefaultTimeType.ignoreTime.rawValue
    var oldEndTime      = DefaultTimeType.ignoreTime.rawValue
    
    var currentBlockTime = false
    var currentStartTime = DefaultTimeType.ignoreTime.rawValue
    var currentEndTime   = DefaultTimeType.ignoreTime.rawValue

    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let bundle = Bundle(for: type(of: self))
        self.menuTableView.register(UINib(nibName: "OptionInfoCell", bundle: bundle), forCellReuseIdentifier: "OptionInfoCell")
        self.menuTableView.register(UINib(nibName: "AlarmTimeCell", bundle: bundle), forCellReuseIdentifier: "AlarmTimeCell")
        self.menuTableView.register(UINib(nibName: "AlarmFavoriteCell", bundle: bundle), forCellReuseIdentifier: "AlarmFavoriteCell")
        self.menuTableView.register(UINib(nibName: "OptionSectionView", bundle: bundle), forHeaderFooterViewReuseIdentifier: "OptionSectionView")
        
        self.menuTableView.alwaysBounceVertical = false
        self.menuTableView.alwaysBounceHorizontal = false
        self.menuTableView.separatorInset = UIEdgeInsets.zero
        
        self.changeButton.setTitle(I18N.ui_changed.localized, for: .normal)
        self.cancelButton.setTitle(I18N.ui_cancel.localized, for: .normal)
        
        if menuType == .broadcastOnOff {
            //Refresh
            refreshControl.attributedTitle = NSAttributedString(string: I18N.ui_pullRefresh.localized)
            refreshControl.addTarget(self, action: #selector(self.reloadFavoriteList), for: .valueChanged)
            self.menuTableView.addSubview(refreshControl)
            
            self.menuTableView.separatorStyle = .singleLine
            self.menuTableView.alwaysBounceVertical = true
            
            self.reloadFavoriteList()
        } else if menuType == .freeTime {
            oldBlockTime = appData.usePushBlockTime
            oldStartTime = appData.pushOffStartTime
            oldEndTime   = appData.pushOffEndTime
            
            currentBlockTime = appData.usePushBlockTime
            currentStartTime = appData.pushOffStartTime
            currentEndTime   = appData.pushOffEndTime
        }
        pickerMenuView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        switch menuType {
        case .freeTime:
            self.setBarTitle(with: I18N.ui_settingAlarmFreeTime.localized)
            self.setBarRoundTitle(with: I18N.ui_save.localized, controlState: .normal)
            self.setBarAction(round: { (sender) in
                self.checkModifiedPushOnOffTime()
            })
            self.setBarAction(back: {
                /*
                if self.currentBlockTime == false {
                    if self.currentBlockTime != self.oldBlockTime {
                        let ignoreTime = DefaultTimeType.ignoreTime.rawValue
                        connection.pushFreeTime(command: .setup, startTime: ignoreTime, endTime: ignoreTime) { (succeed, json) in
                            appData.pushOffStartTime    = ignoreTime
                            appData.pushOffEndTime      = ignoreTime
                            appData.usePushBlockTime    = self.currentBlockTime
                        }
                    }
                } */
                self.popBack()
                return
            })
        case .broadcastOnOff:
            self.setBarTitle(with: I18N.ui_casterAlarm.localized)
        case .eventOnOff:
            self.setBarTitle(with: I18N.ui_settingEventAlarm.localized)
        }

        userInfo.checkLoginStatus(finished: {
        })
        
        
        if let tabBarVC = UIApplication.shared.keyWindow?.rootViewController as? BaseTabBarController {
            tabBarVC.myTabBar.isHidden = true
        }
		
		self.view.backgroundColor = .white
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        for item in items {
            item.clear()
        }
        
        if let headerView = self.menuTableView.headerView(forSection: 0) as? ReferenceItemClear {
            headerView.clear()
        }
        
        for item in self.menuTableView.visibleCells {
            if let cell = item as? ReferenceItemClear {
                cell.clear()
            }
        }
        
        if let tabBarVC = UIApplication.shared.keyWindow?.rootViewController as? BaseTabBarController {
            tabBarVC.myTabBar.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - User Log out
    override func willLogOut() {
    }
    override func didLogOut(_ notification: NSNotification) {
        dispatchMain.async {
            self.navigationController?.popViewController(animated: true )
        }
    }
    
    //MARK: - Navigation
    @objc private func popBack() {
        if let navi = self.navigationController {
            if navi.viewControllers.count>1 {
                navi.popViewController(animated: true)
            }else {
                navi.dismiss(animated: true, completion: {})
            }
            
        }else {
            self.dismiss(animated: true, completion: {
                
            })
        }
    }
    
    //MARK: - UI Setup
    
    func setup(menuType: AlarmSetting) {
        self.menuType = menuType
    
        switch  menuType {
        case .freeTime:
            setupPushOffTime(useBlock: appData.usePushBlockTime, startTime: appData.pushOffStartTime, endTime: appData.pushOffEndTime)
        case .broadcastOnOff:
            setupFavoriteOnOff()
        case .eventOnOff:
            setupEventPushOnOff()
        }
    }
    
    //MARK: - Setup FreeTime
    func setupPushOffTime(useBlock: Bool, startTime: String, endTime: String) {
        headerTitles = []
        items = []
        headerTitles.append(I18N.ui_settingTime.localized)
    
        var start = startTime
        var end = endTime
        let ignoreTime = DefaultTimeType.ignoreTime.rawValue
        if startTime == ignoreTime && endTime == ignoreTime {
            start   = DefaultTimeType.startTime.rawValue
            end     = DefaultTimeType.endTime.rawValue
        }
        
        if useBlock {
            var item = OptionItem(title: I18N.ui_startTime.localized, text: start, type: .text)
            items.append(item)
            item = OptionItem(title: I18N.ui_endTime.localized, text: end, type: .text)
            items.append(item)
        }
            
        dispatchMain.async {
            self.menuTableView.reloadData()
        }
    }
    func updatePushOffTime(startTime: String, endTime: String) {
        
        let ignoreTime = DefaultTimeType.ignoreTime.rawValue
        if startTime == ignoreTime && endTime == ignoreTime {
            // appData.usePushBlockTime = false
            currentBlockTime = false
        } else {
            currentBlockTime = true
        }
        currentStartTime = startTime
        currentEndTime   = endTime
        
//        connection.pushFreeTime(command: .setup, startTime: startTime, endTime: endTime) { (succeed, json) in
//            appData.pushOffStartTime = startTime
//            appData.pushOffEndTime = endTime
//        }
    }
    
    func alterPushOffTime() {
        connection.pushFreeTime(command: .setup, startTime: self.currentStartTime, endTime: self.currentEndTime) { (succeed, json) in
            if succeed {
                appData.pushOffStartTime = self.currentStartTime
                appData.pushOffEndTime = self.currentEndTime
                appData.usePushBlockTime = self.currentBlockTime
                
                self.oldBlockTime = self.currentBlockTime
                self.oldStartTime = self.currentStartTime
                self.oldEndTime = self.currentEndTime
            }
        }
    }
    
    func checkModifiedPushOnOffTime() {
        if currentBlockTime {
            if currentStartTime == oldStartTime && currentEndTime == oldEndTime {
                popupManager.showAlert(content: I18N.err_noChanged.localized)
                return
            }
            
            popupManager.showAlert(content: I18N.text_saveChanged.localized, buttonTitles: [I18N.ui_ok.localized,I18N.ui_cancel.localized], buttonActions: [{
                self.alterPushOffTime()
                },{}])
        } else {
            if currentBlockTime != oldBlockTime {
                popupManager.showAlert(content: I18N.text_saveChanged.localized, buttonTitles: [I18N.ui_ok.localized,I18N.ui_cancel.localized], buttonActions: [{
                    self.alterPushOffTime()
                    },{}])
            } else {
                popupManager.showAlert(content: I18N.err_noChanged.localized)
            }
        }
    }
    
    
    //MARK: - Setup Favorite Push On/Off
    func setupFavoriteOnOff() {
        headerTitles = []
        headerTitles.append(I18N.ui_casterAlarm.localized)
    }
    func alterFavoritOnOff(caster: String, partnerCode: String, isOn: Bool) {
    }
    func loadFavoriteList(page : Int) {
        popupManager.showLoadingView()
        connection.loadFavoritePushList(pageNum: page) { (succeed, list, resultInfo) in
            
            if succeed {
                self.totalPage = resultInfo.totalPageNum
                if self.currentPage < resultInfo.pageNum {
                    self.currentPage = resultInfo.pageNum
                    self.favoriteList.append(contentsOf: list)
                }
                
                dispatchMain.async {
                    self.menuTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            } else {
                if resultInfo.message.isEmpty == false {
                    if resultInfo.message == "BDJJP" {
                        popupManager.showAlert(content: I18N.err_noFavorite.localized)
                    } else if(resultInfo.message == "IPC") {
                        log.debug("[ERROR] IPC 발생...")
                    }  else {
                        popupManager.showAlert(content: resultInfo.message)
                    }
                }
                
                dispatchMain.async {
                    self.refreshControl.endRefreshing()
                }
            }
            popupManager.hideLoadingView()
        }
    }
    
    @objc func reloadFavoriteList(){
        currentPage = 0
        favoriteList = []
        self.menuTableView.reloadData()
        loadFavoriteList(page: 1)
    }
    
    //MARK: - Setup Event Push On/Off
    func setupEventPushOnOff() {
        headerTitles = []
        items = []
        
        headerTitles.append(I18N.ui_pushAlarm.localized)
        let item = OptionItem(title: I18N.ui_settingEventAlarm.localized, type: .slider, switchOn: appData.pushEventOn)
        item.onChange = { sw in
            self.alterEventPushOnOff(isOn: sw.isOn)
        }
        items.append(item)
        
        dispatchMain.async {
            self.menuTableView.reloadData()
        }
    }
    func alterEventPushOnOff(isOn: Bool) {
        connection.PushEventOnOff(command: .setup, isON: isOn, complete: { (succeed, info, resultInfo) in
            if succeed {
                appData.pushEventOn = info.isON
            }
        })
    }
    
    //MARK: - IBAction
    @IBAction func pickerDateChanged(_ sender: Any) {
    }
    @IBAction func confirmChangeDate(_ sender: Any) {
        // 해당 아이템 정보 업데이트...
        //let outForm = DateFormatter().dateFormat = "a hh:mm"
        let outDataForm = DateFormatter()
        outDataForm.dateFormat = "HHmm"
        let strDate = outDataForm.string(from: datePicker.date)
        if selectIndexPath != nil {
            items[selectIndexPath!.row].text = strDate
            menuTableView.reloadData()
            self.updatePushOffTime(startTime: self.items[0].text, endTime: self.items[1].text)
        }
        
        hidePickerView()
    }
    @IBAction func cancelChangeDate(_ sender: Any) {
        hidePickerView()
    }
    
    func hidePickerView() {
        if selectIndexPath != nil {
            menuTableView.deselectRow(at: selectIndexPath!, animated: true)
            selectIndexPath = nil
        }
        
        let translation = CATransform3DMakeTranslation(0, 0, 0)
        UIView.animate(withDuration: 0.3, animations: {
            self.pickerMenuView.layer.transform = translation
            self.pickerMenuView.alpha = 0
            self.menuTableView.alpha = 1
        }) { (succeed) in
            self.pickerMenuView.isHidden = true
            self.pickerMenuView.layer.transform = CATransform3DIdentity
            self.pickerMenuView.frame.origin.y = UIScreen.main.bounds.height
            self.menuTableView.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - PUSH Event handler
//    override func openBroadcastStart(_ notification: NSNotification) {
//        self.pushBroadcastStart(notification: notification)
//    }
    
}

// MARK: - TableView Delegate
extension SetAlarmViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        switch menuType {
        case .broadcastOnOff:
            return favoriteList.count
        default :
            return items.count
        }
            
       //return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch menuType {
        case .freeTime:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmTimeCell",for:indexPath) as! AlarmTimeCell
            let option = items[indexPath.row]
            cell.setInfo(option: option)
            return cell
        case .broadcastOnOff:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmFavoriteCell",for:indexPath) as! AlarmFavoriteCell
            let option = favoriteList[indexPath.row]
            cell.setInfo(option: option)
            cell.onChange = { (pushCode,isOn) in
                connection.setFavoritePushOnOff(pushCode: pushCode, isOn:isOn, complete: { (succeed, resultInfo) in
                })
                
                let index = self.favoriteList.firstIndex(where: { (info) -> Bool in
                    if info.pushCode == pushCode {
                        return true
                    } else {
                        return false
                    }
                })
                if index != nil {
                    self.favoriteList[index!].isPushOn = isOn
                }
            }
            return cell
        case .eventOnOff:
            let cell = tableView.dequeueReusableCell(withIdentifier: "OptionInfoCell",for:indexPath) as! OptionInfoCell
            let option = items[indexPath.row]
            cell.setInfo(option: option)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if menuType != .freeTime {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        
        if items.count <= indexPath.row {
            return
        }
        
        if selectIndexPath != nil {
            if selectIndexPath == indexPath {
                return
            }
            menuTableView.deselectRow(at: selectIndexPath!, animated: true)
        }
        
        let option = items[indexPath.row]
        selectIndexPath = indexPath
        //selectItemIndex = indexPath.row
        
        if pickerMenuView.isHidden == false {
            return
        }
        
        if option.type == .text {
            pickerMenuView.isHidden = false
            pickerMenuView.alpha = 0
            
            // 데이트피커 시간설정.
            let dateform = DateFormatter()
            dateform.dateFormat = "HHmm"
            if let datetime = dateform.date(from:option.text) {
                datePicker.setDate(datetime, animated: false)
            }
            
            var moveValue = self.pickerMenuView.frame.height + 60
            if self.isIPhoneXSeries() {
                moveValue = moveValue + 34
            }
            
            self.pickerMenuView.frame.origin.y = UIScreen.main.bounds.height
            let translation = CATransform3DMakeTranslation(0, -moveValue, 0)
            UIView.animate(withDuration: 0.3, animations: {
                self.pickerMenuView.layer.transform = translation
                self.pickerMenuView.alpha = 1
                self.menuTableView.alpha = 0.3
            }) { (succeed) in
                self.menuTableView.isUserInteractionEnabled = false
            }
        }
    }
    
    //MARK: - TableView Header
    func numberOfSections(in tableView: UITableView) -> Int {
        return headerTitles.count
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if menuType == .freeTime {
            return 40
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if menuType == .broadcastOnOff {
            return 60
        } else {
            return 48
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "OptionSectionView") as? OptionSectionView {
            if menuType == .freeTime {
                cell.setInfo(title: headerTitles[section], hideSwitch: false, onSwitchAction: { (sw) in
                    if userInfo.isLogined == false {
                        dispatchMain.async {
                            popupManager.showAlert(content: I18N.err_needLoginforUse.localized)
                            sw.setOn(!sw.isOn, animated: true)
                        }
                        return
                    }
                    
                    // appData.usePushBlockTime = sw.isOn
                    let ignoreTime = DefaultTimeType.ignoreTime.rawValue
                    if sw.isOn == false {
                        self.updatePushOffTime(startTime: ignoreTime, endTime: ignoreTime)
                    } else {
                        if self.currentStartTime == ignoreTime && self.currentEndTime == ignoreTime {
                            self.updatePushOffTime(startTime: DefaultTimeType.startTime.rawValue, endTime: DefaultTimeType.endTime.rawValue)
                        }
                    }
                    self.setupPushOffTime(useBlock: self.currentBlockTime, startTime: self.currentStartTime, endTime: self.currentEndTime)
                    
                    if self.pickerMenuView.alpha == 1 {
                        self.hidePickerView()
                    }
                    
                })
                cell.optionSwitch.isOn = self.currentBlockTime
                return cell
            }
        }
        
        return nil
    }
    
    /// 페이징 처리
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == favoriteList.endIndex - 1 {
            if self.currentPage < self.totalPage {
                self.loadFavoriteList(page: self.currentPage + 1)
            }
        }
    }
}
