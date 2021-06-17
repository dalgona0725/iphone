//
//  CategoryInfo.swift
//  PopkonAir
//
//  Created by Steven on 12/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SwiftyJSON
import SDWebImage

class CategoryInfo: NSObject {
    
    var label : String  = ""
    var code : String = ""
    var week : String = ""
    var time : String = ""
    var basicThumb : String = ""
    var categoryThumb : String = ""
    var partnerCode : String = ""
    var signID : String = ""
    
    var categoryImage : UIImage?
    
    open func setInfo(json : JSON) {
        label = json["label"].stringValue
        code = json["code"].stringValue
        week = json["week"].stringValue
        time = json["time"].stringValue
        basicThumb = json["basicThumb"].stringValue
        categoryThumb = json["categoryThumb"].stringValue
        partnerCode = json["ch_partnercode"].stringValue
        signID = json["ch_signid"].stringValue
        
        if self.categoryThumb .count > 0 {
            dispatchGlobal.async {
                do {
                    self.categoryImage = UIImage(data: try Data(contentsOf: URL(string: self.categoryThumb)!))
                }
                catch {
                    log.error(error)
                }
            }
        }
    }
    
    // 비로그인 adult
    open func isAdult() -> Bool {
        return code == "20" || code == "8"
    }
    
    var isCommerce : Bool {
        return code == cmeCategoryCommerce
    }
}
