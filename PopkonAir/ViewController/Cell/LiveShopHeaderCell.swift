//
//  LiveShopHeaderCell.swift
//  PopkonAir
//
//  Created by BumSoo Park on 2021/05/10.
//  Copyright © 2021 The E&M. All rights reserved.
//

import UIKit

class LiveShopHeaderCell: UITableViewHeaderFooterView {
    
    private let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 17, weight: .bold)
    }
    
    let viewMoreButton = UIButton().then {
        $0.setTitle(I18N.text_view_all.localized + " +", for: .normal)
        $0.setTitleColor(popupMainColor, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 13, weight: .thin)
        $0.backgroundColor = .clear
    }

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    private func setupUI() {
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.85)
        contentView.addSubview(titleLabel)
        contentView.addSubview(viewMoreButton)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(25)
            $0.centerY.equalToSuperview()
        }
        
        viewMoreButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(29)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    func setupTitle(title: String) {
        titleLabel.text = title
    }
    
    func showViewMoreButton(show: Bool) {
        viewMoreButton.isHidden = show
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
