//
//  TitleImageCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 1. 11..
//  Copyright © 2018년 eugene. All rights reserved.
//

import UIKit

class TitleImageCell : UITableViewCell {
    
    @IBOutlet weak var fileNameLabel: UILabel!
    @IBOutlet weak var fileImageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    
    
    var height_Org : CGFloat = 0
    var width_Org  : CGFloat = 0
    var height_Large : CGFloat = 0
    var width_Large  : CGFloat = 0
    
    var isLargeImage : Bool {
        get {
            return self.imageWidthConstraint.constant == width_Large
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageHeightConstraint.constant = 240
        
        width_Org = self.imageWidthConstraint.constant
        height_Org = self.imageHeightConstraint.constant
        
        //self.contentView.setLayerOutLine()
    }
    
    func verifyURL(urlString : String?) -> Bool {
        if let urlString = urlString {
            if let url = URL(string: urlString) {
                return UIApplication.shared.canOpenURL(url)
            }
        }
        return false
    }
    
    open func setInfo(text: String, imageURL: String) {
        
        questionLabel.text = text 
        
        var validURL = false
        if let url = URL(string: imageURL) {
            validURL = UIApplication.shared.canOpenURL(url)
        }
        
        if validURL {
            let parts = imageURL.split(separator: "/")
            if parts.count > 0 {
                fileNameLabel.text = String(format: I18N.text_attachedFile.localized, String(parts.last!))
            }
        } else {
            fileNameLabel.text = I18N.text_noAttachedFile.localized
            self.frame.size = CGSize(width: self.frame.width, height: self.frame.height - self.imageHeightConstraint.constant )
            self.imageHeightConstraint.constant = 0
            self.height_Org = 0
        }

        fileImageView.setLayerOutLine(borderWidth: 1, cornerRadius: 4, borderColor: UIColor.darkGray )
        fileImageView.contentMode = .scaleAspectFill
        
        // fileImageView.sd_setImage(with: URL(string: imageURL))
        
        fileImageView.sd_setImage(with: URL(string: imageURL), completed: { (image, error, cacheType, url) in
            dispatchMain.async {
                if let img = image {
                    let ratio = img.size.height / img.size.width
                    self.width_Large = self.contentView.frame.width * 0.8
                    self.height_Large = ratio * self.width_Large
//                    self.fileImageView.frame.size = CGSize(width: self.width_Large, height: self.height_Large)
//                    self.imageWidthConstraint.constant = self.width_Large
//                    self.imageHeightConstraint.constant = self.height_Large
//
//                    self.contentView.frame.size = CGSize(width: self.contentView.frame.width, height: self.contentView.frame.height + self.height_Large - self.height_Org )

                }
            }
        })
    }
    
    open func extendImage(toLarge: Bool) {
        
        if self.height_Org == 0 {
            return
        }
        
        var newSize = CGSize()
        
        if toLarge {
            self.imageWidthConstraint.constant = width_Large
            self.imageHeightConstraint.constant = height_Large
            newSize = CGSize(width: self.frame.width, height: self.frame.height + ( height_Large - height_Org ) )
            
        } else {
            self.imageWidthConstraint.constant = width_Org
            self.imageHeightConstraint.constant = height_Org
            newSize = CGSize(width: self.frame.width, height: self.frame.height - ( height_Large - height_Org )  )
        }
        
        UIView.animate(withDuration: 0.25, animations: {
            self.frame.size =  newSize
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
}

