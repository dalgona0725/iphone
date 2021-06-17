//
//  NewsViewController.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 21/08/2019.
//  Copyright © 2019 The E&M. All rights reserved.
//

import UIKit

class NewsViewController: BaseViewController {
	
	private var newsList: [NewsInfo] = [] {
		didSet {
			dispatchMain.async {
				self.tableView.reloadData()
			}
		}
	}
	
	private var currentPage  = 1
	private var totalPage	 = 1
	private var totalListNum = 0
	
	private let refreshControl = UIRefreshControl()
	
	@IBOutlet private weak var tableView: UITableView!
	@IBOutlet private weak var indicator: UIActivityIndicatorView!
	
	override func viewDidLoad() {
        super.viewDidLoad()

        self.navibarType = .vod
		
		setupTableView()
		
		loadData() {
			dispatchMain.async {
				self.indicator.stopAnimating()
			}
		}
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setBarTitle(with: "News")
        setupNavigationBarDefault()
		
		if newsList.count == 0 {
			self.tableView.reloadData()
			return
		}
		
		if tableView.contentOffset.y < 0 {
		  tableView.contentOffset = .zero
		}
    }
	
	private func setupTableView() {
		tableView.delegate = self
		tableView.dataSource = self
		tableView.register(NewsCell.nib, forCellReuseIdentifier: NewsCell.identifier)
		
		refreshControl.addTarget(self, action: #selector(self.pullToReload), for: .valueChanged)
		tableView.refreshControl = refreshControl
	}
	
	private func loadData(finished:@escaping ()-> Void) {
//        popupManager.showLoadingView()
        self.setTableViewScrollEnable(on: false)
		connection.loadNewsList(pageNum: currentPage) { (succeed, list, resultInfo) in
			if succeed {
				self.newsList = list
				self.totalPage = resultInfo.totalPageNum
				self.totalListNum = resultInfo.totalListNum
				finished()
			}
//            popupManager.hideLoadingView()
            self.setTableViewScrollEnable(on: true)
		}
	}
    /// 태이블뷰 스크롤 가능 여부 셋팅
    /// - Note: 태이블뷰 당겨 reload 처리갈 될때 테이블뷰가 여전히 drag가 유지된채 있는데,
    ///         reload시 drag상태를 일시적으로 풀기 위한 용도이다. 끝난뒤에는 다시 true로 해줘야 한다.
    /// - Parameters:
    ///     - on: 스크롤 가능 여부 설정
    func setTableViewScrollEnable(on: Bool) {
        dispatchMain.async {
            self.tableView.isScrollEnabled = on
        }
    }
    
	
	private func loadMoreData() {
		if self.currentPage != self.totalPage {
			self.currentPage += 1
		}
		
		if self.currentPage > 1 {
			connection.loadNewsList(pageNum: currentPage) { (succeed, list, resultInfo) in
				if succeed {
					self.newsList += list
				}
			}
		}
	}
	
	@objc func pullToReload() {
		newsList.removeAll()
		
		currentPage  = 1
		totalPage	 = 1
		totalListNum = 0
		
		loadData {
			dispatchMain.async {
				self.refreshControl.endRefreshing()
			}
		}
	}
}


// MARK: - TableView extension
extension NewsViewController: UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return newsList.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: NewsCell.identifier, for: indexPath) as? NewsCell {
			cell.newsData = self.newsList[indexPath.row]
			return cell
		}
		return UITableViewCell()
	}
}

extension NewsViewController: UITableViewDelegate {
	func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		if indexPath.row == newsList.endIndex - 1 {
			if newsList.count < self.totalListNum {
				loadMoreData()
			}
		}
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)

		if let url = URL(string: newsList[indexPath.row].link) {
			if UIApplication.shared.canOpenURL(url) {
				UIApplication.shared.open(url)
			}
		}
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 110.0
	}
	
	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
	
	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return CGFloat.leastNormalMagnitude
	}
	
}

