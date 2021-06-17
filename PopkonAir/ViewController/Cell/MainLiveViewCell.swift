//
//  MainLiveViewCell.swift
//  PopkonAir
//
//  Created by roypark on 8/29/16.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SDWebImage

enum FlagType : Int{
    case pay    = 0
    case adult  = 1
    case fan    = 2
    
    func iconImage()->UIImage {
        switch self {
        case .pay:
            return #imageLiteral(resourceName: "paid_icon")
        case .adult:
            return #imageLiteral(resourceName: "ico_19")
        case .fan:
            return #imageLiteral(resourceName: "ico_fen")
        }
    }
}


class MainLiveViewCell: UICollectionViewCell {
    
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTitleLabel: UILabel!
    @IBOutlet weak var postTimeLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var hotIconImageView: UIImageView!
    @IBOutlet weak var lockIconImageView: UIImageView!
    @IBOutlet weak var lockTopConstraint: NSLayoutConstraint!
    
    @IBOutlet var flagImageViews: [UIImageView]!
    
    
    var previewAction : (_ sender : UIButton)->Void = {send in}
    
    private(set) public var cast : CastInfo = CastInfo()
    
    
    open func setInfo(cast : CastInfo) {
        
        self.cast = cast
        
        self.updateContent()
        
    }
    

    
    //MARK: - Update content
    func updateContent() {
        
        //Cast Image
        self.postImageView.sd_setImage(with: URL(string: cast.pFileName), placeholderImage:appData.defProImage.images[cast.categoryCode])
        
        //Cast name
        self.postTitleLabel.text = cast.castTitle
        
        //MC nickname
        self.authorLabel.text = cast.nickName
        
        //info
        self.timeLabel.attributedText = CellUtil.getTimeAndWatchCntAttributeString(from: cast)
        self.postTimeLabel.attributedText = CellUtil.getTimeAndWatchCntAttributeString(from: cast)
        
        //Hot
        switch cast.castListNum {
        case .normal:
            hotIconImageView.isHidden = true
            lockTopConstraint.constant = 3
        case .bronze:
            hotIconImageView.isHidden = false
            hotIconImageView.image = UIImage(named: "hot_icon3")
            lockTopConstraint.constant = 3 + 19//hotIconImageView.frame.height
        case .silver:
            hotIconImageView.isHidden = false
            hotIconImageView.image = UIImage(named: "hot_icon2")
            lockTopConstraint.constant = 3 + 19//hotIconImageView.frame.height
        case .gold:
            hotIconImageView.isHidden = false
            hotIconImageView.image = UIImage(named: "hot_icon1")
            lockTopConstraint.constant = 3 + 19//hotIconImageView.frame.height
        case .special:
            hotIconImageView.isHidden = true
            lockTopConstraint.constant = 3            
        }
        
        //Flag Icon
        var flags : [FlagType] = CellUtil.getFlags(from: cast)
        
        for i in 0...2
        {
            if flags.count > i {
                let flag = flags[i]
                flagImageViews[i].isHidden = false
                flagImageViews[i].image = flag.iconImage()
            }else {
                flagImageViews[i].isHidden = true
            }
            
        }

        
        //Lock
        lockIconImageView.isHidden = !cast.isPrivate
        
        self.layoutIfNeeded()
        
    }
    
    //MARK: - IBAction
    @IBAction func previewAction(_ sender: AnyObject) {
        previewAction(sender as! UIButton)
    }
    
}
