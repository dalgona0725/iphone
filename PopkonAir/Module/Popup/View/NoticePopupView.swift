//
//  NoticePopupView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 06/11/2018.
//  Copyright © 2018 The E&M. All rights reserved.
//

class NoticePopupView: PopupView {
    
    private let defaultWidth : CGFloat = 331
    private let defualtViewHeight : CGFloat = 147
    
    @IBOutlet weak var topPanel: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    var orgSize : CGSize = CGSize(width: 0, height: 0)
    
    //MARK: - Class Func
    class func instanceFromNib() -> NoticePopupView {
        return (Bundle.main.loadNibNamed("NoticePopupView", owner: self, options: nil)![0] as? NoticePopupView)!
    }
    
    //MARK: - UI Setup
    func setup(content:String) {
        self.setLayerOutLine(borderWidth: 1, cornerRadius: 3)
        self.contentLabel.text = content
        self.updateFrame()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let center = self.window?.center {
            self.center = center
        }
        
        if orgSize.width != 0 && orgSize.height != 0 {
            self.frame.size = orgSize
        }
    }
    
    func updateFrame() {
        
        let size = self.contentLabel.sizeThatFits(CGSize(width: defaultWidth-16, height: defualtViewHeight))
        
        //Update Frame
        let heightChanged = max(Int(size.height) + 20, Int(defualtViewHeight) )
        let newFrame = CGRect(x: 0, y: 0, width: Int(defaultWidth), height: heightChanged )
        self.frame = newFrame
        
        orgSize = self.frame.size
    }
    
    
    func updateContent(text: String) {
        self.contentLabel.text = text
    }
    
    override func closePopup() {
        dispatchMain.async {
            self.hide()
        }
    }
}
