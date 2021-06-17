//
//  ListupItem.swift
//  PopkonAir
//
//  Created by Steven on 09/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SwiftyJSON

struct ItemInfo {
    var code    = "AC-0007"
    var count   = 0
}

class ListupItem: NSObject {
    
    var gold : ItemInfo = ItemInfo(code: "AC-0007", count: 0)
    var silver : ItemInfo = ItemInfo(code: "AC-0008", count: 0)
    
    open func setInfo(itemList : [JSON]) {
        
        for json in itemList {
            if json["itemcode"].stringValue == gold.code {
                gold.count = json["cnt"].intValue
            }else if json["itemcode"].stringValue == silver.code {
                silver.count = json["cnt"].intValue
            }
        }
    }
}
