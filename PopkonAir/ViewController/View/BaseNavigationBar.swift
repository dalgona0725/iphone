//
//  BaseNavigationBar.swift
//  PopkonAir
//
//  Created by Steven on 25/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

enum NavigationBarType : Int {
    case normal         = 0
    case logo           = 1
    case search         = 2
    case vod            = 3
    case webView        = 4
    case myInfo         = 5
}

enum NavigationBarButtonType : String {
    case none       = "none"
    case broadcast  = "iconCast"
    case search     = "iconSearch"
    case close      = "iconClose"
    case favorite   = "favorit2"
    case rotate     = "rotate"
}

struct BarButtonInfo {
    var type : NavigationBarButtonType = .none
    var actionHandler  : (_ sender : UIButton)->Void  = {sender in }
}

protocol SearchDelegate {
    func hideResult()
}

class BaseNavigationBar: UIView {
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var titleLabel: UILabel!
    
    @IBOutlet private weak var logoButton: UIButton!
    
    @IBOutlet private weak var statusBarView: UIView!
    
    @IBOutlet var rightButtons: [UIButton]!
    
    @IBOutlet weak var roundButton: RoundButton!
    @IBOutlet weak var searchText: SearchHistoryTextfield!
    
    @IBOutlet weak var statusBarHeightConstraint: NSLayoutConstraint!
    var maxSearchTextNum: Int = 20
    let defaultBarHeight : CGFloat = 64
    
    var rightButtonInfos : [BarButtonInfo] = [] {
        didSet {
            setupRightButtons()
        }
    }
    
    var delegate: SearchDelegate?
    
    var backAction      = {() in }
    var logoAction      = {() in }
    var roundAction   : (_ sender : UIButton)->Void  = {sender in }
    
    var searchShoulReturnAction  : (_ textField : UITextField)->Bool  = {textField in return true}
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    //MARK: - Class Func
    class func instanceFromNib() -> BaseNavigationBar {
        return (Bundle.main.loadNibNamed("BaseNavigationBar", owner: self, options: nil)![0] as? BaseNavigationBar)!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.statusBarView.backgroundColor = statusBarBgColor
        self.backgroundColor = mainColor
        
        roundButton.setRoundBorder(with: roundBorderColor)
        roundButton.setRoundText(with: roundTextColor)
        
        for button in rightButtons {
            button.isHidden = true
        }
        
        roundButton.isHidden = true
        logoButton.isHidden = true
        searchText.isHidden = true
        
        logoButton.imageView?.contentMode = .scaleToFill
        
        titleLabel.textColor = titleTextColor
        searchText.textColor = baseBartextFieldTextColor
        if searchText.placeholder != nil && searchText.font != nil {
            searchText.attributedPlaceholder = NSAttributedString(string: I18N.ui_serachPlaceholder.localized, attributes: [NSAttributedString.Key.font : searchText.font!, NSAttributedString.Key.foregroundColor : baseBartextFieldTextColor.withAlphaComponent(0.6)] )
        }
        
        statusBarHeightConstraint.constant = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 20.0
        
        searchText.textfieldDelegate = self
    }
        
    //MARK: - UI Setup
    func setBar(with type : NavigationBarType) {
        
        searchText.text = ""
        for button in rightButtons {
            button.isHidden = true
        }
        
        switch type {
        case .normal:
            titleLabel.isHidden = false
            roundButton.isHidden = true
            logoButton.isHidden = true
            searchText.isHidden = true
            backButton.setImage(UIImage(named: "iconBackArrow"), for: .normal)
            
        case .logo:
            titleLabel.isHidden = true
            roundButton.isHidden = true
            logoButton.isHidden = false
            searchText.isHidden = true
            backButton.setImage(UIImage(named: "iconMypage"), for: .normal)
            
        case .search:
            titleLabel.isHidden = true
            roundButton.isHidden = true
            logoButton.isHidden = true
            searchText.isHidden = false
            searchText.buildSearchTableView()
            backButton.setImage(UIImage(named: "iconBackArrow"), for: .normal)
            
        case .vod:
            titleLabel.isHidden = true
            roundButton.isHidden = true
            logoButton.isHidden = false
            searchText.isHidden = true
            backButton.setImage(UIImage(named: "iconMypage"), for: .normal)
            
        case .webView:
            titleLabel.isHidden = true
            roundButton.isHidden = true
            logoButton.isHidden = false
            searchText.isHidden = true
            backButton.setImage(UIImage(named: "iconMypage"), for: .normal)
        
        case .myInfo:
            titleLabel.isHidden = false
            roundButton.isHidden = true
            logoButton.isHidden = true
            searchText.isHidden = true
            backButton.setImage(UIImage(named: "iconBackArrow"), for: .normal)
            
        }
    }
    
    func setTitle(with text : String) {
        titleLabel.text = text
    }
    func setAttributTitle(with text: NSAttributedString) {
        titleLabel.attributedText = text
    }
    
    private func setupRightButtons() {
        for (index, info) in rightButtonInfos.enumerated() {
            let button = rightButtons[index]
            
            button.isHidden = false
            button.tag = index
            
            if info.type == .favorite {
                button.isSelected = true
                button.setImage(#imageLiteral(resourceName: "iconFavorites"), for: .normal)
            }else {
                button.isSelected = false
                button.setImage(UIImage(named: info.type.rawValue), for: .normal)
                button.setImage(UIImage(named: info.type.rawValue), for: .selected)
            }
        }
    }
    
    
    func setRoundTitle(with text: String, controlState : UIControl.State) {
//        self.roundButton.isHidden = false
        self.roundButton.setTitle(text, for: controlState)
    }
    
    
    func setBackButton(hidden : Bool) {
        backButton.isHidden = hidden
    }
    
    //MARK: - IBActions
    @IBAction private func backAction(_ sender: AnyObject) {
        self.backAction()
    }
    
    @IBAction private func logoAction(_ sender: AnyObject) {
        self.logoAction()
    }
    
    @IBAction private func rightAction(_ sender: UIButton) {
        if sender.tag >= rightButtons.count {
            return
        }
        
        let info = rightButtonInfos[sender.tag]
        info.actionHandler(sender)
    }
    
    @IBAction private func roundAction(_ sender: AnyObject) {
        self.roundAction(sender as! UIButton)
    }
}

extension BaseNavigationBar : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if newString.isEmpty {
            delegate?.hideResult()
        }
        
        var currentCharacterCount = textField.text?.count ?? 0
        if let text = textField.text {
            if text.needComposedCounting() {
                currentCharacterCount = text.composedCount
            }
            
            for scalar in text.unicodeScalars {
                log.debug("\(scalar) : \(scalar.value)")
            }
        }
        
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        
        var addCharacterCount = string.count
        if string.needComposedCounting() {
            addCharacterCount = string.composedCount
        }
        let newLength = currentCharacterCount + addCharacterCount - range.length
        
        return newLength <= maxSearchTextNum

    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {        
        return searchShoulReturnAction(textField)
    }
}

extension BaseNavigationBar: SearchTextFieldDelegate {
    func setSearchRightCloseButton() {
        self.rightButtonInfos = [BarButtonInfo(type: .close, actionHandler: { (sender) in
            self.searchText.text = ""
            self.delegate?.hideResult()
            self.searchText.reloadTableview()
        })]
    }
}
