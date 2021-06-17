//
//  FavoriteCastViewController.swift
//  PopkonAir
//
//  Created by Steven on 31/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

public enum FavoriteBrocastStatus : Int {
    case airOn  = 0
    case airOff
}

class FavoriteCastViewController: CastCollectionViewController {
    
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout!
    
    let refreshControl = UIRefreshControl()
    var currentPage : Int = 0
    var totalPage   : Int = 1
    var webEventView : EventWebView? = nil
    
    private var isEditMode : Bool = false
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isEditMode = false
        
        if userInfo.isLogined {
            self.reloadData()
        } else {
            self.navigationController?.tabBarController!.selectedIndex = 0
        }

        setupNaviBar()
        
        // register Push Notification
        NotificationCenter.default.addObserver(self, selector: #selector(openEventWebView(_:)), name: NSNotification.Name(rawValue: kPushShowEventView), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openBroadcastStart(_:)), name: NSNotification.Name(rawValue: kPushBroadStart), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(openExternalLinkurl(_:)), name: NSNotification.Name(rawValue: kPushLinkOut), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // unregister Push Notification
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kPushShowEventView), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kPushBroadStart), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kPushLinkOut), object: nil)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateFlowLayout() {
        let length = (UIScreen.main.bounds.width-30)
        flowLayout.itemSize = CGSize(width: length/2 ,height: ((length/2) * 3/4) + 36);
    }

    // MARK:- Layout
     private func setupNaviBar() {
        self.setBarTitle(with: I18N.ui_favorite.localized)
        self.setBarRoundTitle(with: I18N.ui_edit.localized, controlState: .normal)
        self.setBarAction(round: { (sender) in
            self.isEditMode = !self.isEditMode
            
            let title = self.isEditMode ? I18N.ui_editDone.localized : I18N.ui_edit.localized

            dispatchMain.async {
                self.collectionView.reloadData()
                self.setBarRoundTitle(with: title, controlState: .normal)
            }
        })
     }
     
     private func setupLayout() {
         emptyLabel.text = I18N.err_noFavorite.localized
         emptyLabel.isHidden = true
         headerTitles = [I18N.ui_onAir.localized, I18N.ui_offAir.localized]
         
         setupCollectionView()
     }
     
     private func setupCollectionView() {
         collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
         collectionView.alwaysBounceVertical = true
         collectionView.register(UINib(nibName: "FavoriteCastCell", bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: "FavoriteCastCell")
         refreshControl.attributedTitle = NSAttributedString(string: I18N.ui_pullRefresh.localized)
         refreshControl.addTarget(self, action: #selector(self.reloadData), for: .valueChanged)
         collectionView.addSubview(refreshControl)
     }

    //MARK: - Load Data
    @objc override func reloadData() {
        currentPage = 0
        self.castList1 = []
        self.castList2 = []
        self.collectionView.reloadData()
        
        self.loadData(page: 1)
    }
    
    func loadData(page : Int) {
        userInfo.checkLoginStatus(finished: {
            dispatchMain.async {
                connection.loadFavoriteCastList(pageNum: page, complete: { (succeed, castList, resultInfo) in
                    if succeed {
                        self.totalPage = resultInfo.totalPageNum
                        if self.currentPage < resultInfo.pageNum {
                            self.currentPage = page
                            for cast in castList {
                                if cast.castStatus == .off {
                                    self.castList2.append(cast)
                                } else {
                                    self.castList1.append(cast)
                                }
                            }
                        }
                        
                        dispatchMain.async {
                            self.showEmptyLabel()
                            self.refreshControl.endRefreshing()
                            self.collectionView.reloadData()
                        }
                        
                    } else {
                        //log.debug("Load Live Data Failed")
                        dispatchMain.async {
                            self.refreshControl.endRefreshing()
                            self.collectionView.reloadData()
                        }
                    }
                })
            }
        }, failed: {
            popupManager.hideLoadingView()
        })
    }

    override func didLogOut(_ notification: NSNotification) {
        if webEventView != nil {
            webEventView!.removeFromSuperview()
            webEventView = nil
        }
        
        /*
        dispatchMain.async {
            self.navigationController?.tabBarController!.selectedIndex = 0
        } */
    }
    
    private func showEmptyLabel() {
        let bool = self.castList1.count == 0 && self.castList2.count == 0
        emptyLabel.isHidden = !bool
        collectionView.isHidden = bool
        setHiddenNaviRoundButton(bool)
    }
    
    //MARK: - Push Notifiacation Event
    override func openEventWebView(_ notification: NSNotification) {
        if appData.hasPushData() {
            if let _ = webEventView {
                //appData.pushDataInfo.reset()
                return
            }
            
            let linkurl = appData.pushDataInfo.webLinkUrl
            dispatchMain.async {
                let eventView = EventWebView(frame: self.mainWindow.bounds)
                eventView.setup(linkUrl: linkurl)
                eventView.onCloseView = {
                    self.webEventView = nil
                }
                //self.view.addSubview(eventView)
                self.mainWindow.rootViewController?.view.addSubview(eventView)
                self.webEventView = eventView
            }
            
            appData.pushDataInfo.reset()
        }
        
    }
    override func openBroadcastStart(_ notification: NSNotification) {
        self.pushBroadcastStart(notification: notification)
    }
    override func openExternalLinkurl(_ notification: NSNotification) {
        if appData.hasPushData() {
            appData.pushDataInfo.reset()
        }
    }
    
    //MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavoriteCastCell",for:indexPath) as! FavoriteCastCell
        
        cell.isEditing = self.isEditMode

        //print((indexPath as NSIndexPath).section)
        if (indexPath as NSIndexPath).section == 0{
            if castList1.count > 0 {
                let cast = castList1[(indexPath as NSIndexPath).row]
                
                cell.setInfo(cast: cast)
            }
        }else{
            if castList2.count > 0 {
                let cast = castList2[(indexPath as NSIndexPath).row]
                
                cell.setInfo(cast: cast)
            }
        }
        
        cell.deleteAction = { cast in
            
            if let cellIndexPath = collectionView.indexPath(for: cell) {
                
                popupManager.showAlert(content: String(format: I18N.favorite_deleteMC.localized, cast.nickName), buttonTitles: [I18N.ui_ok.localized,I18N.ui_cancel.localized], buttonActions: [{
                    self.deleteFavoriteCast(cast: cast, indexPath: cellIndexPath)
                    },{}])
            }
        }
        
        return cell
    }
    
    private func deleteFavoriteCast(cast : CastInfo, indexPath : IndexPath) {
        
        popupManager.blurView.dontDestory = true
        popupManager.showLoadingView()
        userInfo.checkLoginStatus(finished: {
            
            dispatchMain.async {
                popupManager.showLoadingView()
                connection.sendFavoriteCast(castID:cast.castSignId, castPartnerCode: cast.castPartnerCode, dataType: .remove, complete: { (succeed, resultInfo) in
                    if succeed {
                        
                        if indexPath.section == 0 {
                            self.castList1.remove(at: indexPath.row)
                        } else {
                            self.castList2.remove(at: indexPath.row)
                        }
                        
                        dispatchMain.async {
                            self.collectionView.deleteItems(at: [indexPath])
                        }
                        self.showEmptyLabel()
                    }
                    popupManager.hideLoadingView()
                })
            }
            
            popupManager.hideLoadingView()
        }, failed: {
            popupManager.hideLoadingView()
        })
    
    }
    
    //MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if false == userInfo.isLogined {
            self.showLoginIfNeed {
                self.updateUserCoin { succeed in
                    self.gotoWatchCast(indexPath: indexPath)
                }
            }
        }else{
            
            if indexPath.section == FavoriteBrocastStatus.airOff.rawValue {
                self.view.makeToast(I18N.err_notCasting.localized)
            } else {
                self.gotoWatchCast(indexPath: indexPath)
            }
        }
    }
    
    /// 페이징 처리
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let endIndex = castList2.count == 0 ? castList1.endIndex : castList2.endIndex
        
        if indexPath.row == endIndex - 1 {
            if currentPage < self.totalPage {
                self.loadData(page: self.currentPage+1)
            }
        }
    }
}

