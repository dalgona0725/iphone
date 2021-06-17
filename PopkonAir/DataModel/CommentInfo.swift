//
//  CommentInfo.swift
//  PopkonAir
//
//  Created by Steven on 20/12/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SwiftyJSON

class CommentInfo: NSObject {
    var code : String = ""
    var registDate : String = ""
    var signID : String = ""
    var nickname : String = ""
    var pFileName : String = ""
    var recommendCnt : String = ""
    var commentCnt : String = ""
    var commentText : String = ""
    
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        code = json["pk_code"].stringValue
        registDate = json["registDate"].stringValue
        signID = json["signId"].stringValue
        nickname = json["nickName"].stringValue
        pFileName = json["pFileName"].stringValue
        recommendCnt = json["GoodCnt"].stringValue
        commentCnt = json["CommentCnt"].stringValue
        commentText = json["CommentTxt"].stringValue
    }
}
