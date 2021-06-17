//
//  ChatTWTextCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 7. 29..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit

class ChatTWTextCell: UITableViewCell {

    @IBOutlet weak var fanIcon: LevelIconButton!
    @IBOutlet weak var levelIcon: LevelIconButton!
    @IBOutlet weak var mcIcon: LevelIconButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var nicknameStackView: UIStackView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageTopConstraint: NSLayoutConstraint!
    var message = Message() {
        didSet {
            resetupNicknameHeight()
        }
    }
    var onLongPressed : (Message) -> Void = { (msg) in }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.setLayerOutLine(borderWidth: 2, cornerRadius: 3, borderColor: UIColor.darkGray)
        self.selectedBackgroundView?.frame.size = self.frame.size
        self.selectedBackgroundView?.backgroundColor = UIColor.clear

        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(recognizer:)))
        //longPressGesture.minimumPressDuration = 1.0
        self.addGestureRecognizer(longPressGesture)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    @objc func handleLongGesture(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .recognized {
            onLongPressed(message)
        }
    }
    
    /// 팬레벨, 서비스레벨 초기화
    open func levelInit(service: Int, fan: Int, mc: Int) {
        levelIcon.setupLevelInfo(type: .service, level: service)
        fanIcon.setupLevelInfo(type: .fan, level: fan)
        mcIcon.setupLevelInfo(type: .mc, level: mc)
    }
    /// 닉네임 없는 경우 높이값 조절
    private func resetupNicknameHeight() {
        messageTopConstraint.constant = message.username == "" ? 5 : 25
        nicknameStackView.isHidden = message.username == "" ? true : false
    }
    
    func setPoliceMessage(fontScale: CGFloat) {
        let nameColor = UIColor(hexString: message.userNameColor)
        let msgColor = UIColor(hexString: message.textColor)
        let nameMsg = message.username
        let msg = String.removeLastEmptyLine(text: message.text)
        levelInit(service: 0, fan: 0, mc: 0)
        nicknameLabel.attributedText = getAttributMessage(nameText: nameMsg, nameColor: nameColor, bodyText: "", bodyColor: msgColor, fontScale: fontScale)
        messageLabel.attributedText = getAttributMessage(nameText: "", nameColor: nameColor, bodyText: msg, bodyColor:  msgColor, fontScale: fontScale)
        selectionStyle = .none
    }
}

// MARK:- Police Message manipulate
extension ChatTWTextCell {
    private func getAttributMessage(nameText: String, nameColor: UIColor, bodyText: String, bodyColor: UIColor, fontScale: CGFloat) -> NSAttributedString? {
        let totalAttributedStr = NSMutableAttributedString()
        
        var bodyFont = UIFont.notoFont(ofSize: 15 * fontScale )
        if nameText.isEmpty == false {
            // 쓰기방향 수정 - 아랍어 닉네임유저로 인해 텍스트 방향이 변경되는 문제로 인해 고정적으로 왼쪽에서 오른쪽으로 나오도록 수정.
            let nickAttr = NSAttributedString(string: nameText, attributes: [NSAttributedString.Key.font: UIFont.notoBoldFont(ofSize: 15 * fontScale) ,NSAttributedString.Key.foregroundColor: nameColor, NSAttributedString.Key.writingDirection: [NSWritingDirection.leftToRight.rawValue | NSWritingDirectionFormatType.override.rawValue] ])
            totalAttributedStr.append(nickAttr)
        } else {
            bodyFont = UIFont.notoMediumFont(ofSize: 15 * fontScale )
        }
        
        let idAttr = NSAttributedString(string: bodyText, attributes: [NSAttributedString.Key.font: bodyFont,NSAttributedString.Key.foregroundColor: bodyColor])
        totalAttributedStr.append(idAttr)
        
        return totalAttributedStr
    }
}
