//
//  AdView.swift
//  PopkonAir
//
//  Created by Steven on 08/12/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SDWebImage

class AdView: UIView {

    @IBOutlet private var contView: UIView!
    
    @IBOutlet private weak var scrollView: LoopScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
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
        let nib = UINib(nibName: "AdView", bundle: bundle)
        contView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        contView.frame = bounds
        contView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        
        self.addSubview(contView)
        
        
        //Scale page control
        pageControl.layer.transform = CATransform3DMakeScale(1.3, 1.3, 0)
        pageControl.currentPageIndicatorTintColor = mainColor
        pageControl.isHidden = true
        
        //Setup content views in scroll view
        setupImages()
        
        //Start auto scroll
        scrollView.startAutoScroll()
        
        
    }
    
    
    //MARK: - UI Setup
    private func setupImages() {

        var contentViews : [UIView] = []
        
        for index in 0...appData.adMainImages.count-1 {
            let contentView = self.createContentView(with: index)
            
            contentViews.append(contentView)
        }
        
        self.scrollView.contentViews = contentViews
        
        self.scrollView.onPageChanged = {
            newIndex in
            self.pageControl.currentPage = newIndex
        }
        
        if appData.adMainImages.count <= 1 {
//            self.pageControl.isHidden = true
        }else {
//            self.pageControl.isHidden = false
            self.pageControl.numberOfPages = appData.adMainImages.count
        }
        
        
        
    }
    
    private func createContentView(with index : Int) -> UIView {
        let contentView = UIView(frame: CGRect(x: index * Int(self.bounds.width), y: 0, width: Int(self.bounds.width), height: Int(self.bounds.height)))
    
        let button = UIButton(type: .custom)
        button.frame = self.bounds
        button.tag = index
        button.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        button.sd_setImage(with: URL(string: appData.adMainImages[index].imageURL), for: .normal)
        
        if appData.adMainImages[index].isLink {
            button.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
        }
        contentView.addSubview(button)
        
        return contentView
    }
    
    //MARK: - IBActions 
    @objc func buttonAction(_ sender : UIButton) {
        let index = sender.tag
        
        let linkURL = appData.adMainImages[index].linkURL
        if let encoded  = linkURL.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),let encodedURL = URL(string: encoded){
            UIApplication.shared.open(encodedURL)
        }
    }
    
    @IBAction func pageChangedAction(_ sender: Any) {
        self.scrollView.scroll(to: pageControl.currentPage)
    }
}

