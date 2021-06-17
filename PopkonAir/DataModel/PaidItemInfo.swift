//
//  PaidItemInfo.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 12. 11..
//  Copyright © 2017년 eugene. All rights reserved.
//


import UIKit
import SwiftyJSON

struct ItemOption {
    /// 아이템 코드
    var optionCode : String       = ""
    
    /// 아이템 이름
    var optionName : String     = ""
    
    /// 아이템 보유 유무
    var isHasItem : String      = ""
    
    /// 아이템 옵션 정보 (유효기간)
    var expiration: String      = ""
    
    /// 아이템 옵션 가격
    var optionPrice : String          = ""
}

class PaidItemInfo: NSObject {
    
    /// 아이템 명
    var itemName : String       = ""
    
    /// 아이템 정보
    var itemInfo : String       = ""
    
    /// 아이템 옵션리스트
    var itemOptions : [ItemOption]  = []
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        itemName = json["itemName"].stringValue
        itemInfo = json["itemInfo"].stringValue
        
        for option in json["itemOptionList"].arrayValue {
            let code    = option["itemCode"].stringValue
            let hasItem = option["isHasItem"].stringValue
            let optionName  = option["itemOptionName"].stringValue
            let optionInfo  = option["itemOptionInfo"].stringValue
            //let optionPrice = option["itemOptionPrice"].stringValue
            
            var price = option["itemOptionPrice"].doubleValue
            let divisor = 100.0
            price = price * divisor
            let optionPrice = "\(price/divisor)"
            let optionItem = ItemOption(optionCode: code, optionName: optionName, isHasItem: hasItem, expiration: optionInfo, optionPrice: optionPrice)
            
            itemOptions.append(optionItem)
        }
        
    }
}


//extension Double {
//    /// Rounds the double to decimal places value
//    mutating func roundToPlaces(places:Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//
//        self = self * divisor
//
//        return round() / divisor
//    }
//
//}

