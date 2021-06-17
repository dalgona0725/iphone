//
//  PaperDetailInfo.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 5. 16..
//  Copyright © 2018년 roy. All rights reserved.
//

import UIKit
import SwiftyJSON

class PaperDetailInfo: NSObject {
    var code : String = ""
    
    /// 보낸 회원 아이디
    var sendSignID : String = ""
    
    /// 받은 회원 아이디
    var receiveSignID : String = ""
    
    /// 보낸일자코드 (YYYYmmDDhhNNss)
    var sendDate : String = ""
    
    /// 확인일자코드 (YYYYmmDDhhNNss) 값이 없으면 미확인
    var receiveDate : String = ""
    
    /// 쪽지 내용
    var text : String = ""
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        //code = json["pk_code"].stringValue
        sendSignID      = json["send_signId"].stringValue
        receiveSignID   = json["receive_signId"].stringValue
        sendDate        = json["sendDate"].stringValue
        receiveDate     = json["receiveDate"].stringValue
        text            = json["nText"].stringValue
        
    }
}
