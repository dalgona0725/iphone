//
//  CellularPopupView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 25/07/2019.
//  Copyright © 2019 The E&M. All rights reserved.
//

import Foundation

class PushItemPopupView: PopupView {
    @IBOutlet weak var topPanel: UIView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet private weak var checkButton: UIButton!
    @IBOutlet private weak var okButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    ///ContentLabel Default Height
    private let defaultWidth : CGFloat = 331
    private let defaultBottomHeight = 51
    private let defaultTopHeight = 116
    private let defaultTopLabelHeight = 43
    
    private var buttonActions : [()->Void] = []
    var orgSize : CGSize = CGSize(width: 0, height: 0)
    
    //MARK: - Class Func
    class func instanceFromNib() -> PushItemPopupView {
        return (Bundle.main.loadNibNamed("PushItemPopupView", owner: self, options: nil)![0] as? PushItemPopupView)!
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
    
    //MARK: - UI Setup
    func setup(actions : [()->Void]) {
        
        self.setLayerOutLine(borderWidth: 1, cornerRadius: 3)
        
        self.contentLabel.text = "안녕하세요\n지금 LTE망을 사용중입니다.\n이것은 테스트용도 글자입니다. 다들 조심히쓰세요. 그럼 안녕하....!"
        setButtonActions(actions: actions)
        
        okButton.backgroundColor = popupMainColor
        
        self.updateFrame()
        
    }
    
    func setButtonActions(actions : [()->Void]) {
        buttonActions = actions
    }
    
    func updateFrame() {
        let size = self.contentLabel.sizeThatFits(CGSize(width: defaultWidth-44, height: 400))
        
        //Update Frame
        let remainSpaceSize = defaultTopHeight - defaultTopLabelHeight
        let heightChanged = max(Int(size.height)+remainSpaceSize, defaultTopHeight )
        if defaultBottomHeight + heightChanged != Int(self.frame.height) ||
            defaultWidth != self.frame.width {
            let newFrame = CGRect(x: 0, y: 0, width: Int(defaultWidth), height: defaultBottomHeight + heightChanged )
            self.frame = newFrame
        }
        orgSize = self.frame.size
    }

    //MARK: - IBActions
    @IBAction func checkAction(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
    
    @IBAction func cancelAction(_ sender: AnyObject) {
        if self.buttonActions.count > 1 {
            self.buttonActions[1]()
        }        
        self.buttonActions.removeAll()
    }
    @IBAction func okAction(_ sender: AnyObject) {
        if self.buttonActions.count > 0 {
            self.buttonActions[0]()
        }
        
        if checkButton.isSelected {
            appData.isNoticeLTE = false
        }
        
        self.buttonActions.removeAll()
    }
    
    override func closePopup() {
        dispatchMain.async {
            self.cancelAction(self)
        }
    }
}
