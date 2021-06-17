//
//  HelperPresetInfo.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2020/08/26.
//  Copyright © 2020 The E&M. All rights reserved.
//
import SwiftyJSON

class HelperPresetInfo: NSObject {
    /// 프리셋 인덱스
    var index           : Int           = 0
    /// 해당 프리셋 명칭
    var name            : String        = ""
    /// 프리셋 URL
    var url             : String        = ""
    /// 키
    var key             : String        = ""
    /// 현재 해당 프리셋이 선택되어 있는지 여부
    var selected        : Bool          = false

    open func setInfo(json: JSON) {
        log.debug("\n-- \(String(describing: type(of: self))) --\n\(json)\n-----------------------------------------")
        index           = json[0].intValue
        name            = json[1].stringValue
        url             = json[2].stringValue
        key             = json[3].stringValue
    }
}

