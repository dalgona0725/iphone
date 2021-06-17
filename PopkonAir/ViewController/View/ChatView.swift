//
//  ChatView.swift
//  PopkonAir
//
//  Created by Steven on 21/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import SlackTextViewController

class ChatView: UIView {

    let messageVC : MessageViewController = MessageViewController()
    
    // 채팅 드래그 표시 관련
    var arrowImageView = UIImageView()
    var oldPinchScale : CGFloat = 1
    var onDragChatView : (_ gesture: UIPanGestureRecognizer) -> Void = { panGesture in }
    
    var keyboardChangeHandler = {
        (_ status: SLKKeyboardStatus) -> Void in
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Set BG Color to clear
        self.backgroundColor = UIColor.black
        messageVC.view.backgroundColor = UIColor.clear
        messageVC.tableView.clipsToBounds = true
        messageVC.tableView.layer.masksToBounds = true
        
        messageVC.textView.maxNumberOfLines = 1
        messageVC.textView.isDynamicTypeEnabled = false 
        
        //messageVC.tableView.backgroundColor = UIColor.clear
        //messageVC.tableView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3)
        self.addSubview(messageVC.view)
        
        // 채팅영역 조절 기능관련.
        let dragButton = UIButton(frame: CGRect(x: 20, y: 0, width: self.frame.width - 40, height: 30))
        dragButton.autoresizingMask = [.flexibleWidth]
        dragButton.layer.cornerRadius = 8
        dragButton.setTitle("", for: .normal)
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(self.handleDragView))
        dragButton.addGestureRecognizer(gestureRecognizer)
        self.addSubview(dragButton)
        
        arrowImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 18))
        arrowImageView.image = #imageLiteral(resourceName: "handing")
        arrowImageView.alpha = 0.5
        arrowImageView.isHidden = true
        self.addSubview(arrowImageView)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinchView))
        self.addGestureRecognizer(pinchGesture)
        
        messageVC.fontScale = CGFloat( UserDefaults.standard.getUserFontScale() )

    }
    
    @objc func handlePinchView(_ gestureRecognizer: UIPinchGestureRecognizer) {
        
        //print("Scale : \(gestureRecognizer.scale)  :\(gestureRecognizer.state)")
        let addScale = gestureRecognizer.scale - oldPinchScale
        var bNeedReload = false
        if abs(addScale) > 0.05 {
            messageVC.fontScale =  messageVC.fontScale + addScale
            oldPinchScale = gestureRecognizer.scale
            bNeedReload = true
        }
        
        if gestureRecognizer.state == .began {
            log.debug("UIPinchGestureRecognizer - began")
        } else if gestureRecognizer.state == .changed {
            log.debug("UIPinchGestureRecognizer - changed")
            if bNeedReload {
                messageVC.tableView.reloadData()
            }
        } else if gestureRecognizer.state == .ended {
            log.debug("UIPinchGestureRecognizer - end")
            if bNeedReload {
                messageVC.tableView.reloadData()
            }
            oldPinchScale = 1
            UserDefaults.standard.setUserFondScale(messageVC.fontScale)
        }
        
    }
    
    @objc func handleDragView(_ gestureRecognizer: UIPanGestureRecognizer) {
        onDragChatView(gestureRecognizer)
        if gestureRecognizer.state == .began {
            arrowImageView.alpha = 0.8
        } else if gestureRecognizer.state == .ended {
            arrowImageView.alpha = 0.5
        }
    }
    
    //MARK: - Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        for subView in subviews {
//            subView.frame = self.bounds
//        }
        
        messageVC.view.frame = self.bounds
        arrowImageView.center.x = self.frame.width  * 0.5
    }
    
    
    //MARK: - Setup
    
    //MARK: - UI Interface
    func setChatList(alpha : CGFloat) {
        messageVC.tableView.alpha = alpha
    }
    
    func setChatStatus(enableInputChat: Bool, placeholdText: String = "")
    {
        messageVC.textView.isUserInteractionEnabled = enableInputChat
        messageVC.textView.placeholder = placeholdText
    }
    
    override func resignFirstResponder() -> Bool {
        super.resignFirstResponder()        
        return self.messageVC.textView.resignFirstResponder()
    }
    
    func isEditing() -> Bool {
        return self.messageVC.textView.isFirstResponder ? true : false
    }
    
    
    func setMessageLongPressAction(enable: Bool, complete : @escaping (_ msg : Message) -> Void) {
        
        messageVC.enableLongPress = enable
        messageVC.onLongPressed = { msg in
            complete(msg)
        }
        
    }
    
    func unSetup() {
        messageVC.onLeftButton = { sender in  }
        messageVC.onPolice = { status in }
        messageVC.onPoliceBroadcast = { status in }
        messageVC.onMute = {  }
        messageVC.offMute = {  }
        messageVC.onLongPressed = { message in }
        messageVC.isEnableTexting = { return true }
        messageVC.onKeyboardChangeHandler = { status in }
        
        self.keyboardChangeHandler = { keyStatus in }
        self.onDragChatView = { darg in  }
        
    }
    
    
    func setBroadcastChat() {
        self.layer.cornerRadius = 5
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        self.messageVC.setTextInputSimpleType()
    }
    
    var getTextInputBarHeight : CGFloat {
        return messageVC.textInputbar.frame.height
    }

}
