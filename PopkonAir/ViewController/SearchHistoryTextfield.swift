//
//  SearchHistoryTextfield.swift
//  PopkonAir
//
//  Created by Brian Park on 2020/06/08.
//  Copyright © 2020 The E&M. All rights reserved.
//

import UIKit

protocol SearchHistoryDelegate: class {
    func searchAction()
}

protocol SearchTextFieldDelegate: class {
    func setSearchRightCloseButton()
}

class SearchHistoryTextfield: UITextField {
    
    weak var searchDelegate: SearchHistoryDelegate?
    weak var textfieldDelegate: SearchTextFieldDelegate?

    private lazy var tableView: UITableView = {
        let tv = UITableView(frame: CGRect.zero)
        tv.layer.masksToBounds = true
        tv.separatorInset = .zero
        tv.separatorColor = .lightGray
        tv.backgroundColor = .white
        tv.setLayerOutLine(borderWidth: 0.5, cornerRadius: 15, borderColor: UIColor.black.withAlphaComponent(0.1))
        tv.register(SearchTextFieldCell.nib, forCellReuseIdentifier: SearchTextFieldCell.identifier)
        tv.register(SearchHistoryFooterView.nib, forHeaderFooterViewReuseIdentifier: SearchHistoryFooterView.identifier)
        tv.rowHeight = 44
        tv.delegate = self
        tv.dataSource = self
        tv.isHidden = true
        return tv
    }()
    
    override open func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        self.addTarget(self, action: #selector(SearchHistoryTextfield.textFieldDidChange), for: .editingChanged)
        self.addTarget(self, action: #selector(SearchHistoryTextfield.textFieldDidBeginEditing), for: .editingDidBegin)
        self.addTarget(self, action: #selector(SearchHistoryTextfield.textFieldDidEndEditing), for: .editingDidEnd)
        self.addTarget(self, action: #selector(SearchHistoryTextfield.textFieldDidEndEditingOnExit), for: .editingDidEndOnExit)
    }
    
    // Mark : -Text Field related methods
    @objc
    open func textFieldDidChange() {
        reloadTableview()
        print("Begin DidChange")
    }
    
    @objc
    open func textFieldDidBeginEditing() {
        reloadTableview()
        print("Begin Editing")
    }
    
    @objc
    open func textFieldDidEndEditing() {
        tableView.isHidden = true
        print("End editing")
    }
    
    @objc
    open func textFieldDidEndEditingOnExit() {
        self.search()
        tableView.isHidden = true
        print("End on Exit")
    }
    
    private func search() {
        searchDelegate?.searchAction()
    }
    
    private func changeTextFieldRightButton() {
        textfieldDelegate?.setSearchRightCloseButton()
    }
    
    func disappearSearchVC() {
        dispatchMain.async {
            self.tableView.isHidden = true
        }
    }
    
    func reloadTableview() {
        if !isFirstResponder {
            tableView.isHidden = true
            return
        }
        
        if let text = self.text {
            if text != "" {
                realmManager.filterBy(content: text)
            } else {
                realmManager.sortByTime()
            }
        }

        let cnt = realmManager.searchData?.count ?? 0
        
        tableView.reloadData()
        dispatchMain.async {
            self.updateSearchTableView()
            self.tableView.isHidden = cnt == 0
        }
    }
}


extension SearchHistoryTextfield: UITableViewDelegate, UITableViewDataSource {
    // MARK: TableView creation and updating
    
    /// Create SearchTableview
    func buildSearchTableView() {
        self.window?.addSubview(tableView)
        updateSearchTableView()
    }
    
    /// Updating SearchtableView
    func updateSearchTableView() {
        superview?.bringSubviewToFront(tableView)
        var tableHeight = tableView.contentSize.height
        
        let deviceHeight = UIScreen.main.bounds.size.height * 0.45
        
        if tableHeight > deviceHeight {
            tableHeight = deviceHeight
        }
        
        /// Set tableView frame
        let x: CGFloat = 2
        let y: CGFloat = frame.size.height + 9
        var tableViewFrame = CGRect(x: x, y: y, width: frame.size.width, height: tableHeight)
        tableViewFrame.origin = self.convert(tableViewFrame.origin, to: nil)
        UIView.animate(withDuration: 0.25, animations: { [weak self] in
            guard let sf = self else { return }
            sf.tableView.frame = tableViewFrame
        })

        if self.isFirstResponder {
            superview?.bringSubviewToFront(self)
        }
        tableView.reloadData()
    }
    
    
    // MARK: TableViewDataSource methods
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cnt = realmManager.searchData?.count else { return 0 }
        return cnt
    }
    
    // MARK: TableViewDelegate methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: SearchTextFieldCell.identifier, for: indexPath) as? SearchTextFieldCell {
            if let db = realmManager.searchData?[indexPath.row] {
                cell.searchDB = db
            }
            cell.deleteBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(tapDeleteBtn(_:)), for: .touchUpInside)
            return cell
        }
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let db = realmManager.searchData?[indexPath.row] {
            self.text = db.content
            self.changeTextFieldRightButton()
            self.search()
        }
        tableView.isHidden = true
        self.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if let footer = tableView.dequeueReusableHeaderFooterView(withIdentifier: SearchHistoryFooterView.identifier) as? SearchHistoryFooterView {
            return footer
        }
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let cnt = realmManager.searchData?.count else {
            return CGFloat.leastNormalMagnitude
        }
        return cnt > 0 ? 40 : CGFloat.leastNormalMagnitude
    }
    
}

/// 삭제 이벤트
extension SearchHistoryTextfield {
    @objc
    private func tapDeleteBtn(_ sender: UIButton ) {
        if let db = realmManager.searchData?[sender.tag] {
            realmManager.removeSearchData(id: db.id)
            deleteAction()
        }
    }
    
    private func deleteAction() {
        self.tableView.reloadData()
        
        let cnt = realmManager.searchData?.count ?? 0
        if cnt == 0 {
            self.tableView.isHidden = true
            return
        }
        
        dispatchMain.async {
            self.updateSearchTableView()
        }
    }
}
