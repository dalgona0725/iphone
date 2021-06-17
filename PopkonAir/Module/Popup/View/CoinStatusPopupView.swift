//
//  CoinStatusPopupView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 5. 30..
//  Copyright © 2018년 eugene. All rights reserved.
//
import UIKit

class CoinStatusPopupView: AlertPopupView {
    
    //let defaultWidth = UIScreen.main.bounds.width - 40
    //let defaultWidth = UIScreen.main.bounds.width * 0.88
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    @IBOutlet weak var vipTextHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var vipTextMarginConstraint: NSLayoutConstraint!
    @IBOutlet weak var vipTopicLabel: UILabel!
    @IBOutlet weak var topicLabel: UILabel!
    @IBOutlet weak var topicTitleLabel: UILabel!
    
    @IBOutlet weak var dayTitleLabel: UILabel!
    @IBOutlet weak var monthTitleLabel: UILabel!
    @IBOutlet weak var dayUseLabel: UILabel!
    @IBOutlet weak var monthUseLabel: UILabel!

    var doneAction : () -> Void = {}
    
    //MARK: - Class Func
    override class func instanceFromNib() -> CoinStatusPopupView {
        return (Bundle.main.loadNibNamed("CoinStatusPopupView", owner: self, options: nil)![0] as? CoinStatusPopupView)!
    }
    
    //MARK: - UI Setup
    override func awakeFromNib() {
        super.awakeFromNib()
        topPanel.backgroundColor = popupMainColor
        
        dayTitleLabel.setLayerOutLine(borderWidth: 1, cornerRadius: 0, borderColor: UIColor.gray)
        monthTitleLabel.setLayerOutLine(borderWidth: 1, cornerRadius: 0, borderColor: UIColor.gray)
        dayUseLabel.setLayerOutLine(borderWidth: 1, cornerRadius: 0, borderColor: UIColor.gray)
        monthUseLabel.setLayerOutLine(borderWidth: 1, cornerRadius: 0, borderColor: UIColor.gray)
        
        monthUseLabel.text = ""
        dayUseLabel.text = ""
        
    }
    
    func setup(coinStatusInfo : CoinStatusInfo) {
        
        topicTitleLabel.text = "\(coinName)선물 한도 제한 안내"
        topicLabel.text = "\(coinName)선물 한도 개수를 초과하였습니다.\n(선물한도 확인 후 다시 이용해 주세요.)"
        
        if coinStatusInfo.isVip == false {            
            vipTextHeightConstraint.constant = 0
            vipTextMarginConstraint.constant = 0
            vipTopicLabel.isHidden = true
        }
        
        let dayAttriubteString = NSMutableAttributedString(string: "\(CellUtil.getNumberCommaFormat(numeral: coinStatusInfo.dayLimit))개\r", attributes: [
            NSAttributedString.Key.font: UIFont.notoFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3058636189, green: 0.3058716059, blue: 0.3058673143, alpha: 1),
            ])
        let daytopic1 = NSAttributedString(string: "(매일 00시 갱신)\r\r", attributes: [
            NSAttributedString.Key.font: UIFont.notoFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.585175693, green: 0.5851898789, blue: 0.5851822495, alpha: 1)])
        dayAttriubteString.append(daytopic1)
        let daytopic2 = NSAttributedString(string: "\(CellUtil.getNumberCommaFormat(numeral: coinStatusInfo.dayUse))개 선물", attributes: [
            NSAttributedString.Key.font: UIFont.notoFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3058636189, green: 0.3058716059, blue: 0.3058673143, alpha: 1)])
        dayAttriubteString.append(daytopic2)
        dayUseLabel.attributedText = dayAttriubteString
        
        let monthAttributeString = NSMutableAttributedString(string: "\(CellUtil.getNumberCommaFormat(numeral: coinStatusInfo.monthLimit))개\r", attributes: [
            NSAttributedString.Key.font: UIFont.notoFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3058636189, green: 0.3058716059, blue: 0.3058673143, alpha: 1),
            ])
        let monthtopic1 = NSAttributedString(string: "(매월 1일 갱신)\r\r", attributes: [
            NSAttributedString.Key.font: UIFont.notoFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.585175693, green: 0.5851898789, blue: 0.5851822495, alpha: 1)])
        monthAttributeString.append(monthtopic1)
        let monthtopic2 = NSAttributedString(string: "\(CellUtil.getNumberCommaFormat(numeral: coinStatusInfo.monthUse))개 선물", attributes: [
            NSAttributedString.Key.font: UIFont.notoFont(ofSize: 12),
            NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.3058636189, green: 0.3058716059, blue: 0.3058673143, alpha: 1)])
        monthAttributeString.append(monthtopic2)
        monthUseLabel.attributedText = monthAttributeString
        
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
    }
    
    //MARK: - IBActions
    override func okAction(_ sender: AnyObject) {
        //self.closeup()
        self.doneAction()
        dispatchMain.async {
            popupManager.hide(popup: self)
            self.closeup()
        }
        self.doneAction = { }
    }
    
    override func closePopup() {
        dispatchMain.async {
            self.okAction(self)
        }
    }
}
