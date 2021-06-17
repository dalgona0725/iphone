//
//  FullImageAdView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 6. 27..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit

class ImageAdView: UIView {
    
    @IBOutlet private var contView: UIView!
    @IBOutlet private weak var adScrollView: LoopScrollView!
    @IBOutlet private weak var pageControl: UIPageControl!
    
    var onShowAds : (AdImageInfo) -> Void = { index in }
    var onCloseAds : () -> Void = { }
    var onLinkAds : (AdImageInfo) -> Void = { index in }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var adImageInfos : [AdImageInfo] = []
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
        let nib = UINib(nibName: "ImageAdView", bundle: bundle)
        contView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        contView.frame = bounds
        contView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        self.addSubview(contView)
        
//        //Scale page control
//        pageControl.layer.transform = CATransform3DMakeScale(1.3, 1.3, 0)
//        pageControl.currentPageIndicatorTintColor = mainColor
//        
        pageControl.isHidden = true
        pageControl.pageIndicatorTintColor = UIColor.darkGray
        pageControl.currentPageIndicatorTintColor = mainColor
        adScrollView.backgroundColor = mainColor
    }
    
    // MARK: - UI Ads Setup
    func setupImageAds(adImages : [AdImageInfo], conditionForButtonAction:@escaping (_ ad : AdImageInfo) -> Bool) {
        
        
        // create Ads View
        var contentViews : [UIView] = []
        
        adImageInfos = adImages
        
        pageControl.numberOfPages = adImageInfos.count
        pageControl.currentPage = 0
        if adImages.count < 2 {
            pageControl.isHidden = true
        } else {
            pageControl.isHidden = false
        }
        
        for index in 0..<adImageInfos.count {
            let adView = UIView(frame: CGRect(x: index * Int(self.bounds.width), y: 0, width: Int(self.bounds.width), height: Int(self.bounds.height)))
            
            let imgView = UIImageView().then {
                $0.contentMode = .scaleToFill
                $0.sd_setImage(with: URL(string: adImageInfos[index].imageURL.urlQueryAllowedString))
            }
            
            let button = UIButton(type: .custom).then {
                $0.backgroundColor = .clear
                $0.tag = index
            }
            
            if conditionForButtonAction(adImageInfos[index]) {
                button.addTarget(self, action: #selector(self.buttonAction(_:)), for: .touchUpInside)
            }
            
//          if adImageInfos[index].adType == .caster {
//                button.addTarget(self, action: #selector(ImageAdView.buttonAction(_:)), for: .touchUpInside)
//          }
            

            adView.addSubview(imgView)
            adView.addSubview(button)
            contentViews.append(adView)
            
            imgView.snp.makeConstraints {
                $0.top.bottom.leading.trailing.equalToSuperview()
            }
            
            button.snp.makeConstraints {
                $0.top.bottom.leading.trailing.equalToSuperview()
            }
        }
        
        // setup LoopScrollView
        adScrollView.contentViews = contentViews
        adScrollView.onPageChanged = { newIndex in
            self.pageControl.currentPage = newIndex
            
            // TODO: 광고 노출 로그
            self.onShowAds(self.adImageInfos[newIndex])
        }
        adScrollView.setIntervalTime(start: 3, delay: 3)
    }
    
    @objc func buttonAction(_ sender : UIButton) {
        let index = sender.tag
    
        log.debug("광고 \(index) 클릭 처리....\(sender.frame) \((sender.imageView?.frame)!)")
        
        if index >= adImageInfos.count {
            return
        }
        
        // TODO: 광고 링크 로그. BJ 경우 방송 연결 처리.
        onLinkAds(adImageInfos[index])
//        if adImageInfos[index].isLink {
//            self.removeFromSuperview()
//        }
    }
    
    @IBAction func doExitButton(sender : AnyObject) {
        
        onCloseAds()
        self.removeFromSuperview()
    }
    
    @IBAction func pageChange(_ sender: UIPageControl) {
        adScrollView.scroll(to: pageControl.currentPage)
    }

}
