//
//  SearchViewController.swift
//  PopkonAir
//
//  Created by Steven on 14/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class SearchViewController: CastListViewController {

    @IBOutlet weak var typeView: SJTabView!
    @IBOutlet weak var bgLogoImageView: UIImageView!
    @IBOutlet weak var noResultImageView: UIImageView!
    @IBOutlet weak var noResultLabel: UILabel!
    
    var viewType : SearchViewCategoryType = .liveList
    
    var vodList : [CeluvVODInfo] = []
    
    private var searchText : String = ""
    var textField: SearchHistoryTextfield?
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupLayout()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNaviBar()
        
        if !searchText.isEmpty {
            self.setBarTextField(text: searchText)
        }
        
        refreshControl.endRefreshing()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.baseNavi?.customBar.endEditing(true)
        self.view.endEditing(true)
        if isMovingFromParent {
            self.textField?.disappearSearchVC()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func didLogOut(_ notification: NSNotification) {
//        dispatchMain.async {
//            self.navigationController?.popViewController(animated: true)
//        }
        // 정보 리셋.
        self.searchText = ""
        self.liveList = []
        self.vodList = []
        
        dispatchMain.async {
            self.bgLogoImageView.isHidden = false
            self.noResultImageView.isHidden = true
            self.noResultLabel.isHidden = true
            self.tableView.isHidden = true
        }

    }
    
    //MARK - UI
    private func setupLayout() {
        self.baseNavi?.customBar.delegate = self
        self.navibarType = .search
        typeView.backgroundColor = mainColor
        self.view.backgroundColor = UIColor.white
        self.noResultImageView.isHidden = true
        self.bgLogoImageView.isHidden = false
        self.noResultLabel.isHidden = true
        
        setupGestureRecognizer()
        setupTabView()
        setupTextField()
    }
    
    private func setupTextField() {
        textField = self.baseNavi?.customBar.searchText
        textField?.searchDelegate = self
    }
    
    private func setupTabView() {
		noResultLabel.text = I18N.text_no_search_content.localized
        var buttonInfos : [SJTabButtonInfo] = []
        
        var button = SJTabButtonInfo()
        button.font = UIFont.notoBoldFont(ofSize: 12)
        button.title =  SearchViewCategoryType.liveList.stringValue()
        button.titleColor = catergoryTextColor
        button.titleColorSelected = catergorySelectedTextColor
        button.actionHandler = { sender in
            self.viewType = .liveList
            self.reload()
        }
        buttonInfos.append(button)
        
        button = SJTabButtonInfo()
        button.font = UIFont.notoBoldFont(ofSize: 12)
        button.title =  SearchViewCategoryType.vodList.stringValue()
        button.titleColor = catergoryTextColor
        button.titleColorSelected = catergorySelectedTextColor
        button.actionHandler = { sender in
            self.viewType = .vodList
            self.reload()
        }
        buttonInfos.append(button)
        
        typeView.buttonInfos = buttonInfos
        typeView.enableSelected = true
        typeView.selectedIndex = 0
        typeView.numOfItemsShown = buttonInfos.count
        
        typeView.setup()
    }
    
    func shutdownKeyboard() {
        self.baseNavi?.customBar.searchText.resignFirstResponder()
    }
    
    func backAction() {
        if let navi = self.navigationController {
            self.typeView.unSetup()
            
            self.vodList.removeAll()
            self.liveList.removeAll()
            
            if navi.viewControllers.count>1 {
                navi.popViewController(animated: true)
            }else {
                navi.dismiss(animated: true, completion: {})
            }
        }
    }
    
    private func setupNaviBar() {
        self.setBarTitle(with: "")
        baseNavi?.customBar.setSearchRightCloseButton()
        
        self.setBarAction(back: {
            self.backAction()
        })
    }
    
    //MARK: - Load Data
    override func reload() {
        self.shutdownKeyboard()
        
        if searchText.count >= 2 {
            currentPage = 0
            liveList = []
            vodList = []
            
            self.tableView.reloadData()
            
            loadData(text: searchText, page: 1)
        } else {
            
            dispatchMain.async {
                self.refreshControl.endRefreshing()
            }
            
        }
    }
    
    override func loadData(page : Int) {
        loadData(text: searchText, page: page)
    }

    func loadData(text : String,page : Int) {
        
        let reduced = text.replacingOccurrences(of: " ", with: "")
        if reduced.count < 2 {
//            self.view.makeToast(I18N.err_need2moreCharacters.localized, duration: 1.4, position: .top)
            
            dispatchMain.async {
                self.refreshControl.endRefreshing()
            }
            
            return
        }
        
        if text.count == 0 {
            return
        }
        
        searchText = text
        popupManager.showLoadingView()
        
        if viewType == .liveList {
			connection.searchCastList(text: searchText, pageNum: page, sort: .hotest) { (succeed, list, resultInfo) in
				popupManager.hideLoadingView()
				if succeed {
					self.totalPage = resultInfo.totalPageNum
					//After Loading Finished, update current Page num
					if self.currentPage < page {
						self.currentPage = page
						self.liveList.append(contentsOf: list)
					}
					
					self.updateUIafterLoad()
				}
			}
			
        } else {
			connection.searchVODList(search: searchText, pageNum: page, sort: .latest) { (succeed, vodList, resultInfo) in
				popupManager.hideLoadingView()
				if succeed {
					self.totalPage = resultInfo.totalPageNum
					//After Loading Finished, update current Page num
					if self.currentPage < page {
						self.currentPage = page
						self.vodList.append(contentsOf: vodList)
					}
					self.updateUIafterLoad()
				}
			}
        }
    }
    
    private func updateUIafterLoad() {
        dispatchMain.async {
            
            self.bgLogoImageView.isHidden = true
            self.noResultImageView.isHidden = !self.isEmpty()
            self.noResultLabel.isHidden = !self.isEmpty()
            
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    /// 검색 결과가 없는지 Bool
    private func isEmpty() -> Bool {
        var isEmpty = true
        switch self.viewType {
        case .liveList:
            isEmpty = self.liveList.count > 0 ? false : true
        case .vodList:
            isEmpty = self.vodList.count > 0 ? false : true
        }
        return isEmpty
    }
    
    //MARK: - Gesture Handling
    private func setupGestureRecognizer() {
        var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture(recognizer:)))
        swipeGesture.direction = .right
        tableView.addGestureRecognizer(swipeGesture)
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture(recognizer:)))
        swipeGesture.direction = .left
        tableView.addGestureRecognizer(swipeGesture)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapToHideKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func handleSwipeGesture(recognizer: UISwipeGestureRecognizer) {
        var bNext = true
        if recognizer.direction == .right {
            bNext = false;
        } else if recognizer.direction == .left {
            bNext = true;
        }
        moveCategory(toNext: bNext)
    }
    
    @objc func handleTapToHideKeyboard(_ sender: UITapGestureRecognizer) {
        self.baseNavi?.customBar.endEditing(true)
    }
    
    private func moveCategory(toNext: Bool) {
        if toNext {
            if viewType == .liveList {
                typeView.selectTabButton(index: SearchViewCategoryType.vodList.rawValue)
            }
        } else {
            if viewType == .vodList {
                typeView.selectTabButton(index: SearchViewCategoryType.liveList.rawValue)
            }
        }
    
    }
    
    
    //MARK: - UITabelViewDelegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.viewType {
        case .liveList:
            return liveList.count
        case .vodList:
            return vodList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if viewType == .liveList {
            if indexPath.row >= liveList.count {
                return UITableViewCell()
            }
            
//            if let cell = tableView.dequeueReusableCell(withIdentifier: "CeluvSearchCell") as? CeluvSearchCell {
//                cell.setInfo(cast: liveList[indexPath.row])
//                return cell
//            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListTableCell") as? CategoryListTableCell {
                cell.setInfo(cast: liveList[indexPath.row])
                return cell
            }
        } else if viewType == .vodList {
            if indexPath.row >= vodList.count {
                return UITableViewCell()
            }
            
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CeluvSearchCell") as? CeluvSearchCell {
                cell.setInfo(celuv: vodList[indexPath.row])
                return cell
            }
        }
        
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.baseNavi?.customBar.searchText.resignFirstResponder()
        
        popupManager.showLoadingView()
        userInfo.checkLoginStatus(finished: {
            dispatchMain.async {
                switch self.viewType {
                case .liveList:
                    let cast = self.liveList[indexPath.row]
                    self.select(cast: cast)
                case .vodList:
                    let vod = self.vodList[indexPath.row]
                    self.watchVod(of: vod)
                }
                popupManager.clearAllPopup()
                popupManager.hideLoadingView()
            }
        }, failed: {
            popupManager.hideLoadingView()
            self.backAction()
        })
    }
    
    /// 페이징 처리
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let endIndex = viewType == .liveList ? liveList.endIndex : vodList.endIndex
        
        if indexPath.row == endIndex - 1 {
            if self.currentPage < self.totalPage {
                self.loadData(page: self.currentPage + 1)
            }
        }
    }

}

// MARK:- SearchDelegate
/// 텍스트필드 검색어가 0이면 결과를 숨기고 로고를 보여준다 AOS와 통일
extension SearchViewController: SearchDelegate {
    func hideResult() {
        self.liveList = []
        self.vodList = []
        self.searchText = ""
        self.tableView.reloadData()
        
        dispatchMain.async {
            self.bgLogoImageView.isHidden = false
            self.noResultLabel.isHidden = true
            self.noResultImageView.isHidden = true
        }
    }
}

// MARK:- SearchHistoryDelegate
extension SearchViewController: SearchHistoryDelegate {
    func searchAction() {
        guard let txt = textField?.text else { return }

        if txt.count >= 2 {
            self.searchText = txt
            realmManager.addSearchData(content: self.searchText)
            self.reload()
        } else {
            self.searchText = ""
            self.reload()
            self.view.makeToast(I18N.err_need2moreCharacters.localized, duration: 1.4, position: .center)
        }
        self.reload()
    }
}
