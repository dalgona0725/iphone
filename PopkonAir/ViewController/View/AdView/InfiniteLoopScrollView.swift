//
//  InfiniteLoopScrollView.swift
//  PopkonAir
//
//  Created by Steven on 06/01/2017.
//  Copyright © 2017 roy. All rights reserved.
//

import UIKit


enum ILSVDisplayPostion : Int {
    case left = 0
    case middle = 1
    case right = 2
}

enum ILSVDisplayMode : Int {
    case oneView = 1
    case twoViews = 2
    case threeViews = 3
}

class InfiniteLoopScrollView: UIScrollView {
    
    fileprivate var curPage : Int = 0 {
        didSet {
            onPageChanged(curPage)
        }
    }
    
    fileprivate var displayPage : Int {
        get {
            return Int((self.contentOffset.x/self.bounds.width) + 0.5)
        }
    }
    
    fileprivate var nextPage : Int {
        get {
            if curPage + 1 > totalPage - 1 {
                return 0
            }else {
                return curPage + 1
            }
        }
    }
    
    fileprivate var totalPage : Int {
        get {
            return dataSource.count
        }
    }
    
    var dataSource : [UIView] = [] {
        didSet {
            reloadContentViews()
        }
    }
    
    var displayCount : Int {
        get {
            return min(3, dataSource.count)
        }
    }
    let displayViews : [UIView] = []
    
    ///Position of Displaying View
    var position : ILSVDisplayPostion = .middle
    
    var displayMode : ILSVDisplayMode {
        get {
            if dataSource.count>0 {
                return ILSVDisplayMode(rawValue: displayCount)!
            }else {
                return .oneView
            }
        }
    }
    
    var onPageChanged : (_ newPage : Int)->Void = {
        newPage in
    }
    
    /// timer
    private var timer: DispatchSourceTimer?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initSetup()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        initSetup()
    }

    func initSetup() {
        self.isPagingEnabled = true
        self.delegate = self
    }
    
    /// MARK: - Public
    
    /// scroll to page
    ///
    /// - Parameter page: target page num
    func scroll(to page:Int) {
        
        log.debug("scroll to page \(page)")
        self.stopAutoScroll()
        
        self.setContentOffset(CGPoint(x: page * Int(self.bounds.width), y: 0), animated: true)
        
    }
    
    func scroll(to position:ILSVDisplayPostion) {
        let x : CGFloat = self.bounds.width * CGFloat(position.rawValue)
        
        self.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }
    
    
    /// Start auto scroll to next page
    func startAutoScroll() {
        
        log.debug("startAutoScroll")
        
        startTimer(with: {
            dispatchMain.async {
                self.scroll(to: .right)
//                self.setContentOffset(CGPoint(x: self.nextPage * Int(self.bounds.width), y: 0), animated: true)
            }
        })
    }
    
    /// Start auto scroll to next page
    func stopAutoScroll() {
        log.debug("stopAutoScroll")
        stopTimer()
    }
    
    
    //MARK: - Setup
    private func reloadContentViews() {
        
        for subView in self.subviews {
            subView.removeFromSuperview()
        }
        
        self.contentOffset = CGPoint.zero
        
        if totalPage == 0 {
            self.contentSize = self.bounds.size
            return
        }
        
        for index in 0...totalPage - 1 {
            let contentView = dataSource[index]
            
            contentView.frame = CGRect(x: index * Int(self.bounds.width), y: 0, width: Int(self.bounds.width), height: Int(self.bounds.height))
            
            self.addSubview(contentView)
        }
        
        self.contentSize = CGSize(width: totalPage * Int(self.bounds.width), height: Int(self.bounds.height))
    }
    
    //MARK: - Timer
    private func startTimer(with handler : @escaping ()->Void) {
        
        stopTimer()
        
        timer = DispatchSource.makeTimerSource(flags: .strict, queue: .main)
        timer!.schedule(deadline: .now() + 2, repeating: 2)
        timer!.setEventHandler {
            handler()
        }
        timer!.resume()
    }
    
    private func stopTimer() {
        if timer != nil {
            timer!.cancel()
            timer = nil
        }
    }
}

extension InfiniteLoopScrollView : UIScrollViewDelegate {
    
    //MARK: - ScrollViewDelegate
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        log.debug("scrollViewDidEndDecelerating")
        self.startAutoScroll()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        log.debug("scrollViewWillBeginDragging")
        self.stopAutoScroll()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.curPage != self.displayPage {
            self.curPage = displayPage
        }
    }
}
