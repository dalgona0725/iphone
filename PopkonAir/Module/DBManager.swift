//
//  DBManager.swift
//  PopkonAir
//
//  Created by Brian Park on 2020/06/08.
//  Copyright © 2020 The E&M. All rights reserved.
//

import UIKit
import RealmSwift

enum sortKeyPath: String {
	case time = "time"	/// 등록일시
	case id   = "id"	/// 등록ID
}

enum ascending {
	case ascend		/// 오름차순
	case descend	/// 내림차순
	
	var bool: Bool {
		switch self {
		case .ascend:
			return false
		default:
			return true
		}
	}
}

class DBManager: NSObject {
	static let manager = DBManager()
	let realm = try! Realm()
	var searchData : Results<SearchHistoryList>?
	
	// 검색 히스토리 DB 추가
	func addSearchData(content: String) {
        removeDuplicateSearchData(content: content)
        
        let cnt = realm.objects(SearchHistoryList.self).count
        
        if cnt >= 20 {
            removelLastObject()
        }
		
		let db = SearchHistoryList()
		db.setUp(content: content)
		
		do {
			try realm.write {
				realm.add(db)
				print(realm.objects(SearchHistoryList.self))
			}
		}
		catch let e as NSError {
			print(e.localizedDescription)
		}

	}
	
	// DB 제거
	func removeSearchData(id: String) {
		// ID 값을 비교하여 DB에서 삭제
		let objects = realm.objects(SearchHistoryList.self).filter("id = '\(id)'")

		do {
			try realm.write {
				realm.delete(objects)
			}
		}
		catch let e as NSError {
			print(e.localizedDescription)
		}
	}
	
	func removeDuplicateSearchData(content: String) {
        guard realm.objects(SearchHistoryList.self).count > 0 else {
            return
        }
		// content 값을 비교하여 DB에서 삭제
		let objects = realm.objects(SearchHistoryList.self).filter("content = '\(content)'")
		
		do {
			try realm.write {
				realm.delete(objects)
			}
		}
		catch let e as NSError {
			print(e.localizedDescription)
		}
	}
	
    /// 가장 오래된 Object 삭제
    func removelLastObject() {
        if let lastObject = realm.objects(SearchHistoryList.self).sorted(byKeyPath: "time", ascending: false).last {
            do {
                try realm.write {
                    realm.delete(lastObject)
                }
            }
            catch let e as NSError {
                print(e.localizedDescription)
            }
        }
    }
	
	// DB 전체 삭제
	func deleteAll() {
		do {
			try realm.write {
				realm.deleteAll()
			}
		}
		catch let e as NSError {
			print(e.localizedDescription)
		}
	}
	
	// DB 정렬
	func sortByTime() {
		searchData = realm.objects(SearchHistoryList.self).sorted(byKeyPath: "time", ascending: false)
	}
	
	func filterBy(content: String) {
		let filterObject = realm.objects(SearchHistoryList.self).filter(NSPredicate(format: "content contains '\(content)'"))
		searchData = filterObject.sorted(byKeyPath: "time", ascending: false)
	}

}
