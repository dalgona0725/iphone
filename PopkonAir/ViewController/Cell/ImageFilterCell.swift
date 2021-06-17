//
//  ImageFilterCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 7. 31..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit

class ImageFilterCell: UICollectionViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    
    private let defaultColor = UIColor.black.withAlphaComponent(0.1).cgColor
    private let selectedColor = UIColor.red.cgColor
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageView()
    }

    private func setupImageView() {
        itemImageView.layer.borderWidth = 2.0
        itemImageView.layer.borderColor = defaultColor
        itemImageView.layer.cornerRadius = 40
        itemImageView.clipsToBounds = true
        itemImageView.layer.masksToBounds = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //updateLabelFrame()
    }
    
    func updateImageViewBoarderColor(isSelected: Bool) {
        itemImageView.layer.borderColor = isSelected ? selectedColor : defaultColor
    }
}
