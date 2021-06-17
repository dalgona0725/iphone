//
//  SuspensionPopupView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 29/11/2018.
//  Copyright © 2018 The E&M. All rights reserved.
//
import UIKit

class SuspensionPopupView: AlertPopupView {

    @IBOutlet weak var inquireButton: UIButton!
    @IBOutlet weak var inquireView: UIView!
    @IBOutlet weak var inquireViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainTextView: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var periodOfTimeLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    
    var defaultReasonHeight : CGFloat = 0
    
    var inquireAction : () -> Void = {}
    var doneAction : () -> Void = {}
    
    //MARK: - Class Func
    override class func instanceFromNib() -> SuspensionPopupView {
        return (Bundle.main.loadNibNamed("SuspensionPopupView", owner: self, options: nil)![0] as? SuspensionPopupView)!
    }
    
    //MARK: - UI Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        
        topPanel.backgroundColor    = popupMainColor
        closeButton.backgroundColor = popupMainColor
        
//        reasonLabel.backgroundColor = UIColor.lightGray
        
        dateLabel.text = ""
        periodOfTimeLabel.text = ""
        reasonLabel.text = ""
    
        self.defaultReasonHeight = self.reasonLabel.frame.height
        
        self.setLayerOutLine(borderWidth: 1, cornerRadius: 3)
        mainTextView.setLayerOutLine(borderWidth: 1, cornerRadius: 0, borderColor: UIColor.gray)
        inquireButton.setLayerOutLine(borderWidth: 1, cornerRadius: 0, borderColor: UIColor.gray)
    }
    
    func setup() {
        
        if userInfo.isLoginBlock {
           inquireViewHeightConstraint.constant = 0
           inquireView.isHidden = true
        }
        dateLabel.text = userInfo.blockRegDate
        periodOfTimeLabel.text = userInfo.blockPeriodDate
        reasonLabel.text = userInfo.blockMemo
        
        self.updateFrame()
        
    }
    
    override func updateFrame() {
        //let size = self.reasonLabel.sizeThatFits(CGSize(width: defaultWidth-16, height: CGFloat(MAXFLOAT)))
        let textRect = self.reasonLabel.calculateTextSize()
        
        //Update Frame
        //get label height changed
        let addInterval = self.reasonLabel.calculateMaxLines() * 2
        let heightChanged = max(Int(textRect.height) + addInterval, Int(defaultReasonHeight) )
        
        if inquireView.isHidden || heightChanged > Int(defaultReasonHeight) {
            
            var newHeight = self.frame.height + CGFloat(heightChanged) - defaultReasonHeight
            if inquireView.isHidden {
                newHeight = newHeight - 80.0
            }
            
            let newFrame = CGRect(x: 0, y: 0, width: Int(self.frame.width), height: Int(newHeight))
            self.frame = newFrame
        }
        orgSize = self.frame.size
    }

    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        if let center = self.window?.center {
            self.center = center
        }
        
        if orgSize.width != 0 && orgSize.height != 0 {
            if orgSize.height > UIScreen.main.bounds.height {
                self.frame.size = CGSize(width: orgSize.width, height: UIScreen.main.bounds.height)
                if let center = self.window?.center {
                    self.center = center
                }
            } else {
                self.frame.size = orgSize
            }
        }
    }
    
    
    func closeup() {
        self.hide()
        self.doneAction = { }
        self.inquireAction = { }
    }
    
    //MARK: - IBActions
    override func okAction(_ sender: AnyObject) {
        self.doneAction()
        dispatchMain.async {
            popupManager.hide(popup: self)
            self.closeup()
        }
    }
    
    override func closePopup() {
        dispatchMain.async {
            self.okAction(self)
        }
    }
    
    @IBAction func inquireAction(_ sender: Any) {
        self.inquireAction()
        dispatchMain.async {
            popupManager.hide(popup: self)
            self.closeup()
        }
    }
}

extension UILabel {
    var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
    
    func calculateMaxLines() -> Int {
        let maxSize = CGSize(width: self.frame.size.width, height: CGFloat(MAXFLOAT))
        let charSize = font.lineHeight
        let text = (self.text ?? "" ) as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font: font as Any], context: nil)
        let linesRoundedUp = Int(ceil(textSize.height/charSize))
        return linesRoundedUp
    }
    
    func calculateTextSize() -> CGRect {
        let maxSize = CGSize(width: self.frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "" ) as NSString
        let textSize = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes:[NSAttributedString.Key.font: font as Any], context: nil)
        return textSize
        
    }
}
