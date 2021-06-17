//
//  SearchHistoryList.swift
//  PopkonAir
//
//  Created by Brian Park on 2020/06/08.
//  Copyright © 2020 The E&M. All rights reserved.
//

import UIKit
import RealmSwift

// 검색 내역 모델
class SearchHistoryList: Object {
	@objc dynamic var id = UUID().uuidString
	@objc dynamic var content = ""
	@objc dynamic var time: Date = Date()

	override class func primaryKey() -> String {
		return "id"
	}
	
	func setUp(content: String?) {
		if let content = content{
			self.content = content
		}
	}
}
