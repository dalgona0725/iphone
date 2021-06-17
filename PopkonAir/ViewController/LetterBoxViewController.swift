//
//  LetterBoxViewController.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 5. 11..
//  Copyright © 2018년 eugene. All rights reserved.
//

class LetterBoxViewController : BaseViewController {
    
    @IBOutlet weak var tabView: SJTabView!
    @IBOutlet weak var mailTableView: UITableView!
    @IBOutlet weak var writeButton: UIButton!
    
    var currentMenu : LetterListType = .received
    var papers : [PaperInfo] = []
    
    var currentPage : Int = 0
    var totalPage   : Int = 1
    let refreshControl = UIRefreshControl()
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTabView()
        
        refreshControl.attributedTitle = NSAttributedString(string: I18N.ui_pullRefresh.localized)
        refreshControl.addTarget(self, action: #selector(self.reload), for: .valueChanged)
        let bundle = Bundle(for: type(of: self))
        self.mailTableView.register(UINib(nibName: "LetterInfoCell", bundle: bundle), forCellReuseIdentifier: "LetterInfoCell")        
        self.mailTableView.register(UINib(nibName: "LetterEmptyCell", bundle: bundle), forCellReuseIdentifier: "LetterEmptyCell")
        self.mailTableView.register(UINib(nibName: "LetterHeaderView", bundle: bundle), forHeaderFooterViewReuseIdentifier: "LetterHeaderView")
        
        
        self.mailTableView.separatorStyle = .singleLine
        self.mailTableView.delegate = self
        self.mailTableView.dataSource = self
        
        self.mailTableView.addSubview(refreshControl)
        
        var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(recognizer:)))
        swipeGesture.direction = .right
        self.mailTableView.addGestureRecognizer(swipeGesture)
        
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(recognizer:)))
        swipeGesture.direction = .left
        self.mailTableView.addGestureRecognizer(swipeGesture)
        
        writeButton.bringSubviewToFront(mailTableView)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setBarTitle(with: I18N.text_letterPost.localized)
        self.reload()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabView.needResetOnLayoutSubvies = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - User Log out
    override func willLogOut() {
    }
    override func didLogOut(_ notification: NSNotification) {
        tabView.selectTabButton(index: 0)
    }
    
    //MARK: - Setup UI
    private func setupTabView() {
        
        let menuArr = [I18N.text_receivedLetter.localized,I18N.text_sendLetter.localized]
        var buttonInfos : [SJTabButtonInfo] = []
        for (index, title) in menuArr.enumerated() {
            var buttonInfo = SJTabButtonInfo()
            buttonInfo.font = UIFont.notoBoldFont(ofSize: 16)
            buttonInfo.title = title
            buttonInfo.titleColor = catergoryTextColor
            buttonInfo.titleColorSelected = catergorySelectedTextColor
            buttonInfo.actionHandler = { sender in 
                if let type = LetterListType(rawValue: index) {
                    self.currentMenu = type
                    self.reload()
                }
            }
            buttonInfos.append(buttonInfo)
        }
        
        tabView.buttonInfos = buttonInfos
        tabView.enableSelected = true
        tabView.selectedIndex = 0
        tabView.numOfItemsShown = menuArr.count
        tabView.setup()
    
    }
    
    //MARK: - Load Data
    func loadList(page: Int) {
        if userInfo.isLogined == false {
            return
        }
        
        popupManager.showLoadingView()
        connection.getPaperList(pageNum: page, command: currentMenu) { (succeed, list, resultInfo) in
            if succeed {
                self.totalPage = resultInfo.totalPageNum
                if self.currentPage < resultInfo.pageNum {
                    self.currentPage = resultInfo.pageNum
                    self.papers.append(contentsOf: list)
                }
                
                dispatchMain.async {
                    self.mailTableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
            } else {
                dispatchMain.async {
                    self.refreshControl.endRefreshing()
                }
            }
            popupManager.hideLoadingView()
        }
    }
    
    @objc
    func reload() {
        currentPage = 0
        papers = []
        
        //self.mailTableView.reloadData()
        
        loadList(page: 1)
    }
    
    @IBAction func writeLetterAction(_ sender: Any) {
        dispatchMain.async {
            let writeVC = self.viewController(storyboard: "Letter", identifier: "LetterWriteViewController") as! LetterWriteViewController
            self.navigationController?.pushViewController(writeVC, animated: true)
        }
    }
    
    //MARK: - Gesture Handling
    @objc
    func handleSwipeGesture(recognizer: UISwipeGestureRecognizer) {
        var bNext = true
        if recognizer.direction == .right {
            bNext = false;
        } else if recognizer.direction == .left {
            bNext = true;
        }
        moveCategory(toNext: bNext)
    }
    
    private func moveCategory(toNext: Bool) {
        var index = currentMenu.rawValue
        if toNext {
            if index + 1 >= 2 {
                return
            }
            index = index + 1
            
        } else {
            if index == 0 {
                return
            }
            index = index - 1
        }
        tabView.selectTabButton(index: index)
    }
}

extension LetterBoxViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if papers.count > 0 {
            return papers.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if papers.isEmpty {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "LetterEmptyCell",for:indexPath) as? LetterEmptyCell {
                return cell
            }
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "LetterInfoCell",for:indexPath) as? LetterInfoCell {
            if papers.isEmpty {
                cell.setText(text: I18N.text_noLetter.localized)
            } else {
                cell.setLetterType(isReceived: currentMenu == .received )
                cell.setInfo(paper: papers[indexPath.row])
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if papers.isEmpty {
            return
        }
        
        popupManager.showLoadingView()
        let getPaperProcess : () -> Void = {
            let item = self.papers[indexPath.row]
            let command = self.currentMenu == .received ? LetterReadType.received : LetterReadType.sent
            
            connection.getPaperDetail(paperID: item.code, command: command) { (succeed, paperInfo, resultInfo) in
                popupManager.hideLoadingView()
                if succeed {
                    dispatchMain.async {
                        let detailVC = self.viewController(storyboard: "Letter", identifier: "LetterDetailViewController") as! LetterDetailViewController
                        detailVC.setInfo(info: paperInfo, type: command, isAdmin:  item.accountLevel == .administrator )
                        self.navigationController?.pushViewController(detailVC, animated: true)
                    }
                }
            }
        }
        
        userInfo.checkLoginStatus(finished: {
            dispatchMain.async {
                getPaperProcess()
            }
        }, failed: {
            popupManager.hideLoadingView()
            dispatchMain.async {
                if let navigator = self.navigationController {
                    navigator.popViewController(animated: true)
                }
            }
        })
        
    }
    
    //MARK: - TableView Header
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let cell = tableView.dequeueReusableHeaderFooterView(withIdentifier: "LetterHeaderView") as? LetterHeaderView {
            
            cell.setLetterType(isReceived: currentMenu == .received )
            
            return cell
        }
        return nil
    }
    
    /// 페이징 처리
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == papers.endIndex - 1 {
            if self.currentPage < self.totalPage {
                self.loadList(page: self.currentPage + 1)
            }
        }
    }
}
