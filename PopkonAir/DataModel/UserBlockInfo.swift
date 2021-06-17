//
//  UserBlockInfo.swift
//  PopkonAir
//
//  Created by BumSoo Park on 2021/05/11.
//  Copyright © 2021 The E&M. All rights reserved.
//

import UIKit

class UserBlockInfo: Codable {
    /// 차단 여부(0:미차단, 1:차단)
    var isBlock: String?
    /// 접속차단 여부(0:미차단, 1:차단)
    var isLoginBlock: String?
    /// 차단 일자코드 (YYYYmmDDhhNNss)
    var blockRegDate: String?
    /// 차단 기간
    var blockDate: String?
    /// 차단 사유
    var blockMemo: String?
    
    
    func isBlockUser() -> Bool {
        guard let isBlock = isBlock else {
            return false
        }
        if isBlock == "1" {
            return true
        }
        return false
    }
}
