//
//  CommerceItemInfo.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2020/11/16.
//  Copyright © 2020 The E&M. All rights reserved.
//

import Foundation

struct CommerceItemInfo: Codable {
    /// 상품 번호
    var commerceSeq     : String            = ""
    /// 상품명
    var name            : String            = ""
    /// 상품 링크 경로
    var url             : String            = ""
    /// 판매자명
    var seller          : String            = ""
    /// 가격
    var price           : String            = ""
    /// 이미지 경로
    var imgUrl        : String            = ""
    /// 성인유무 (Y/N)
    var isAdult         : String            = ""
}
