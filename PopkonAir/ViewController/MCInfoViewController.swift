//
//  MCInfoViewController.swift
//  PopkonAir
//
//  Created by Steven on 01/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SDWebImage

class MCInfoViewController: BaseViewController {

    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var fanCntLabel: UILabel!
    @IBOutlet weak var favorCntLabel: UILabel!
    @IBOutlet weak var fanLevelLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var fanListLabel: UILabel!
    
    @IBOutlet weak var fanLevelImage: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    //방송자 랭킹정보
    var mc : MCInfo = MCInfo()
    
    //시청자기준 방송자 정보
    fileprivate var fanMC : FanMCInfo = FanMCInfo()
    
    
    //열혈팬 리스트
    fileprivate var fanList: [FanInfo] = []
    
    fileprivate var enableFavorite = true
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //set bg color
        self.contentView.backgroundColor = mainColor
        
        self.initTextColor()
        
        //load Data
        userInfo.checkLoginStatus(finished: {
            self.loadFanMCInfo()
            self.loadFanList()
        })
        
        
        tableView.separatorInset = UIEdgeInsets.zero
        
        rankLabel.text = ""
        fanCntLabel.text = ""
        favorCntLabel.text = ""
        fanLevelLabel.text = ""
    }
    
    private func initTextColor() {
        fanListLabel.textColor = infoTextColor
        for subview in containerView.subviews {
            if let label = subview as? UILabel {
                label.textColor = infoTextColor
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //Setup Navi Bar
        self.setBarTitle(with: self.mc.nickname)
        var info = BarButtonInfo()
        info.type = .favorite
        info.actionHandler = {
            sender in
            
            let favoriteProcess : () -> Void = {
                if self.enableFavorite == false {
                    return
                }
                self.enableFavorite = false
                
                popupManager.showLoadingView()
                connection.sendFavoriteCast(castID:self.mc.signID,
                                            castPartnerCode: self.mc.partnerCode ,
                                            dataType: (self.fanMC.isFavored ? .remove : .add) )
                { (succeed, resultinfo) in
                    if succeed {
                        //print("success")
                        
                        self.fanMC.isFavored = !self.fanMC.isFavored
                        
                        // update favor button status
                        dispatchMain.async {
                            sender.isSelected = self.fanMC.isFavored
                        }
                        
                        let content = self.fanMC.isFavored ? I18N.favorite_follow.localized : I18N.favorite_unfollow.localized
                        popupManager.showAlert(content: content, buttonTitles: [I18N.ui_ok.localized], buttonActions: [{
                            self.enableFavorite = true
                            }])
                        
                    }else{
                        if resultinfo.message.isEmpty {
                            self.enableFavorite = true
                        } else {
                            popupManager.showAlert(content: resultinfo.message, buttonTitles: [I18N.ui_ok.localized], buttonActions: [{
                                self.enableFavorite = true
                                }])
                        }
                    }
                    popupManager.hideLoadingView()
                }
            }
            
            popupManager.showLoadingView()
            userInfo.checkLoginStatus(finished: {
                favoriteProcess()
                popupManager.hideLoadingView()
            }, failed: {
                popupManager.hideLoadingView()
            })
            
        }
        
        enableFavorite = true
        
        self.setBarRightButton(with: [info])
    }

    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
	
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Logout
    override func didLogOut(_ notification: NSNotification) {
        dispatchMain.async {
            self.navigationController?.popToRootViewController(animated: false)
        }
    }
    
    //MARK: - UI 
    func updateContentView(){
        self.profileImageView.sd_setImage(with: URL(string:mc.pFileName), placeholderImage: basicLogoImage)
//        self.nicknameLabel.text = mc.nickname // move setBarTitle
        rankLabel.text = fanMC.rank + I18N.ui_numOfRank.localized
        
        fanCntLabel.text = CellUtil.getNumberCommaFormat(text: "\(fanMC.fanCount)") + I18N.ui_numOfPerson.localized
        favorCntLabel.text = CellUtil.getNumberCommaFormat(text: "\(fanMC.favorCount)") + I18N.ui_numOfPerson.localized
        fanLevelLabel.text = fanMC.fanLevel.stringValue()
        fanLevelImage.image = fanMC.fanLevel.iconImage()
        self.baseNavi?.customBar.rightButtons[0].isSelected = fanMC.isFavored
    }
    
    //MARK: - Load Data
    
    /// Load FanMCInfo
    func loadFanMCInfo(){
        guard userInfo.isLogined else {
            return
        }
        
        connection.loadFanMCInfo(mcID: mc.signID, mcPartnerCode: mc.partnerCode) { (succeed, fanMCInfo, resultInfo) in
            if succeed {
                self.fanMC = fanMCInfo
                dispatchMain.async {
                    self.updateContentView()
                }
            }
        }
    }
    
    /// Load FanList
    func loadFanList(){
        userInfo.checkLoginStatus(finished: {
            popupManager.showLoadingView()
            connection.loadFanList(mcID: self.mc.signID, mcPartnerCode: self.mc.partnerCode, rankType: 0) { (succeed, fanList, resultInfo) in
                if succeed {
                    self.fanList = fanList
                    dispatchMain.async {
                        self.tableView.reloadData()
                    }
                }
                popupManager.hideLoadingView()
            }
        })
    }
    
    // MARK: - PUSH Event handler
    override func openBroadcastStart(_ notification: NSNotification) {
        self.pushBroadcastStart(notification: notification)
    }
}

extension MCInfoViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.fanList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row >= fanList.count {
            return UITableViewCell()
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MCFanInfoCell") as? MCFanInfoCell {
            cell.setInfo(fan: fanList[indexPath.row], nickColor: #colorLiteral(red: 0.39138484, green: 0.3913947642, blue: 0.3913894296, alpha: 1))
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
