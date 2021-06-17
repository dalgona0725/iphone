//
//  CastCollectionViewController.swift
//  PopkonAir
//
//  Created by Steven on 31/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class CastCollectionViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var castList1   : [CastInfo] = []
    var castList2   : [CastInfo] = []
    
    var headerTitles : [String] = []
    
    let identifier = "CellIdentifier"
    let headerViewIdentifier = "HeaderView"
    
    var enableWatchCast = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        collectionView.delegate = self
        collectionView.dataSource = self
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
    
    //MARK: - Private Function
    
    //MARK: Goto ChatVC(watch cast view)
    /// Goto ChatVC(watch cast view)
    func gotoWatchCast(indexPath : IndexPath)
    {
        let castInfo = (indexPath.section==0 ? self.castList1[indexPath.row] : self.castList2[indexPath.row])
        
        // 19금방송일경우 본인인증 체크.
        if castInfo.isAdult {
            if self.needUserCertification() {
                self.gotoUserCertWeb()
                return
            }
        }
        
        if self.enableWatchCast {
            self.enableWatchCast = false
            
            self.watchBroadcast(of: castInfo) {
                self.enableWatchCast = true
            }
        }
    }

    func loadData() {
        
    }
    
    func reloadData() {
        self.castList1 = []
        self.castList2 = []
        self.collectionView.reloadData()
        
        self.loadData()
    }
    
    
    override func didLogOut(_ notification: NSNotification) {
        self.reloadData()
    }
}

extension CastCollectionViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var count = 0
        
        if castList1.count>0 {
            count += 1
        }
        
        if castList2.count>0 {
            count += 1
        }
        
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print(section)
        var rtCnt: Int = 0
        if section == 0{
            rtCnt = castList1.count
        }else if section == 1{
            rtCnt = castList2.count
        }
        
        return rtCnt
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,for:indexPath) as! MainLiveViewCell
        
        //print((indexPath as NSIndexPath).section)
        if (indexPath as NSIndexPath).section == 0{
            if castList1.count > 0 {
                let homeLive = castList1[(indexPath as NSIndexPath).row]
                
                cell.setInfo(cast: homeLive)
            }
        }else{
            if castList2.count > 0 {
                let cast = castList2[(indexPath as NSIndexPath).row]
                
                cell.setInfo(cast: cast)
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let headerView: MainLiveViewHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerViewIdentifier, for: indexPath) as! MainLiveViewHeader
        
        if headerTitles.count>indexPath.section {
            headerView.sectionLabel.text = headerTitles[indexPath.section]
        }else {
            headerView.sectionLabel.text = ""
        }
        
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {        
        let length = (UIScreen.main.bounds.width-30)/2
        return CGSize(width: length ,height: (length * 3/4) + 36);
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //print((indexPath as NSIndexPath).row)
        
        if false == userInfo.isLogined {
    
            self.showLoginIfNeed {
                self.updateUserCoin { succeed in
                    self.gotoWatchCast(indexPath: indexPath)
                }
            }
            
        }else{
            
            self.gotoWatchCast(indexPath: indexPath)
            
        }
    }
}
