//
//  EventWebView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 12. 20..
//  Copyright © 2017년 eugene. All rights reserved.
//
import Foundation
import WebKit

class EventWebView : UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var topBar: UIView!
    @IBOutlet weak var webContentView: UIView!
    
    var webView : WKWebView!
    
    var onCloseView : () -> Void = { }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
    }

    private func initFromXIB() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "EventWebView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        self.addSubview(contentView)
        
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.frame = webContentView.bounds
        webView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        //webView.uiDelegate = self
        webContentView.addSubview(webView)
        
        //self.backgroundColor = UIColor.black
        self.topBar.backgroundColor = mainColor
        self.contentView.backgroundColor =  UIColor.black //statusBarBgColor
    }
    
    func setup(linkUrl: String) {
        if let myURL = URL(string: linkUrl) {
            let myRequest = URLRequest(url: myURL)
            webView.load(myRequest)
        }
    }
    
    @IBAction func exitAction(_ sender: Any) {
        onCloseView()
        onCloseView = { }
        self.removeFromSuperview()
        
    }
}

//extension EventWebView : WKUIDelegate {
//}

