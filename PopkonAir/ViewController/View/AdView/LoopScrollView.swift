//
//  LoopScrollView.swift
//  PopkonAir
//
//  Created by Steven on 09/12/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class LoopScrollView: UIScrollView {

    
    private var startDelay : Double = 2.0
    private var intervalDelay : Double = 2.0
    
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
            return contentViews.count
        }
    }
    
    var contentViews : [UIView] = [] {
        didSet {
            reloadContentViews()
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isPagingEnabled = true
        self.delegate = self
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for index in 0...contentViews.count - 1 {
            let contentView = contentViews[index]
            
            contentView.frame = CGRect(x: index * Int(self.bounds.width), y: 0, width: Int(self.bounds.width), height: Int(self.bounds.height))
        }
        
        self.contentSize = CGSize(width: contentViews.count * Int(self.bounds.width), height: Int(self.bounds.height))

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
    
    
    /// Start auto scroll to next page
    func startAutoScroll() {
        
        log.debug("startAutoScroll")
        
        startTimer(with: {
            dispatchMain.async {
                self.setContentOffset(CGPoint(x: self.nextPage * Int(self.bounds.width), y: 0), animated: true)
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
        
        if contentViews.count == 0 {
            self.contentSize = self.bounds.size
            return
        }
        
        for index in 0...contentViews.count - 1 {
            let contentView = contentViews[index]
            
            contentView.frame = CGRect(x: index * Int(self.bounds.width), y: 0, width: Int(self.bounds.width), height: Int(self.bounds.height))
            
            self.addSubview(contentView)
        }
        
        self.contentSize = CGSize(width: contentViews.count * Int(self.bounds.width), height: Int(self.bounds.height))
    }

    //MARK: - Timer
    func setIntervalTime( start: Double, delay: Double) {
        var start = start
        if start <= 0 {
            start = 0.1
        }
        startDelay      = start
        intervalDelay   = delay
    }
    
    private func startTimer(with handler : @escaping ()->Void) {
        stopTimer()
        timer = DispatchSource.makeTimerSource(flags: .strict, queue: .main)
        timer!.schedule(deadline: .now() + startDelay, repeating: intervalDelay)
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

extension LoopScrollView : UIScrollViewDelegate {
    
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
