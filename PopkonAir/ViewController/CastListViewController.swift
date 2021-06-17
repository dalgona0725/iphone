//
//  CastListViewController.swift
//  PopkonAir
//
//  Created by Steven on 20/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class CastListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var liveList : [CastInfo] = []
    
    var currentPage : Int = 0
    var totalPage   : Int = 1
    
    let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.register(UINib(nibName: "CategoryListTableCell", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: "CategoryListTableCell")
        
        self.tableView.register(UINib(nibName: "CeluvSearchCell", bundle: Bundle(for: type(of: self))), forCellReuseIdentifier: "CeluvSearchCell")
        
        //Refresh
        refreshControl.attributedTitle = NSAttributedString(string: I18N.ui_pullRefresh.localized)
        refreshControl.addTarget(self, action: #selector(self.reload), for: .valueChanged)
        
        self.tableView.addSubview(refreshControl)
        self.tableView.separatorStyle = .none
        
        self.reload()
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
    //override
    func loadData(page : Int) {
        
    }
    
    @objc func reload(){
        currentPage = 0
        liveList = []
        
        self.tableView.reloadData()
        
        loadData(page: 1)
    }
    
    func select(cast : CastInfo) {
        if cast.isAdult {
            if self.needUserCertification() {
                self.gotoUserCertWeb()
                return
            }
        }
        self.watchBroadcast(of: cast)
    }
    
    override func didLogOut(_ notification: NSNotification) {
        self.reload()
    }

}

extension CastListViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.liveList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row >= liveList.count {
            return UITableViewCell()
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryListTableCell") as? CategoryListTableCell {
            cell.setInfo(cast: liveList[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.select(cast: liveList[indexPath.row])
    }
    
    /// 페이징 처리
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == liveList.endIndex - 1 {
            if currentPage < self.totalPage {
                self.loadData(page: self.currentPage+1)
            }
        }
    }
    
}
