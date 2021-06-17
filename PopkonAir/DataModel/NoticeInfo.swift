//
//  NoticeInfo.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 1. 9..
//  Copyright © 2018년 eugene. All rights reserved.
//

import UIKit
import SwiftyJSON

class NoticeInfo: NSObject {
    
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


class NoticeDetailInfo: NSObject {
    
    /// 제목
    var title            : String          = ""
    
    /// 작성일자 (YYYYmmDDhhNNss)
    var writtenDate      : String          = ""
    
    /// 첨부파일 경로
    var fileName         : String          = ""
    
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
        
        if json["aFileName"].stringValue != "" {
            fileName = json["aFileName"].stringValue
        }
        
        if json["nText"].stringValue != "" {
            text = json["nText"].stringValue
        }
    }
}

extension NoticeDetailInfo {
    var attributedText : NSAttributedString? {
        if let textData = text.data(using: .utf8, allowLossyConversion: false) {
            let theAttributedString = convertHtml(data: textData)
            return theAttributedString
        } else {
            return nil
        }
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
    
    func convertHtml(data: Data) -> NSAttributedString {
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding : String.Encoding.utf8.rawValue], documentAttributes:nil)
        } catch {
            return NSAttributedString()
        }
    }
}

extension String {
    func convertHtml() -> NSAttributedString {
        guard let data = data(using: .utf8) else {
            return NSAttributedString()
        }
        
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType : NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding : String.Encoding.utf8.rawValue], documentAttributes:nil)
        } catch {
            return NSAttributedString()
        }
    }
}
