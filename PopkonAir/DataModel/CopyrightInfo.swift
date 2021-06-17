//
//  CopyrightInfo.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 1. 9..
//  Copyright © 2018년 eugene. All rights reserved.
//

import UIKit
import SwiftyJSON

class CopyrightInfo: NSObject {
    
    /// 제목
    
    var title            : String          = ""
    
    /// 작성일자 (YYYYmmDDhhNNss)
    var writtenDate      : String          = ""
    
    /// 게시 번호
    var postNumber       : String          = ""
    
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
    }
}


class CopyrightDetailInfo: NSObject {
    
    /// 제목
    var title            : String          = ""
    
    /// 작성일자 (YYYYmmDDhhNNss)
    var writtenDate      : String          = ""
    
    /// 게시 내용
    var text             : String          = ""
    
    open func setInfo(json : JSON) {
        
        log.debug(json)
        if json["nTitle"].stringValue != "" {
            title = json["nTitle"].stringValue
        }
        
        if json["registDate"].stringValue != "" {
            writtenDate = json["registDate"].stringValue
        }
        
        if json["nText"].stringValue != "" {
            text = json["nText"].stringValue
        }
    }
}

extension CopyrightDetailInfo {
    var attributedText : NSAttributedString? {
        return text.convertHtml()
    }
    
    func getAttributeText(font: UIFont?) -> NSAttributedString? {
        if let font = font {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html,
                NSAttributedString.DocumentReadingOptionKey.characterEncoding : String.Encoding.utf8.rawValue
            ]
            
            if let text = text.data(using: .utf8, allowLossyConversion: false) {
                guard let attr = try? NSMutableAttributedString(data: text, options: options, documentAttributes: nil) else {
                    return nil
                }
                var attrs = attr.attributes(at: 0, effectiveRange: nil)
                attrs[NSAttributedString.Key.font] = font
                attr.setAttributes(attrs, range: NSRange(location: 0, length: attr.length))
                return attr
                
            } else {
                return nil
            }
            
        } else {
            return self.attributedText
        }
    }
}

