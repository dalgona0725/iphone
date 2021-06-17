//
//  StartAdView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 10. 11..
//  Copyright © 2017년 roy. All rights reserved.
//


import UIKit

class StartAdView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var adImageView: UIImageView!
    
    @IBOutlet weak var bottomPanel: UIView!
    @IBOutlet weak var linkButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    var onCloseAds : () -> Void = { }
    var onLinkAds : (AdImageInfo) -> Void = { index in }
    
    var adImageInfo = AdImageInfo()
    
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
        let nib = UINib(nibName: "StartAdView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        self.addSubview(contentView)
        
        closeButton.setTitle(I18N.ui_close.localized, for: .normal)
        linkButton.setTitle(I18N.ui_moreDetail.localized, for: .normal)
        
    }
    
    func setupImageAd(adInfo: AdImageInfo, conditionForButtonAction:@escaping (_ ad : AdImageInfo) -> Bool) {
        adImageView.sd_setImage(with: URL(string: adInfo.imageURL)) { (image, error, cacheType, url) in
            if let _ = error {
                return
            }
        }
        
        if conditionForButtonAction(adInfo) == false  {
            
            // 자세히 보기 버튼을 숨김처리
            // 닫기 버튼 사이즈 뷰사이즈와 동일하게 처리.
            linkButton.isHidden = true
            for constraint in bottomPanel.constraints {
                let first = constraint.firstItem
                let second = constraint.secondItem
                
                if second != nil && first != nil  && constraint.firstAttribute == .width {
                    bottomPanel.removeConstraint(constraint)
                }
            }
            let add = NSLayoutConstraint.init(item: bottomPanel as Any, attribute: .width, relatedBy: .equal, toItem: closeButton, attribute: .width, multiplier: 1, constant: 0)
            bottomPanel.addConstraint(add)
        }
        
        adImageInfo = adInfo
    }
    
    @IBAction func closeAd(_ sender: Any) {
        onCloseAds()
        self.removeFromSuperview()
    }
    @IBAction func clickLink(_ sender: Any) {
        onLinkAds(adImageInfo)
        self.removeFromSuperview()
    }
    
}
