//
//  ShoutTextView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 2. 2..
//  Copyright © 2018년 eugene. All rights reserved.
//

import Foundation

struct ShoutInfo {
    var nickName = ""
    var signId   = ""
    var message  = ""
}

class ShoutTextView : UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var shoutTextLabel: SingleShotOffscreenLabel!
    
    var onFinished : () -> Void = {  }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        shoutTextLabel.text = ""
        shoutTextLabel.type = .leftRight
        shoutTextLabel.scrollDuration = 10.0
        shoutTextLabel.scrollDoneBlock = {
            UIView.animate(withDuration: 0.5, animations: {
                self.alpha = 0
            }, completion: { (succeed) in
                self.isHidden = true
                self.onFinished()
            })
            
        }
    }
    
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
        let nib = UINib(nibName: "ShoutTextView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        self.addSubview(contentView)        
    }
    
    
    func setText(info: ShoutInfo) {
        let text = "\(info.nickName)(\(info.signId)) \(info.message)"
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(.foregroundColor, value: UIColor.RGBColor(red: 250, green: 196, blue: 0), range: (text as NSString).range(of:info.nickName))
        attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .bold), range: (text as NSString).range(of: info.nickName))
        shoutTextLabel.attributedText = attributedString
        
        shoutTextLabel.leadingBuffer = frame.width - 50
        shoutTextLabel.trailingBuffer = frame.width
    }
    
    func unSetup() {
        onFinished = {   }
        shoutTextLabel.scrollDoneBlock = {   }
    }
    
}
