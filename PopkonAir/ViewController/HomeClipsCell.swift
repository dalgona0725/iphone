//
//  HomeClipsCell.swift
//  Celuv
//
//  Created by Steven on 17/01/2017.
//  Copyright © 2017 roy. All rights reserved.
//

import UIKit

class HomeClipsCell: HoriScrollCell {
    
    @IBOutlet weak var shadowView: UIView!
	
	@IBOutlet weak var titleLb: UILabel!
	
    var castList : [CastInfo] = []

    var onClick : (_ cast : CastInfo) -> Void = {
        cast in
        
    }

    
    var imageLoderTimer : Timer? = nil
    var doneImageCount : Int = 0
    
    private var clipSize : CGSize {
        get {
            return CGSize(width: (UIScreen.main.bounds.width * 3 / 4) , height: (UIScreen.main.bounds.width * 27 / 64) + 35)
        }
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
//        shadowView.layer.shadowColor = UIColor.black.cgColor
//        shadowView.layer.shadowOpacity = 0.5
//        shadowView.layer.shadowOffset = CGSize.zero
//        shadowView.layer.shadowRadius = 2
//        
//        shadowView.layer.shadowPath = UIBezierPath(rect: shadowView.bounds).cgPath
//        shadowView.layer.shouldRasterize = true
    }
 

    @available(iOS 9.0, *)
    open func updateContentViews(bLoadImage: Bool = true) {
        var clips : [ClipCellView] = []
        let size = clipSize
        for cast in castList {
            let clip = ClipCellView(frame: CGRect(origin: CGPoint(x: (clips.last != nil ? clips.last!.frame.maxX : 0), y: 0), size: size))
            clip.bLoadImage = bLoadImage
            clip.cast = cast
            clip.onClick = self.onClick
            clips.append(clip)
        }
        
        // 2017.06.23
        // HotClipCell 선택 영역 위아래 스크롤
        self.scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        // HotClipCell 선택 영역 위아래 스크롤
        // 2017.06.23
        self.contentViews = clips
        
        doneImageCount = 0

    }
    
    open func startLoadCastImage() {
        if doneImageCount >= castList.count {
            return
        }
        
        if imageLoderTimer == nil {
//            if #available(iOS 10.0, *) {
                imageLoderTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true, block: { (loader) in
                    self.loadCastImage()
                })
                
//            } else {
//                // Fallback on earlier versions
//                imageLoderTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.loadCastImage), userInfo: nil, repeats: true)
//            }
        }
    }
    
    func loadCastImage() {
        
        var bFind = false
        for view in self.contentViews {
            if let clip  = view as? ClipCellView {
                if clip.bLoadImage == false {
                    //log.debug("TEST01 \(self.doneImageCount) 로드중...")
                    clip.loadImage()
                    self.doneImageCount = self.doneImageCount + 1
                    bFind = true
                    break
                }
            }
        }
        
        if bFind == false || self.doneImageCount >= self.castList.count {
            imageLoderTimer?.invalidate()
            self.imageLoderTimer = nil
            //log.debug("TEST02 모든 이미지 로드 완료....")
        }
    }
	
	static var nib: UINib {
		return UINib(nibName: identifier, bundle: nil)
	}
	
	static var identifier: String {
		return String(describing: self)
	}
	

    
}

