//
//  chatColorConstraint.swift
//  PopkonAir
//
//  Created by roypark on 31/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

let chatSuper:String = "#ffe59e"
let chatGeneral:String = "#ffffff"
let chatPopGift:String = "#fff700"
let chatMaster:String = "#fc7905"
let chatManager:String = "#ffe59e"
let chatVip:String = "#00ff9f"
let chatFan:String = "#f78b00"
let chatRecommend:String = "#faa700"
let chatPolice:String = "#ff0000"
let chatOut:String = "#ffe59e"
let nickMasterBoy:String = "#8a00ff"
let nickManager:String = "#0090ff"
let nickMasterGirl:String = "#ff6060"
let nickBoy:String = "#09b1ff"
let nickGirl:String = "#ff6060"
let nickPolice:String = "#09b1ff"
let nickSuper:String = "#fc7905"

var chatUserColor: [String] = [chatSuper,
                               chatGeneral,
                               chatPopGift,
                               chatMaster,
                               chatManager,
                               chatVip,
                               chatFan,
                               chatRecommend,
                               chatPolice,
                               chatOut,
                               nickMasterBoy,
                               nickManager,
                               nickMasterGirl,
                               nickBoy,
                               nickGirl,
                               nickPolice,
                               nickSuper]

//<item>@color/chatSuper</item>
//<item>@color/chatGeneral</item>
//<item>@color/chatPopGift</item>
//<item>@color/chatMaster</item>
//<item>@color/chatManager</item>
//<item>@color/chatVip</item>
//<item>@color/chatFan</item>
//<item>@color/chatRecommend</item>
//<item>@color/chatPolice</item>
//<item>@color/chatOut</item>
//<item>@color/nickMasterBoy</item>
//<item>@color/nickManager</item>
//<item>@color/nickMasterGirl</item>
//<item>@color/nickBoy</item>
//<item>@color/nickGirl</item>
//<item>@color/nickPolice</item>

enum ChatTextColor : Int {
    case chatSuper = 0
    case general
    case popGift
    case recommend
    case chatMaster
    case chatManager
    case chatVip
    case chatFan
    case chatPolice
    case chatOut
    case chatNotice
    case castNotice
    
    func getColorString() -> String {
        switch  self {
        case .chatSuper:
            return "#ffe59e"
        case .general:
            return "#ffffff"
        case .popGift:
            return "#fff700"
        case .recommend:
            return "#faa700"
        case .chatMaster:
            return "#fc7905"
        case .chatManager:
            return "#ffe59e"
        case .chatVip:
            return "#00ff9f"
        case .chatFan:
            return "#f78b00"
        case .chatPolice:
            return "#ff0000"
        case .chatOut:
            return "#ffe59e"
        case .chatNotice:
            return "#00f6ff"
        case .castNotice:
            return "#00f6ff"
        }
    }
    
}

enum NickTextColor : Int {
    case boy        = 0
    case girl
    case masterBoy
    case masterGirl
    case manager
    case police
    case nickSuper
    
    func getColorString() -> String {
        switch  self {
        case .boy:
            return "#09b1ff"
        case .girl:
            return "#ff6060"
        case .masterBoy:
            return "#09b1ff"  // "#8a00ff"  방송자 상관없이 성별 색상으로 통일 2018.10.04
        case .masterGirl:
            return "#ff0000"  // "#ff0000" 2020.04.22 색상 변경
        case .manager:
            return "#0090ff"
        case .police:
            return "#09b1ff"
        case .nickSuper:
            return "#fc7905"
        }
    }
}

