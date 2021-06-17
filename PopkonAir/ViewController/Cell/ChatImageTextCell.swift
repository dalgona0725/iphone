//
//  ChatImageTextCell.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 08/08/2019.
//  Copyright © 2019 The E&M. All rights reserved.
//

import UIKit

class ChatImageTextCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var chatIamgeView: UIImageView!
    @IBOutlet weak var chatImageHeight: NSLayoutConstraint!

    var message = Message()
    var currentIamgeData : ChatImageData?
    
    private var sourcetimer: DispatchSourceTimer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.setLayerOutLine(borderWidth: 2, cornerRadius: 3, borderColor: UIColor.darkGray)
        self.selectedBackgroundView?.frame.size = self.frame.size
        self.selectedBackgroundView?.backgroundColor = UIColor.clear
        
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    deinit {
        stopTimer()
    }
    
    /// 애니메이션 프레임 처리
    /// - Note: 현재프레임에서 다음 프레임으로 넘긴다. 타이머를 통해서 키프레임 타임 간격에 맞춰서 넘긴다.
    func animationNext() {
        if let data = currentIamgeData,let images = currentIamgeData?.animationStorage?.animationsImages {
            data.currentFrameStep += 1
            if data.currentFrameStep >= images.count {

                data.currentRepeatStep += 1
                /// RepeatCount가 0일 경우는 계속 반복한다.
                if data.animationRepeatCount == 0 {
                    data.currentFrameStep = 0
                } else {
                    if data.currentRepeatStep < data.animationRepeatCount {
                        data.currentFrameStep = 0
                    } else {
                        // 종료
                        data.isAnimationEnd = true
                        return
                    }
                }
            }
            
            if data.currentFrameStep >= images.count {
                data.isAnimationEnd = true
                return
            }
            
            self.chatIamgeView.image = images[data.currentFrameStep]
            self.startTimer(with: data.keyFrameTimeInterval) {
                self.animationNext()
            }
        }
    }
    
    /// 메세지 설정
    /// - Note: 해당 메세지를 셋업한다. 그리고 애니메이션 종료상태가 아니라면 해당 스텝부터 계속 플레이한다.
    func setInfo(info: Message, imageData: ChatImageData?, attributedString: NSAttributedString?) {
        self.stopTimer()
        self.message = info
        self.currentIamgeData = imageData
        self.messageLabel.attributedText = attributedString
        
        if let imageInfo = imageData {
            if let images = imageInfo.animationStorage?.animationsImages {
                
                if let image = images.first {
                    // 이건 임시 (정확한 이미지 표시 사이즈는 미정)
                    self.chatImageHeight.constant = image.size.height // * 0.5
                }
                
                // 애니메이션 이미 종료상태
                if imageInfo.isAnimationEnd {
                    self.chatIamgeView.image = images.last
                    self.currentIamgeData = nil
                } else {
                    self.chatIamgeView.image = images[imageInfo.currentFrameStep]
                    self.startTimer(with: imageInfo.keyFrameTimeInterval) {
                        self.animationNext()
                    }
                }
            }
        }
    }
    
    //MARK: - 공용 Timer 함수
    /// 공용타이어 시작 함수
    /// - Note: 공용타이머 시작 처리. 하나의 타이머 인스턴스 사용하므로 병렬 다중으로 사용하진 못한다.
    /// - Parameters:
    ///     - handler: 타이머 작동 조건에 따른 핸들러.
    private func startTimer(with delay:TimeInterval, handler : @escaping ()->Void) {
        stopTimer()
        sourcetimer = DispatchSource.makeTimerSource(flags: .strict, queue: .main)
        sourcetimer?.schedule(deadline: .now() + delay )
        sourcetimer?.setEventHandler {
            handler()
        }
        sourcetimer?.resume()
    }
    
    /// 공용타이머 중지 함수
    /// - Note: 인스턴스가 nil이 아니면 cancel함수 호출후 nil처리.
    func stopTimer() {
        if sourcetimer != nil {
            sourcetimer!.cancel()
            sourcetimer = nil
        }
    }
    
}

