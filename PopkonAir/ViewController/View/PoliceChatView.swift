//
//  PoliceChatView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 26/04/2019.
//  Copyright © 2019 The E&M. All rights reserved.
//
import AVFoundation
import MediaPlayer

class PoliceChatView: UIView, PoliceWarningProtocol {
    // UI 레이아웃
    //  -폴리스경고 알람뷰
    //  -채팅 테이블뷰
    
    // 마스터 계정을 제외한 나머지 계정은 채팅 불가  -> " 채팅 사용 불가" placeholder.
    // 채팅창 [닫기] 눌러도 폴리스 채팅창은 유지
    // 채팅창 얼리기(클린캠페인 종료시) 폴리스 채팅창 숨김 . 기존 유저 채팅창 사이즈 현재 유지 (조절 기능 on)
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var sirenOnLabel: UILabel!
    
    var messages = [Message]()
    let fontScale : CGFloat = 1.0
    
    // MARK:- propeties
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var upperSubviewHeight: NSLayoutConstraint!
    @IBOutlet weak var chatSubviewTop: NSLayoutConstraint!
    @IBOutlet weak var stopSirenButton: UIButton!
    
    var warningViewDefaultHeight : CGFloat = 0.0
    var audioPlayer: AVAudioPlayer? = nil
    let sirenAudioName = "police-siren3333"

    var buttonIndex: Int                 = 0
    var spriteAnimTimer: Timer?          = nil
    var spriteAnimInterval: TimeInterval = 0.2
    
    var autoHideTimer: Timer?           = nil
    var autoHideInterval: TimeInterval  = 15.0
    
    let minAlarmSoundVolume : Float     = 0.8
    var oldSoundVolume: Float           = 0.0
    
    var bStopped : Bool                 = false
    
    // MARK:- View init
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
        let nib = UINib(nibName: "PoliceChatView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
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
        
        sirenOnLabel.text = I18N.text_onSiren.localized
        warningViewDefaultHeight = upperSubviewHeight.constant
        stopSirenButton.setLayerOutLine(borderWidth: 1.5, cornerRadius: 2, borderColor: #colorLiteral(red: 1, green: 0.7058823529, blue: 0, alpha: 1))
    }
    
    // MARK:- Police Alram start & stop
    /// 폴리스 얼리기 경고 시작
    /// - Note: 폴리스 얼리기 경고 처리
    func startWarning() {
        self.isHidden = false
        self.bStopped = false 
        self.warningView.isHidden = false
        self.upperSubviewHeight.constant = warningViewDefaultHeight
        let targetFrame = self.warningView.frame
        self.warningView.frame.origin.y -= 25
        self.warningView.alpha = 0.0
        
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.4, initialSpringVelocity: 15.0, options: UIView.AnimationOptions.curveEaseOut, animations: {() in
            self.warningView.frame = targetFrame
            self.warningView.alpha = 1
        }, completion: {
            (value: Bool) in
            self.playSirenSound()
        })
        
        self.resetTimer()
        self.setupTimers()
    }
    
    /// 폴리스 얼리기 경고 중지처리
    /// - Note: 폴리스 얼리기 경고 중지
    func stopWarning() {
        self.bStopped = true
        
        stopSirenSound()
        resetTimer()
        clearMessages()
        restoreSoundVolume()
        
        self.chatTableView.reloadData()
        self.isHidden = true
    }
    
    // MARK:- WaraninView update
    @objc
    func chanageButtonAnim() {
        if buttonIndex == 0 {
            buttonIndex = 1
            stopSirenButton.setImage(#imageLiteral(resourceName: "icon_Siren01") , for: .normal)
        } else {
            buttonIndex = 0
            stopSirenButton.setImage(#imageLiteral(resourceName: "icon_Siren02"), for: .normal)
        }
    }
    @objc 
    func autoHideWarningView() {
        stopSirenSound()
        resetTimer()
        
        upperSubviewHeight.constant = 0
        warningView.isHidden = true
    }
    
    // MARK:- IBAction
    @IBAction func stopSiren(sender: UIButton) {
        self.autoHideWarningView()
    }
    
    // MARK:- Sound Play & Stop
    func playSirenSound() {
        self.stopSirenSound()
        
        if bStopped {
            return
        }
        
        do {
            if let fileURL = Bundle.main.path(forResource: sirenAudioName, ofType: "wav") {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: fileURL))
            } else {
                print("No file with specified name exists")
            }
        } catch let error {
            print("Can't play the audio file failed with an error \(error.localizedDescription)")
        }
        
        oldSoundVolume = AVAudioSession.sharedInstance().outputVolume
        if AVAudioSession.sharedInstance().outputVolume < minAlarmSoundVolume {
            MPVolumeView.setVolume(minAlarmSoundVolume)
        }
        
        audioPlayer?.play()
    }
    
    func stopSirenSound() {
        if audioPlayer != nil {
            audioPlayer?.stop()
            audioPlayer = nil
        }
    }
    
    func restoreSoundVolume() {
        if oldSoundVolume != minAlarmSoundVolume {
            MPVolumeView.setVolume(oldSoundVolume)
        }
    }
    
    // MARK: Timer setup/reset
    /// 타이머 셋팅
    /// - Note: 버튼애니메이션 타이머, 경고뷰 자동숨김 타이머 초기화
    func setupTimers() {
        spriteAnimTimer = Timer.scheduledTimer(withTimeInterval: spriteAnimInterval, repeats: true, block: { (timer) in
            self.chanageButtonAnim()
        })
        autoHideTimer = Timer.scheduledTimer(withTimeInterval: autoHideInterval, repeats: false, block: { (timer) in
            self.autoHideWarningView()
        })
    }
    
    /// 타이머 셋팅
    /// - Note: 버튼애니메이션 타이머, 경고뷰 자동숨김 타이머 무효화 처리
    func resetTimer() {
        if spriteAnimTimer != nil {
            spriteAnimTimer?.invalidate()
            spriteAnimTimer = nil
        }
        if autoHideTimer != nil {
            autoHideTimer?.invalidate()
            autoHideTimer = nil
        }
    }
}

extension PoliceChatView {
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
        message.textColor = msgColor.isEmpty ? chatType.getColorString() :  msgColor
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


extension PoliceChatView: UITableViewDelegate, UITableViewDataSource {
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

extension MPVolumeView {
    static func setVolume(_ volume: Float) {
        let volumeView = MPVolumeView()
        let slider = volumeView.subviews.first(where: { $0 is UISlider }) as? UISlider
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            slider?.value = volume
        }
    }
}
