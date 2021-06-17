//
//  CellUtil.swift
//  PopkonAir
//
//  Created by Steven on 11/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class CellUtil: NSObject {
    
    
    private class func getTimeText(dateString : String) -> String {
        // dateString 값예시. 20180823144912
        var strTime = ""
        
        /*
        let subStr1 = dateString
        let str1 = subStr1[subStr1.index(subStr1.startIndex, offsetBy: 8)...subStr1.index(subStr1.startIndex, offsetBy: 9)]
        let str2 = subStr1[subStr1.index(subStr1.startIndex, offsetBy: 10)...subStr1.index(subStr1.startIndex, offsetBy: 11)]
        if Int(str1)! > 12 {
            let strCalc = Int(str1)! - 12
            strTime = "PM " + String(strCalc) + ":" + str2 + " | "
        }else{
            strTime = "AM " + str1 + ":" + str2 + " | "
        } */
        
        let inDateForm = DateFormatter()
        inDateForm.dateFormat = "yyyyMMddHHmmss"
        if let dateTime = inDateForm.date(from: dateString) {
            let outDateForm = DateFormatter()
            outDateForm.timeStyle = .short
            outDateForm.dateFormat = "a hh:mm"
            strTime = outDateForm.string(from: dateTime) + " | "
        }
        return strTime
    }
    
    class func getNumberCommaFormat(text: String = "", numeral: Int = 0) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if text.isEmpty == false {
            if let price = Double(text) {
                if let result = numberFormatter.string(from: NSNumber(value:price)) {
                    return result
                }
            }
        } else {
            let price = Double(numeral)
            if let result = numberFormatter.string(from: NSNumber(value:price)) {
                return result
            }
        }
        
        return ""
    }
    
    class func getTimeAndWatchCntAttributeString(from cast : CastInfo, textColor:UIColor = UIColor.white) -> NSAttributedString {
        
        var str = NSMutableAttributedString(string: "")
        if cast.castStartDate.count == 14 {
            str = NSMutableAttributedString(string: CellUtil.getTimeText(dateString: cast.castStartDate),
                                            attributes: [NSAttributedString.Key.font : UIFont.notoFont(ofSize:(9.0)), NSAttributedString.Key.foregroundColor : textColor])
            
            if cast.watchCnt >= cast.limitNumber {
                let full = NSAttributedString(string: I18N.ui_full.localized , attributes: [NSAttributedString.Key.font : UIFont.notoBoldFont(ofSize:(9.0)), NSAttributedString.Key.foregroundColor : mainColor])
                
                str.replaceCharacters(in: NSRange(location: str.length-1, length: 0), with: full)
            }else {
                let watchCnt = NSAttributedString(string: CellUtil.getNumberCommaFormat(text: "\(cast.watchCnt)") + I18N.text_viewerCount.localized, attributes: [NSAttributedString.Key.font : UIFont.notoFont(ofSize:(9.0)), NSAttributedString.Key.foregroundColor : textColor])
                str.replaceCharacters(in: NSRange(location: str.length-1, length: 0), with: watchCnt)
            }
            
        }
        
        return str
    }
    
    class func getDateString(with text: String) -> String {
        //text    String    "20180821 오전 8:47:47"    
        var range = text.index(text.startIndex, offsetBy: 0)..<text.index(text.startIndex, offsetBy: 4)
        let year = String(text[range])

        range = text.index(text.startIndex, offsetBy: 4)..<text.index(text.startIndex, offsetBy: 6)
        let month = String(text[range])
        
        range = text.index(text.startIndex, offsetBy: 6)..<text.index(text.startIndex, offsetBy: 8)
        let day = String(text[range])
        
        return year + "." + month + "." + day
    }
    
    class func getFullDateString(with text:String) -> String {
        
        let inDateForm = DateFormatter()
        inDateForm.dateFormat = "yyyyMMddHHmmss"
        var fullDateString = ""
        if let dateTime = inDateForm.date(from: text) {
            let outDateForm = DateFormatter()
            outDateForm.timeStyle = .short
            outDateForm.dateFormat = "yyyy.MM.dd HH:mm:ss"
            fullDateString = outDateForm.string(from: dateTime)
        }
        
        return fullDateString
    }
    
    
    class func getFlags(from cast:CastInfo)-> [FlagType] {
        var flags : [FlagType] = []
        if cast.castType == .pay {
            flags.append(.pay)
        }
        if cast.castType == .fanClub {
            flags.append(.fan)
        }
        if cast.isAdult {
            flags.append(.adult)
        }
        return flags
    }
}
