//
//  NoContentCell.swift
//  PopkonAir
//
//  Created by BumSoo Park on 2021/05/10.
//  Copyright © 2021 The E&M. All rights reserved.
//

import UIKit

class NoContentCell: UITableViewCell {
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .bold)
        $0.textColor = .darkText
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = .none
        backgroundColor = .clear
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitle(_ title: String) {
        titleLabel.text = String(format: I18N.text_no_content.localized, title)
    }

}
