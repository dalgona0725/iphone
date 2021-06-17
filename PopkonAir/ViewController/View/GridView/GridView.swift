//
//  GridView.swift
//  PopkonAir
//
//  Created by Steven on 03/01/2017.
//  Copyright © 2017 roy. All rights reserved.
//

import UIKit

enum CastDisplayType : String {
    case grid   = "0"
    case table  = "1"
}

class GridView: UIView {

    @IBOutlet weak var emptyLabel: UILabel!
    var defaultInfoSectionHeight : CGFloat = 68.0
    var defaultImageAspect       : CGFloat = 0.56
    
    var displayType : CastDisplayType = appData.liveGridViewDisplayType {
        didSet {
            appData.liveGridViewDisplayType = displayType
            self.collectionView.performBatchUpdates({
                self.updateFlowLayout()
                self.collectionView.setCollectionViewLayout(self.flowLayout, animated: true)
                
            }, completion: { (finished) in
                
            })
        }
    }
    
    var dataSource : [AnyObject] = []
    
    var edgeInsets : UIEdgeInsets {
        get{
            return self.collectionView.contentInset
        }
        set(newValue) {
            self.collectionView.contentInset = newValue
        }
    }
    
    var onReload : ()-> Void = { }
    var onSelect : (_ data : AnyObject) -> Void = {data in}
    var onLoadData : (_ page : Int, _  completed : @escaping ()->Void) -> Void = {page, completed in}
    
    var onScroll : (_ scrollView : UIScrollView) -> Void = {scrollView in}
    var onBeginDrag : (_ scrollView : UIScrollView) -> Void = {scrollView in}
    
    var cellForIndex : ((_ collectionView : UICollectionView,_ indexPath : IndexPath) -> UICollectionViewCell)?
    
    @IBOutlet private var contView: UIView!
    @IBOutlet private var collectionView : UICollectionView!
    @IBOutlet private weak var flowLayout: UICollectionViewFlowLayout!
    
    var currentPage : Int = 0
    var totalPage   : Int = 1
    fileprivate let refreshControl = UIRefreshControl()
    
    var cellNumOnLine : Int = 2 {
        didSet {
            updateFlowLayout()
        }
    }
    
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
        let nib = UINib(nibName: "GridView", bundle: bundle)
        contView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        contView.frame = bounds
        contView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        
        self.addSubview(contView)
        
        setupCollectionView()
        
        // 항상 리스트를 당겨서 갱신할 수도록 설정 변경
        collectionView.alwaysBounceVertical = true
        
        showEmptyLabel(bShow: false)
    }
    
    func showEmptyLabel(bShow: Bool) {
        //emptyLabel.isHidden = !bShow
        if bShow {
			emptyLabel.text = I18N.text_no_content.localized
        } else {
            emptyLabel.text = ""
        }
    }
    
    
    private func setupCollectionView() {
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.reload), for: .valueChanged)
        
        refreshControl.bounds = CGRect(x: refreshControl.bounds.origin.x, y: -10, width: refreshControl.bounds.size.width, height: refreshControl.bounds.size.height)
        
        self.collectionView.addSubview(refreshControl)
        
        self.collectionView.register(UINib(nibName: "CastGridCell", bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: "CastGridCell")
        self.collectionView.register(UINib(nibName: "CeluvVodCell", bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: "CeluvVodCell")
    
        //self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 140, bottom: 20, right: 0)
    
        updateFlowLayout()
    }
    
    func updateFlowLayout() {
        
        var length = (UIScreen.main.bounds.width-30)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing  = 0
        
        if displayType == .grid {
            let itemWidth = UIScreen.main.bounds.width / CGFloat(cellNumOnLine)
            let itemHeight = itemWidth * defaultImageAspect + defaultInfoSectionHeight
            flowLayout.itemSize = CGSize(width: itemWidth, height: itemHeight )
        }else {
            length -= 140
            let newHeight = (UIScreen.main.bounds.width-20) * 0.75 * 0.338 / 1.088
            flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width-20) ,height: newHeight );
            //flowLayout.itemSize = CGSize(width: (UIScreen.main.bounds.width-20) ,height: ((length/2) * 3/4));
        }        
    }
    
    @objc func reload(){
        currentPage = 0
        dataSource = []
        
        self.collectionView.reloadData()
        
        loadData(page: 1)
        
        self.onReload()
    }
    
    func loadData(page : Int) {
        let completed = {
            dispatchMain.async {
                self.collectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
        onLoadData(page,completed)
    }
    
    func resetTableScroll() {
        self.collectionView.setContentOffset(CGPoint.zero, animated: true)
    }
	
	func resetRefreshControl() {
		if self.collectionView.contentOffset.y < 0 {
			self.collectionView.contentOffset = .zero
		}

	}
}

extension GridView : UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        if cellForIndex != nil {
            return cellForIndex!(collectionView, indexPath)
        }
        
        let data = dataSource[indexPath.row]
        if data is CastInfo {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastGridCell", for: indexPath) as? CastGridCell {
                cell.setInfo(cast: data as! CastInfo)
                cell.displayType = self.displayType
                
                return cell
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        var length = (UIScreen.main.bounds.width-30)
        if displayType == .grid {
            let itemWidth = UIScreen.main.bounds.width / CGFloat(cellNumOnLine)
            let itemHeight = itemWidth * defaultImageAspect + defaultInfoSectionHeight
            return  CGSize(width: itemWidth, height: itemHeight );
        }else {
            length -= 140
            let newHeight = (UIScreen.main.bounds.width-20) * 0.75 * 0.338 / 1.088
            return CGSize(width: (UIScreen.main.bounds.width-20) ,height: newHeight);
            //return CGSize(width: (UIScreen.main.bounds.width-20) ,height: ((length/2) * 3/4));
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.onSelect(dataSource[indexPath.row])
    }
    
    // 테스트 용도
    // 테이블뷰에 올라온 셀에 있는 이미지뷰가 애니메이션도중 터치이벤트시 멈출시
    // 다시 애니메이션 호출.
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CastGridCell {
            dispatchMain.asyncAfter(deadline: .now() + 1.0) {
                //if cell.postImageView.animationImages != nil {
                //    cell.postImageView.startAnimating()
                //}
            }
        }
    }
    
    /// 페이징 처리
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == dataSource.endIndex - 1 {
            if currentPage < self.totalPage {
                self.loadData(page: self.currentPage+1)
            }
        }
    }
    
}

extension GridView : UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.onBeginDrag(scrollView)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.onScroll(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    }
}
