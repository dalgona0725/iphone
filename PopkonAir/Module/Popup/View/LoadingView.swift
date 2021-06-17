//
//  LoadingView.swift
//  PopkonAir
//
//  Created by Steven on 28/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class LoadingView: PopupView {

    @IBOutlet private weak var imageView: UIImageView!
    
    var orgSize : CGSize = CGSize(width: 0, height: 0)
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    //MARK: - Class Func
    class func instanceFromNib() -> LoadingView {
        return (Bundle.main.loadNibNamed("LoadingView", owner: self, options: nil)![0] as? LoadingView)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        var images : [UIImage] = []
        
        for i in 1...8 {
            if let image = UIImage(named: "img_progressbar_\(i)")
            {
                images.append(image)
            }
        }
        
        self.imageView.animationImages = images
        self.imageView.animationDuration = 0.8
        self.imageView.animationRepeatCount = 0
		self.setScale(scale: 0.5)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        if let center = self.window?.center {
            self.center = center
        }

        if orgSize.width != 0 && orgSize.height != 0 {
            self.frame.size = orgSize
        }
    }
    
    func setScale(scale : CGFloat) {
        imageView.frame.size = CGSize(width: imageView.frame.width*scale, height: imageView.frame.height*scale)
        self.frame = imageView.frame
        self.orgSize = self.frame.size
    }
    
    func startAnimating() {
        self.imageView.startAnimating()
    }
    
    func stopAnimating() {
        self.imageView.stopAnimating()
    }
    
    override func closePopup() {
        dispatchMain.async {
            self.hide()
        }
    }
}
