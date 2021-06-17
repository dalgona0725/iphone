//
//  PresetPopupView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2020/10/10.
//  Copyright © 2020 The E&M. All rights reserved.
//

import UIKit
import UserNotifications
import ReachabilitySwift

protocol HelperPresetDelegate {
    /// 변경버튼을 눌렀을 경우 처리
    func add(helper: PopkonHelper, infos: [HelperPresetInfo])
    /// 갱신버튼을 눌러서 리스트갱신이 이루어질때
    func refresh(helper: PopkonHelper, infos: [HelperPresetInfo])
}

class PresetPopupView : PopupView {
    
    @IBOutlet weak var topPanel: UIView!
    @IBOutlet weak var popupTitle: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: HelperPresetDelegate? = nil
    
    var orgSize : CGSize = CGSize(width: 0, height: 0)
    
    /// 헬퍼 속성
    var presetType: PopkonHelper = .alert
    var presetInfos = [HelperPresetInfo]()
    
    //MARK: - Class Func
    class func instanceFromNib() -> PresetPopupView {
        return (Bundle.main.loadNibNamed("PresetPopupView", owner: self, options: nil)![0] as? PresetPopupView)!
    }
    
    //MARK: - UI Setup
    func setup(preset: PopkonHelper, infos: [HelperPresetInfo] ) {
        self.tableView.register(HelperPresetCell.nib, forCellReuseIdentifier: HelperPresetCell.identifier)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        popupTitle.text = String(format: I18N.ui_helper_popup_title.localized, preset.getName())
        popupTitle.textColor = UIColor.black
        topPanel.backgroundColor = UIColor.white //popupMainColor
        okButton.backgroundColor = popupMainColor
        okButton.setTitle(I18N.ui_confirmed.localized, for: .normal)
        okButton.setTitleColor(popupOkButtonColor, for: .normal)
        cancelButton.setTitle(I18N.ui_cancel.localized, for: .normal)
        
        orgSize = self.frame.size
        
        presetType = preset
        presetInfos = infos
        ///loadCurrentHelper()
        self.tableView.separatorStyle = .none
        self.tableView.reloadData()
        
        if self.presetType == .goal || self.presetType == .subtitle {
            self.infoLabel.text = I18N.text_helper_menu_tip.localized
        } else {
            self.infoLabel.text = ""
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if let center = self.window?.center {
            self.center = center
        }
        if orgSize.width != 0 && orgSize.height != 0 {
            self.frame.size = orgSize
        }
    }
    
    func loadCurrentHelper() {
        connection.getWidetLink(page: self.presetType) { (succced, infos, resultInfo) in
            if succced {
                
                var newInfos = [HelperPresetInfo]()
                for info in infos {
                    let item  = self.presetInfos.first { (preset) -> Bool in
                        return preset.index == info.index && preset.url == info.url && preset.name == info.name
                    }
                    if let item = item {
                        info.selected = item.selected
                    }
                    newInfos.append(info)
                }
                
                self.presetInfos = newInfos
                self.delegate?.refresh(helper: self.presetType, infos: newInfos)
                
                dispatchMain.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func refreshList(_ sender: UIButton) {
        self.loadCurrentHelper()
    }
    
    func closeup() {
        dispatchMain.async {
            popupManager.hide(popup: self)
            self.hide()
        }
        self.delegate = nil
    }
    
    @IBAction func okAction(_ sender: UIButton) {
        if let reachability = Reachability() {
            if reachability.currentReachabilityStatus == .notReachable {
                NotificationCenter.default.post(name: NSNotification.Name(kNetworkErrorNoti), object: nil)
                reachability.stopNotifier()
                self.closeup()
            } else {
                self.delegate?.add(helper: self.presetType, infos: self.presetInfos)
                self.closeup()
            }
        }
    }
    @IBAction func cancelAction(_ sender: UIButton) {
        self.closeup()
    }
    
    override func closePopup() {
        dispatchMain.async {
            self.closeup()
        }
    }
    
}


extension PresetPopupView : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presetInfos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        if let cell = tableView.dequeueReusableCell(withIdentifier: HelperPresetCell.identifier, for: indexPath) as? HelperPresetCell {
            cell.presetLabel.text = presetInfos[indexPath.row].name
            cell.checkBoxButton.isSelected = presetInfos[indexPath.row].selected
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presetInfos[indexPath.row].selected.toggle()
        if presetInfos[indexPath.row].selected {
            for (index, item) in presetInfos.enumerated() {
                if index == indexPath.row {
                    continue
                }
                item.selected = false
            }
        }
        
        for cell in tableView.visibleCells {
            if let cell = cell as? HelperPresetCell {
                cell.checkBoxButton.isSelected = false
            }
        }
        if let cell = tableView.cellForRow(at: indexPath), presetInfos[indexPath.row].selected {
            if let cell = cell as? HelperPresetCell {
                cell.checkBoxButton.isSelected = true
            }
        }
    }
}
