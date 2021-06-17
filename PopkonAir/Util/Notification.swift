//
//  Notification.swift
//  PopkonAir
//
//  Created by roy on 2016. 8. 14..
//  Copyright © 2016년 roy. All rights reserved.
//
import UIKit

//@objc public protocol NotificationDelegate {
//    optional func socketDidConnect()
//	optional func socketDidDisconnect()
//    
//    optional func httpRespondToGetLogInSuccess(data: Dictionary<String, AnyObject>)
//    optional func httpRespondToGetLogInFail(data: Dictionary<String, AnyObject>)
//    
//}


//class Notification: NSObject {
//	
//	var target: AnyObject!
//	
//	//////////////////////////////////////////////////
//	// MARK: - Initialization
//	//////////////////////////////////////////////////
//	
//	init(_ target: AnyObject) {
//		self.target = target
//	}
//	
//	deinit {
//		removeAllNotification()
//	}
//	
//	//////////////////////////////////////////////////
//	
//	
//	
//	//////////////////////////////////////////////////
//	// Notification registration
//	//////////////////////////////////////////////////
//	func addAllNotification() {
//		// Socket Notification
//		// Socket Connect/Disconnect
//		
//		// HTTP Notification
//		// Login
//        NotificationCenter.default.addObserver(self.target, selector: Selector(("httpRespondToGetLogInSuccess:")), name: NSNotification.Name(rawValue: HTTPRespondToGetLogInSuccessNotification), object: nil)
//        NotificationCenter.default.addObserver(self.target, selector: Selector(("httpRespondToGetLogInFail:")), name: NSNotification.Name(rawValue: HTTPRespondToGetLogInFailNotification), object: nil)
//        NotificationCenter.default.addObserver(self.target, selector: Selector(("httpRespondToGetMainLiveListSuccess:")), name: NSNotification.Name(rawValue: HTTPRespondToGetMainLiveListSuccessNotification), object: nil)
//        NotificationCenter.default.addObserver(self.target, selector: Selector(("httpRespondToGetMainLiveListFail:")), name: NSNotification.Name(rawValue: HTTPRespondToGetMainLiveListFailNotification), object: nil)
//        NotificationCenter.default.addObserver(self.target, selector: Selector(("httpRespondToGetHomeLiveListSuccess:")), name: NSNotification.Name(rawValue: HTTPRespondToGetHomeLiveListSuccessNotification), object: nil)
//        NotificationCenter.default.addObserver(self.target, selector: Selector(("httpRespondToGetHomeLiveListFail:")), name: NSNotification.Name(rawValue: HTTPRespondToGetHomeLiveListFailNotification), object: nil)
//        NotificationCenter.default.addObserver(self.target, selector: Selector(("httpRespondToGetCastWatchOnOffSuccess:")), name: NSNotification.Name(rawValue: HTTPRespondToGetCastWatchOnOffSuccessNotification), object: nil)
//        NotificationCenter.default.addObserver(self.target, selector: Selector(("httpRespondToGetCastWatchOnOffFail:")), name: NSNotification.Name(rawValue: HTTPRespondToGetCastWatchOnOffFailNotification), object: nil)
//		
//		// Get Server Info
//	    }
//	
//	func removeAllNotification() {
//		
//        
//        NotificationCenter.default.removeObserver( self.target, name: NSNotification.Name(rawValue: HTTPRespondToGetLogInSuccessNotification), object:nil)
//        NotificationCenter.default.removeObserver( self.target, name: NSNotification.Name(rawValue: HTTPRespondToGetLogInFailNotification), object:nil)
//        NotificationCenter.default.removeObserver( self.target, name: NSNotification.Name(rawValue: HTTPRespondToGetMainLiveListSuccessNotification), object:nil)
//        NotificationCenter.default.removeObserver( self.target, name: NSNotification.Name(rawValue: HTTPRespondToGetMainLiveListFailNotification), object:nil)
//        NotificationCenter.default.removeObserver( self.target, name: NSNotification.Name(rawValue: HTTPRespondToGetHomeLiveListSuccessNotification), object:nil)
//        NotificationCenter.default.removeObserver( self.target, name: NSNotification.Name(rawValue: HTTPRespondToGetHomeLiveListFailNotification), object:nil)
//        NotificationCenter.default.removeObserver( self.target, name: NSNotification.Name(rawValue: HTTPRespondToGetCastWatchOnOffSuccessNotification), object:nil)
//        NotificationCenter.default.removeObserver( self.target, name: NSNotification.Name(rawValue: HTTPRespondToGetCastWatchOnOffFailNotification), object:nil)
//        
//    }
//}
