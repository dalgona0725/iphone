//
//  PoliceChatSimpleView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 02/05/2019.
//  Copyright © 2019 The E&M. All rights reserved.
//

import Foundation

// MARK:- Chat Warning Protocol
protocol PoliceWarningProtocol {
    func addChatMessage(msg: Message, nNickType: NickTextColor, nChatType: ChatTextColor)
    func adddGeneralMessage(msg: String, msgColor: String, chatType:ChatTextColor)
}

class PoliceChatSimpleView: UIView, PoliceWarningProtocol {
    // 테이블뷰
    // 마스터 계정을 제외한 나머지 계정은 채팅 불가  -> " 채팅 사용 불가" placeholder.
    // 유저채팅창과 폴리스채팅창 모두 디폴트 사이즈로 고정 (조절 기능 off)
    // 채팅창 [닫기] 눌러도 폴리스 채팅창은 유지
    // 채팅창 얼리기(클린캠페인 종료시) 폴리스 채팅창 숨김 . 기존 유저 채팅창 사이즈 현재 유지 (조절 기능 on)
    
    // MARK:- Properties
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var chatTableView: UITableView!

    var messages = [Message]()
    let fontScale : CGFloat = 1.0

    
    // MARK:- View init
    override init(frame: CGRect) {
        //nibType = String(describing: type(of: self))
        super.init(frame: frame)
        initFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        //nibType = String(describing: type(of: self))
        super.init(coder: aDecoder)
        initFromXIB()
    }

    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    private func initFromXIB() {
        //let bundle = Bundle(for: type(of: self))
        //let nib = UINib(nibName: nibType, bundle: bundle)
        contentView = loadViewFromNib() // nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        self.frame.size = CGSize(width: self.frame.width, height:  contentView.frame.height)
        
        self.backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        self.addSubview(contentView)
        
        self.chatTableView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.chatTableView.estimatedRowHeight = 20;
        self.chatTableView.separatorStyle = .none
        self.chatTableView.register(UINib(nibName: "ChatTWTextCell", bundle: Bundle.main), forCellReuseIdentifier: "ChatTWTextCell" )
        self.chatTableView.dataSource   = self
        self.chatTableView.delegate     = self
    }
    
    // MARK:- Message Add/Clear
    func addChatMessage(msg: Message, nNickType: NickTextColor, nChatType: ChatTextColor) {
        let indexPath = IndexPath(row: messages.count, section: 0)
        let scrollPosition: UITableView.ScrollPosition = .bottom
        var message = msg
        if msg.userNameColor.isEmpty {
            message.userNameColor = nNickType.getColorString()
        }
        if msg.textColor.isEmpty {
            message.textColor = nChatType.getColorString()
        }
        self.messages.append(message)
        
        if self.chatTableView.contentOffset.y == 0 {
            self.chatTableView.reloadData()
            self.chatTableView.scrollToRow(at: indexPath, at: scrollPosition, animated: false)
        }else {
            if !chatTableView.isDragging   && Int(chatTableView.decelerationRate.rawValue) == 0 {
                self.chatTableView.reloadData()
                self.chatTableView.scrollToRow(at: indexPath, at: scrollPosition, animated: true)
            }
        }
        
        //log.debug("offset: \(self.tableView.contentOffset), contentSize: \(self.tableView.contentSize)")
    }
    
    func adddGeneralMessage(msg: String, msgColor: String, chatType:ChatTextColor) {
        let indexPath = IndexPath(row: messages.count, section: 0)
        let scrollPosition: UITableView.ScrollPosition = .bottom
        var message = Message()
        message.username = ""
        message.text = msg
        message.textColor = msgColor.isEmpty ? chatType.getColorString() : msgColor
        self.messages.append(message)
        
        if self.chatTableView.contentOffset.y == 0 {
            self.chatTableView.reloadData()
            self.chatTableView.scrollToRow(at: indexPath, at: scrollPosition, animated: false)
        }else {
            if !chatTableView.isDragging  && Int(chatTableView.decelerationRate.rawValue) == 0 {
                self.chatTableView.reloadData()
                self.chatTableView.scrollToRow(at: indexPath, at: scrollPosition, animated: true)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
        chatTableView.reloadData()
    }
}

extension PoliceChatSimpleView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row >= self.messages.count {
            return UITableViewCell()
        }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "ChatTWTextCell") as? ChatTWTextCell {
            let message = self.messages[(indexPath as NSIndexPath).row]
            cell.message = message
            cell.setPoliceMessage(fontScale: fontScale)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
