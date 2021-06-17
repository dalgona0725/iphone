//
//  VODCommentInfo.swift
//  TVTen
//
//  Created by Eugene Jeong on 2017. 10. 25..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit
import SwiftyJSON

class VODCommentInfo: NSObject {
    
    /// 댓글 키
    var commentKey      : String            = ""
    
    /// 등록일
    var writeDate       : String             = ""
    
    /// 아이디
    var userID          : String            = ""
    
    /// 닉네임
    var userNick        : String            = ""
    
    /// 프로필 이미지 경로
    var urlProfileImg   : String            = ""
    
    /// 추천수
    var goodCount       : Int               = 0
    
    /// 비추천수
    var badCount        : Int               = 0
    
    /// 대댓글 수
    var replyCount      : Int               = 0
    
    /// 댓글 내용
    var comment         : String          = ""
    
    /// 서비스 레벨
    var levelService    : Int               = 0
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        
        if json["pk_code"].stringValue != "" {
            commentKey = json["pk_code"].stringValue
        }
        
        if json["registDate"].stringValue != "" {
            writeDate = json["registDate"].stringValue
        }
        
        if json["signId"].stringValue != "" {
            userID = json["signId"].stringValue
        }
        
        if json["nickName"].stringValue != "" {
            userNick = json["nickName"].stringValue
        }
        
        if json["pFileName"].stringValue != "" {
            urlProfileImg = json["pFileName"].stringValue
        }
        
        if json["goodCnt"].stringValue != "" {
            goodCount = json["goodCnt"].intValue
        }
        
        if json["badCnt"].stringValue != "" {
            badCount = json["badCnt"].intValue
        }
        
        if json["commentCnt"].stringValue != "" {
            replyCount = json["commentCnt"].intValue
        }
        
        if json["commentTxt"].stringValue != "" {
            comment = json["commentTxt"].stringValue
        }
        
        levelService = json[lvServiceKey].intValue
    }
    
}
