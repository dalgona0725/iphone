//
//  NewsInfo.swift
//  PopkonAir
//
//  Created by Brian Park on 27/08/2019.
//  Copyright © 2019 The E&M. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewsInfo: NSObject {
	// 제목
	var title 	= ""
	// 내용
	var content = ""
	// 링크
	var link 	= ""
	// 이미지 URL
	var imgUrl 	= ""
	// 게시일자 코드
	var date 	= ""
	
	open func setInfo(json : JSON) {
		log.debug(json)
		
		title 	= json["newsTitle"].stringValue
		content = json["newsContent"].stringValue
		link 	= json["newsLink"].stringValue
		imgUrl 	= json["imgUrl"].stringValue
		date 	= json["pubDate"].stringValue
	}

}
