//
//  HoriScrollCell.swift
//  Celuv
//
//  Created by Steven on 16/01/2017.
//  Copyright © 2017 roy. All rights reserved.
//

import UIKit

class HoriScrollCell: UITableViewCell {

    @IBOutlet weak var scrollView: UIScrollView!
    
    var contentViews : [UIView] = [] {
        didSet {
            reloadContentViews()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.scrollView.contentSize = CGSize(width: contentViews.last!.frame.maxX, height: (UIScreen.main.bounds.width * 27 / 64))
    }
    //MARK: - Setup
    private func reloadContentViews() {

        
        for subView in self.scrollView.subviews {
            subView.removeFromSuperview()
        }
        
        self.scrollView.contentOffset = CGPoint.zero
        self.scrollView.isDirectionalLockEnabled = true
        
        if contentViews.count == 0 {
            self.scrollView.contentSize = self.bounds.size
            return
        }
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        for (index, contentView) in contentViews.enumerated() {
            
            if index > 0 {
                contentView.frame = CGRect(origin: CGPoint(x: contentViews[index-1].frame.maxX, y: 0), size: contentView.frame.size)
            }else {
                //stevenj edit 
                contentView.frame = CGRect(origin: CGPoint(x:2.5,y:0), size: contentView.frame.size)
            }
            
            self.scrollView.addSubview(contentView)
        }
        
        self.scrollView.contentSize = CGSize(width: contentViews.last!.frame.maxX, height: (UIScreen.main.bounds.width * 27 / 64))
    }
}
