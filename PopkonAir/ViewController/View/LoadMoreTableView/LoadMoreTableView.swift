//
//  LoadMoreTableView.swift
//  PopkonAir
//
//  Created by Steven on 27/12/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
//import UpLoadMoreControl

enum LoadMoreTableViewStatus {
    ///show list
    case normal
    ///show no result label
    case noResult
    ///show logo
    case empty
}

class LoadMoreTableView: UIView {
    
    var status : LoadMoreTableViewStatus = .empty {
        didSet {
            updateDisplay()
        }
    }
    var dataSource : [AnyObject] = []
    
    var currentPage : Int = 0
    var totalPage   : Int = 1
    
    let refreshControl = UIRefreshControl()
//    var loadMoreControl = UpLoadMoreControl()
    
    var onSelect : (_ data : AnyObject) -> Void = {data in}
    var onLoadData : (_ page : Int, _  completed : @escaping ()->Void) -> Void = {page, completed in}
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
    }
    
    
    private func initFromXIB() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "LoadMoreTableView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        
        self.addSubview(contentView)
        
        
        refreshControl.attributedTitle = NSAttributedString(string: I18N.ui_pullRefresh.localized)
        refreshControl.addTarget(self, action: #selector(self.reload), for: .valueChanged)
        
        //Load More
//        loadMoreControl = UpLoadMoreControl(scrollView: self.tableView) { (control) in
//            log.debug("load more")
//            log.debug(control.debugDescription)
//
//            self.loadData(page: self.currentPage+1)
//        }
        
        self.tableView.addSubview(refreshControl)
//        self.tableView.addSubview(loadMoreControl)
        self.tableView.separatorStyle = .none
        
        self.tableView.register(UINib(nibName: "CategoryListTableCell", bundle: bundle), forCellReuseIdentifier: "CategoryListTableCell")
        self.tableView.register(UINib(nibName: "MCInfoTableCell", bundle: bundle), forCellReuseIdentifier: "MCInfoTableCell")
        
        self.status = .empty
		
		noResultLabel.text = I18N.text_no_search_content.localized
    }

    
    func updateDisplay() {
        
        dispatchMain.async {
            switch self.status {
            case .normal:
                self.tableView.isHidden = false
                self.noResultLabel.isHidden = true
                self.logoImageView.isHidden = true
            case .noResult:
                self.tableView.isHidden = true
                self.noResultLabel.isHidden = false
                self.logoImageView.isHidden = true
            case .empty:
                self.tableView.isHidden = true
                self.noResultLabel.isHidden = true
                self.logoImageView.isHidden = false
            }
        }
    }
    
    
    @objc func reload(){
        currentPage = 0
        dataSource = []
        
        self.tableView.reloadData()
        
        loadData(page: 1)
    }
    
    func loadData(page : Int) {
        let completed = {
            dispatchMain.async {
                
                if self.dataSource.count > 0 {
                    self.status = .normal
                }else {
                    self.status = .noResult
                }
                
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
//                self.loadMoreControl.finishedLoading(withStatus: "Finished Load", delay: 1.0)
//                
//                if self.totalPage <= self.currentPage {
//                    if self.loadMoreControl.superview != nil {
//                        self.loadMoreControl.removeFromSuperview()
//                    }
//                }else {
//                    if self.loadMoreControl.superview == nil {
//                        self.tableView.addSubview(self.loadMoreControl)
//                    }
//                }
            }
        }
        onLoadData(page,completed)
    }
    
    
}

extension LoadMoreTableView : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = dataSource[indexPath.row]
        
        if data is CastInfo {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListTableCell") as? CategoryListTableCell {
                cell.setInfo(cast: data as! CastInfo)
                
                return cell
            }
            
        }else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "MCInfoTableCell") as? MCInfoTableCell {
                cell.setInfo(mc: data as! MCInfo)
                
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.onSelect(dataSource[indexPath.row])
//        self.select(cast: liveList[indexPath.row])
    }
}


extension LoadMoreTableView : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if totalPage > currentPage {
//            loadMoreControl.scrollViewDidScroll()
        }
        
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if totalPage > currentPage {
//            loadMoreControl.scrollViewDidEndDragging()
        }
    }
}
