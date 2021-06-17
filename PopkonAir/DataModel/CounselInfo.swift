//
//  CounselInfo.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 1. 9..
//  Copyright © 2018년 eugene. All rights reserved.
//


import UIKit
import SwiftyJSON

class CounselInfo: NSObject {
    
    /// 제목
    var title            : String          = ""
    
    /// 작성일자 (YYYYmmDDhhNNss)
    var writtenDate      : String          = ""
    
    /// 게시 번호
    var postNumber       : String          = ""
    
    /// 답변 완료/미완료
    var isAnswer         : Bool            = false 
    
    open func setInfo(json : JSON) {
        log.debug(json)
        if json["nTitle"].stringValue != "" {
            title = json["nTitle"].stringValue
        }
        
        if json["registDate"].stringValue != "" {
            writtenDate = json["registDate"].stringValue
        }
        
        if json["pk_code"].stringValue != "" {
            postNumber = json["pk_code"].stringValue
        }
        
        if json["isAnswer"].stringValue != "" {
            isAnswer = json["isAnswer"].stringValue == "0" ? false : true
        }
    }
}


class CounselDetailInfo: NSObject {
    
    /// 제목
    var title            : String          = ""
    
    /// 작성일자 (YYYYmmDDhhNNss)
    var writtenDate      : String          = ""

    /// 첨부파일 경로
    var fileName         : String          = ""
    
    /// 질문 내용
    var text_Q           : String          = ""
    
    /// 답변 내용
    var text_A           : String          = ""
    
    /// 답변 완료/미완료
    var isAnswer         : Bool            = false
    
    open func setInfo(json : JSON) {
        log.debug(json)
        if json["nTitle"].stringValue != "" {
            title = json["nTitle"].stringValue
        }
        
        if json["registDate"].stringValue != "" {
            writtenDate = json["registDate"].stringValue
        }

        if json["aFileName"].stringValue != "" {
            fileName = json["aFileName"].stringValue
        }
        
        if json["nText"].stringValue != "" {
            text_Q = json["nText"].stringValue
        }
        
        if json["aText"].stringValue != "" {
            text_A = json["aText"].stringValue
        }
        
        if json["isAnswer"].stringValue != "" {
            isAnswer = json["isAnswer"].stringValue == "0" ? false : true
        }
    }
}

