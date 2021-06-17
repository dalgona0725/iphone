//
//  CategoryListViewController.swift
//  PopkonAir
//
//  Created by Steven on 14/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//
// 현재 사용하지 않음.

import UIKit

class CategoryListViewController: CastListViewController {

    public var category : CategoryInfo = CategoryInfo()
    
    var sortBy : CastSortBy = .viewCount
    
    //미리보기
    @IBOutlet weak var preView: CastPreView!
    @IBOutlet weak var previewTopConstraint: NSLayoutConstraint!
    
    //Category TabView
//    @IBOutlet weak var categoryView: CategoryTabView!
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        log.debug("category : \(self.category)")
        
//        categoryView.setSelected(category: category)
//        
//        categoryView.categoryAction = {
//            category in
//            self.category = category
//            
//            self.reload()
//        }
        
        //Preview swipe handler
        
        preView.onSwipeHandler = {x in
            
            let alpha = min(1, x/(UIScreen.main.bounds.width/2))
            
            self.preView.alpha = 1 - alpha
            self.tableViewTopConstraint.constant = -(previewHeight * alpha)
            self.view.layoutIfNeeded()
            
        }
        
        preView.onSwipeAnimationFinishedHandler = {
            self.preView.alpha = 1
            self.tableViewTopConstraint.constant = 0
            self.previewTopConstraint.constant = -previewHeight
            
            self.view.layoutIfNeeded()
        }
        
        preView.onTapHandler = {
            (cast , castMember) in
            
            self.showWatchCastVC(cast: cast, castMember: castMember)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.reload()
        
        self.setBarTitle(with: I18N.ui_liveCast.localized)
        self.setBarRoundTitle(with: sortBy.stringValue(), controlState: .normal)
        
        self.setBarAction(round: {
            sender in
    
            switch self.sortBy {
            case .viewCount:
                self.sortBy = .latest
                break
            case .latest:
                self.sortBy = .hotest
                break
            case .hotest:
                self.sortBy = .viewCount
                break
            }
            
            dispatchMain.async {
                self.reload()
                sender.setTitle(self.sortBy.stringValue(), for: .normal)
            }
            
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.hidePreview()
        self.preView.unsetup()
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
    
    //MARK: - UI
    private func showPreview() {
        UIView.animate(withDuration: 0.25) {
            self.previewTopConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    
    private func hidePreview() {
        UIView.animate(withDuration: 0.25) {
            self.previewTopConstraint.constant = -120
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Load Data
    override func loadData(page : Int) {
        
        //log.debug("\n\nLoad page : \(page)\n\n")
        connection.loadCastList(category: category.code,
                                pageNum: page,
                                sort: sortBy)
        { (succeed, liveList, resultInfo) in
            
            if succeed {
                self.totalPage = resultInfo.totalPageNum
                //After Loading Finished, update current Page num
                if self.currentPage < page {
                    
                    self.currentPage = page
                    
                    self.liveList.append(contentsOf: liveList)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            } else {
                self.refreshControl.endRefreshing()
            }
            
        }
    }
    
    //MARK: - UITableViewDatasource
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row >= liveList.count {
            return UITableViewCell()
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListTableCell") as? CategoryListTableCell {
            cell.setInfo(cast: liveList[indexPath.row])
            cell.previewAction = {
                sender in
                
                if userInfo.isLogined {
                    self.showPreviewAction(cast: cell.cast)
                }else {
                    self.showLoginVC(complete: {succeed in
                        if succeed {
                            self.showPreviewAction(cast: cell.cast)
                        }
                    } )
                }
            }

            return cell
        }
        return UITableViewCell()
    }
    
    /// 페이징 처리
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == liveList.endIndex - 1 {
            if self.currentPage < self.totalPage {
                self.loadData(page: self.currentPage + 1)
            }
        }
    }
    
    //MARK: - private
    private func showPreviewAction(cast : CastInfo){
        popupManager.showLoadingView()
        userInfo.checkLoginStatus(finished: {
            connection.sendWatchCast(castInfo: cast, commandType: .start, complete: { (succeed, memberInfo, resultInfo) in
                if succeed {
//                    log.debug("sendWatchCast Succeed")
//                    log.debug("gotoWatchCast")
                    dispatchMain.async {
                        self.showPreview()
                        self.preView.setup(with: cast, castMember: memberInfo)
                    }
                }else {
                    
                }
                popupManager.hideLoadingView()
            })
        }, failed: {
            popupManager.hideLoadingView()
        })
    }

}
