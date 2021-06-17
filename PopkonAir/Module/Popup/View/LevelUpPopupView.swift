//
//  LevelUpPopupView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2020/12/02.
//  Copyright © 2020 The E&M. All rights reserved.
//


import UIKit

class LevelUpPopupView : PopupView {
    @IBOutlet weak var levelUpImageView: UIImageView!
    @IBOutlet weak var levelUpLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    var orgSize : CGSize = CGSize(width: 0, height: 0)
    var doneAction : () -> Void = {}
    
    //MARK: - Class Func
    class func instanceFromNib() -> LevelUpPopupView {
        return (Bundle.main.loadNibNamed("LevelUpPopupView", owner: self, options: nil)![0] as? LevelUpPopupView)!
    }
    
    //MARK: - UI Setup
    func setup(type: LevelType, level: Int) {
        if PARTNER_CODE == "P-00117" {
            levelUpImageView.image = UIImage(named:"icoLvup_celuv")
        }
        
        levelUpLabel.text = I18N.text_level_up.localized
        let str = NSMutableAttributedString(string: I18N.text_level_up_info01.localized, attributes: [NSAttributedString.Key.font : UIFont.notoLightFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black ])
        let add01 = NSAttributedString(string: " \(level)\n\(type.titleName())", attributes: [NSAttributedString.Key.font : UIFont.notoBoldFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black ])
        let add02 = NSAttributedString(string: I18N.text_level_up_info02.localized, attributes: [NSAttributedString.Key.font : UIFont.notoLightFont(ofSize: 14), NSAttributedString.Key.foregroundColor : UIColor.black ])
        str.append(add01)
        str.append(add02)
        infoLabel.attributedText = str
        
        okButton.backgroundColor = popupMainColor
        okButton.setTitle(I18N.ui_ok.localized, for: .normal)
        okButton.setTitleColor(.white, for: .normal)
        
        orgSize = self.frame.size
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
   
    func closeup() {
        self.doneAction()
        self.doneAction = { }
        dispatchMain.async {
            popupManager.hide(popup: self)
            self.hide()
        }
    }
    
    @IBAction func okAction(_ sender: UIButton) {
        self.closeup()
    }
    
    override func closePopup() {
        dispatchMain.async {
            self.closeup()
        }
    }
    
}

