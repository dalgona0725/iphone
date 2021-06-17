//
//  UITextEffContainerView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 8. 3..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit
import Photos
import HaishinKit

struct TextStorage {
    var color = UIColor.white
    var size  : CGFloat = 25
    var text  : String = ""
}

class UITextEffContainerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var hkEffectManager: RTMPStream?
    var videoEffectManager: VideoEffectManager?
    var castOrientation: AVCaptureVideoOrientation = .portrait
    var defaultWidth    = 0
    var defaultHeight   = 0
    
    var textEffect      = CIOverlayEffect()
    var editorView      = TextEditToolView()
    var wastebasketView = UIGarbageView()
    var stickerViews    = [UIEffectSticker]()
    var finishButton    = UIButton()
    var imageAddButton  = UIButton()
    
    var helpInfoView    = UILabel()

    var textView            = UITextView()
    var textDefaultWidth    : CGFloat = 0
    var textDefaultHeight   : CGFloat = 0
    
    var textSections  = [TextStorage]()
    var otherViews    = [UIView]()
    
    // var rtmpStream : RTMPStream?
    
    var clickPos    = CGPoint.zero
    
    var onStartEdit : () -> Void = {  }
    var onEndEdit   : () -> Void = {  }
    
    var isAddingEff = false
    
    var currentSticker : UIEffectSticker?
    var currentColor     = UIColor.white
    var currentBackColor = UIColor.clear
    var currentSize  : CGFloat = 25

    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXIB()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
    }
    
    private func initFromXIB() {

        let gesture = UITapGestureRecognizer(target: self, action: #selector(handleTab))
        self.addGestureRecognizer(gesture)
        let buttonSize : CGFloat = 45.0
        
        wastebasketView = UIGarbageView()
        self.addSubview(wastebasketView)
        self.otherViews.append(wastebasketView)
        wastebasketView.snp.makeConstraints{
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(52)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.width.height.equalTo(buttonSize)
        }

        textView = UITextView().then {
            $0.font = UIFont.notoMediumFont(ofSize: self.currentSize)
            $0.textColor = currentColor
            $0.backgroundColor = UIColor.clear
            //textView.returnKeyType = UIReturnKeyType.next
            $0.isHidden = true
            $0.delegate = self
            $0.autocorrectionType = .no
            $0.spellCheckingType = .no
        }
        self.addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(50)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.8)
            $0.height.equalToSuperview().multipliedBy(0.2)
        }
        
        finishButton = UIButton().then {
            $0.setImage(#imageLiteral(resourceName: "before"), for: .normal)
            $0.addTarget(self, action: #selector(finishEditing), for: UIControl.Event.touchUpInside)
        }
        self.addSubview(finishButton)
        self.otherViews.append(finishButton)
        finishButton.snp.makeConstraints{
            $0.top.equalTo(self.safeAreaLayoutGuide).inset(52)
            $0.leading.equalTo(self.safeAreaLayoutGuide).inset(10)
            $0.width.height.equalTo(buttonSize)
        }
        
//        imageAddButton.frame = CGRect(x: garView.frame.minX - 60, y: garView.frame.minY, width: 45, height: 45)
//        imageAddButton.setImage(#imageLiteral(resourceName: "manager"), for: .normal)
//        imageAddButton.addTarget(self, action: #selector(openPhotoLibrary), for: UIControlEvents.touchUpInside)
//        self.addSubview(imageAddButton)
//        self.otherViews.append(imageAddButton)
        
        let toolHeight : CGFloat = 120
        editorView = TextEditToolView(frame: CGRect(x:0, y: 0, width: frame.width, height: toolHeight))
        editorView.onClose = {
            //self.editorView.hideUI()
            self.editorView.setSliderValue(value: Float(self.currentSize))
            self.textView.font = UIFont.notoMediumFont(ofSize: self.currentSize)
            
            self.hideNormalUI(bHide: false)
            
            _ = self.textView.resignFirstResponder()
            //self.finishTextEditing()
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false){_ in
                self.unlockAddEffect()
            }
        }
        editorView.onSize = {
            if let sticker = self.currentSticker as? UITextSticker {
                self.editorView.setSliderValue(value: Float(sticker.fontSize))
            } else {
                self.editorView.setSliderValue(value: Float(self.currentSize))
            }
        }
        editorView.onTextColor = {
            if let sticker = self.currentSticker as? UITextSticker {
                self.editorView.setPickColor(color: sticker.currentColor)
            } else {
                self.editorView.setPickColor(color: self.currentColor)
            }
        }
        editorView.onBackColor = {
            if let sticker = self.currentSticker as? UITextSticker {
                self.editorView.setPickColor(color: sticker.currentBackColor)
            } else {
//                if self.currentBackColor != UIColor.clear {
//                    self.editorView.setPickColor(color: self.currentBackColor)
//                }
                self.editorView.setPickColor(color: self.currentBackColor)
            }
        }
        editorView.onChangeColor = { (mode,color) in
            // if self.currentSticker != nil {
            if let sticker = self.currentSticker as? UITextSticker {
                if mode == .textColor {
                    sticker.currentColor = color
                } else {
                    sticker.currentBackColor = color
                }
            } else {
                if mode == .textColor {
                    self.updateTextStorage()
                    self.currentColor = color
                    
                    if self.textSections.count == 0 {
                        self.textView.textColor = self.currentColor
                    }
                } else {
                    self.currentBackColor = color
                    self.textView.backgroundColor = color
                }
            }
        }
        editorView.onChangeValue = { (mode,value) in
            if mode == .fontSize {
                if let sticker = self.currentSticker as? UITextSticker {
                    sticker.updateFontSize(size: CGFloat(value))
                } else {
                    self.updateTextStorage()
                    self.currentSize = CGFloat(value)
                    
                    if self.textSections.count == 0 {
                        self.textView.font = UIFont.notoMediumFont(ofSize: self.currentSize)
                    }
                }
            }
        }
        
        self.addSubview(editorView)
        self.otherViews.append(editorView)
        
        editorView.snp.makeConstraints{
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(toolHeight)
        }
        
        helpInfoView = UILabel().then {
            $0.backgroundColor = UIColor.darkGray.withAlphaComponent(0.3)
            $0.text = I18N.text_information01.localized
            $0.textColor = UIColor.white
            $0.textAlignment = .center
            $0.isUserInteractionEnabled = false
            $0.font = UIFont.notoBoldFont(ofSize: 18.0)
            $0.isHidden = true
        }
        self.addSubview(helpInfoView)
        helpInfoView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.keyboardChanged(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        self.isUserInteractionEnabled = false
        showUI(bShow: false)
    }
    
    /// 새로운 이미지스티커를 추가한다.
    ///- Note: 해당이미지 UIImage로 받아서 추가 한다.
    func addImageSticker(targetImage: UIImage) {
        
        var newSize = targetImage.size
        if targetImage.size.width > self.frame.width {
            let ratio = targetImage.size.height / targetImage.size.width
            newSize.width = self.frame.width * 0.5
            newSize.height = newSize.width * ratio
        }
        
        let imageSticker = UIImageSticker(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        imageSticker.addImage(image: targetImage)
        
        let size = imageSticker.frame.size
        let xPos = self.center.x - size.width * 0.5
        let yPos = self.center.y - size.height * 0.5
        let newFrame = CGRect(x: xPos, y: yPos, width: size.width, height: size.height)
        imageSticker.frame = newFrame
        imageSticker.registerGarbage(view: wastebasketView)
        imageSticker.onRemove = { childView in
            var index = 0
            for item in self.stickerViews {
                if item == childView {
                    self.stickerViews.remove(at: index)
                    break
                }
                index = index + 1
            }
        }
        imageSticker.topView = finishButton
        
        //self.insertSubview(labelview, belowSubview: finishButton)
        self.addSubview(imageSticker)
        stickerViews.append(imageSticker)
        currentSticker = imageSticker
        self.bringSubviewToFront(finishButton)
    }
    
    func openPhotoLibrary()
    {
        PHPhotoLibrary.shared().performChanges({
            
        }) { (success, error) in
            
            if let error = error {
                if error.localizedDescription.hasSuffix("0)") {
                    log.debug("최초 권한 요청시...")
                } else {
                    popupManager.showAlert(content: I18N.text_needPermissionGoToSetting.localized, buttonTitles: [I18N.ui_ok.localized,I18N.ui_cancel.localized], buttonActions: [{
                        if UIApplication.openSettingsURLString.isEmpty == false  {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                        },{}])
                }
            }
            
            if success {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                    let myPickerController = UIImagePickerController()
                    myPickerController.delegate = self;
                    myPickerController.sourceType = .photoLibrary
                    
                    if let parentVC = self.parentViewController as? WZBroadcastViewController {
                        parentVC.ignoreDismiss = true
                        parentVC.present(myPickerController, animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    func updateTextStorage() {
        
        if var text = self.textView.text {
            var index = 0
            for item in textSections {
                if let range = text.range(of: item.text) {
                    text.removeSubrange(range)
                    index = index + 1
                } else {
                    textSections.remove(at: index)
                }
            }
            
            if text.count > 0 {
                let newText = TextStorage(color: self.currentColor, size: self.currentSize, text: text)
                textSections.append(newText)
            } else {
                if var last = textSections.last {
                    last.color = self.currentColor
                    last.size  = self.currentSize
                }
            }
        }
        
    }
    
    @objc func keyboardChanged(notification : Notification) {
        
        if let userInfo = notification.userInfo {
            let animationTime = (userInfo["UIKeyboardAnimationDurationUserInfoKey"] as! NSNumber).doubleValue
            let keyboardRect = (userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
            
            var keyboardShownHeight =  UIScreen.main.bounds.height - keyboardRect.origin.y
            var moveValue = keyboardShownHeight
            
            if #available(iOS 14.2, *) {
                log.debug("iOS 14.0 - 14.1 keyboard Rect Error fixed. no need")
            } else if #available(iOS 14.0, *) {
                let maxLength = UIScreen.main.bounds.width > UIScreen.main.bounds.height ? UIScreen.main.bounds.width : UIScreen.main.bounds.height
                keyboardShownHeight =  maxLength - keyboardRect.origin.y
                moveValue = keyboardShownHeight
                
                if self.editorView.isHidden == false {
                    if UIDevice.current.hasNotchScreen(), keyboardShownHeight > 0 {
                        /// <가로모드 경우>
                        if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                            let subtract = self.safeAreaInsets.bottom * 2 + 13.0
                            moveValue = keyboardShownHeight - subtract
                        }
                    }
                }
            }
                        
            let transEditioView = CATransform3DMakeTranslation(0, -moveValue, 0)
            UIView.animate(withDuration: animationTime, animations: {
                self.layer.transform = CATransform3DIdentity
                self.editorView.layer.transform = transEditioView
            })
        }
    }

    @objc func handleTab(_ gesture: UITapGestureRecognizer) {
        
        if isAddingEff {
            return
        }
        let pos = gesture.location(in: self)
        if editorView.frame.contains(pos) {
            return
        }
        
        isAddingEff = true
        for item in stickerViews {
            if item.frame.contains(pos) {
                currentSticker              = item
                finishButton.isHidden       = true
                wastebasketView.isHidden    = true
                imageAddButton.isHidden     = true
                editorView.hideDoneButton(hide: false)
                editorView.isHidden         = false
                return
            }
        }
        
        hideNormalUI(bHide: true)
        helpInfoView.isHidden = true
        
        currentSticker      = nil
        clickPos            = pos
        textView.isHidden   = false
        textView.textColor  = currentColor

        _ = textView.becomeFirstResponder()
        textSections.removeAll()
    }
    
    private func hideNormalUI(bHide: Bool) {
        wastebasketView.isHidden = bHide
        finishButton.isHidden = bHide
        imageAddButton.isHidden = bHide
        
        for item in stickerViews {
            item.isHidden = bHide
        }
        editorView.hideDoneButton(hide: !bHide)
        editorView.isHidden = !bHide
    }
    
    /// 새로운 텍스트를 추가한다.
    /// - Note: 새로운텍스트를 화면상에 추가한다.
    func addTextEffect(text : String) {
        
        let estimateWidth  = textView.frame.width
        let estimateHeight = textView.frame.height

        let labelview = UITextSticker(frame: CGRect(x: 0, y: 0, width: estimateWidth, height: estimateHeight))
        labelview.currentColor = currentColor
        labelview.currentBackColor = currentBackColor
        labelview.textLabel.text = text
        if let attr = getAttributeText() {
            labelview.textLabel.attributedText = attr
        } else {
            labelview.updateFontSize(size: currentSize)
        }
        
        //let ci = CIColor(color: self.currentBackColor)
        //log.debug("\(ci.red) \(ci.green) \(ci.blue)")
        
        let size = labelview.textLabel.sizeThatFits(CGSize(width: estimateWidth, height: estimateHeight))
        let xPos = clickPos.x - size.width * 0.5
        let yPos = clickPos.y - size.height * 0.5
        let newFrame = CGRect(x: xPos, y: yPos, width: size.width + 10, height: size.height + 4)
        labelview.frame = newFrame
        
        labelview.updateLabelFrame()
        labelview.registerGarbage(view: wastebasketView)
        labelview.onRemove = { childView in
            var index = 0
            for item in self.stickerViews {
                if item == childView {
                    self.stickerViews.remove(at: index)
                    break
                }
                index = index + 1
            }
            
            if self.stickerViews.isEmpty {
                self.helpInfoView.isHidden = false
            }
        }
        labelview.topView = finishButton
        
        //self.insertSubview(labelview, belowSubview: finishButton)
        self.addSubview(labelview)
        stickerViews.append(labelview)
        currentSticker = labelview
        
        self.helpInfoView.isHidden = self.stickerViews.isEmpty ? false : true
        
        self.bringSubviewToFront(finishButton)
    }
    
    func showUI(bShow : Bool) {
        for item in otherViews {
            item.isHidden = !bShow
        }
    }
    
    /// 텍스트편집모드를 시작한다.
    /// - Note: 방송하기에서 텍스트효과모드 버튼을 누를때 처리한다.
    func startEditing() {
        
        if stickerViews.count > 0 {
            if let effectManager = videoEffectManager {
                _ = effectManager.unregisterEffect(textEffect)
            } else if let hkManager = self.hkEffectManager {
                _ = hkManager.unregisterVideoEffect(textEffect)
            }
            for item in self.stickerViews {
                item.isHidden = false
            }
        }
        
        helpInfoView.isHidden = stickerViews.count > 0 ? true : false
        
        showUI(bShow: true)
        editorView.hideDoneButton(hide: true)
        editorView.isHidden = true
        
        self.isUserInteractionEnabled = true
        currentColor        = UIColor.white
        currentBackColor    = UIColor.clear
        currentSize         = 25.0
        
        textView.textColor        = currentColor
        textView.backgroundColor  = currentBackColor
        textView.font             = UIFont.notoMediumFont(ofSize: currentSize)
        onStartEdit()
    }
    
    /// 텍스트편집모드를 즉시닫기 처리한다.
    /// - Note: 폴리스 얼리기 상태변경시 편집모드일 경우 닫기 처리 용도로 쓰인다.
    ///         글자들을 화면표시가 되도록 숨김해제하여 다시 연결하고 닫는다.
    func closeImmediately() {
        guard self.isUserInteractionEnabled else {
            return
        }
        
        if isAddingEff {
            for item in self.stickerViews {
                item.isHidden = false
            }
        }
        finishEditing()
    }
    
    @objc func finishEditing() {
        if textView.isFirstResponder {
            textView.resignFirstResponder()
        }
        unlockAddEffect()
        
        showUI(bShow: false)
        editorView.hideUI()
        self.isUserInteractionEnabled = false
        
        dispatchMain.async {
            let succeed = self.updateTetxEffect()
            if self.stickerViews.count > 0 {
                
                if succeed, let effectManager = self.videoEffectManager {
                    let _ = effectManager.registerEffect(self.textEffect)
                }
                if succeed, let effectManager = self.hkEffectManager {
                    let _ = effectManager.registerVideoEffect(self.textEffect)
                }
                
                for item in self.stickerViews {
                    item.isHidden = true
                }
            }
        }
        currentSticker = nil
        helpInfoView.isHidden = true
        
        onEndEdit()
    }
    
    /// 텍스처 효과 오버레이 이미지 업데이트 한다,.
    /// - Note : 비디오 영상사이즈와 현 뷰프레임사이즈 매칭하여 텍스처라벨뷰 위치값 변경처리 한뒤
    ///          해당 뷰프레임을 CoreImage 데이터로 렌더링한뒤 TextEffect 오버레이로 연결한다.
    ///          완료된뒤 뷰프레임 사이즈를 원복하고, 텍스트라벨 위치값도 복구한다.
    func updateTetxEffect() -> Bool {
        let videoMaxWidth : CGFloat = CGFloat(defaultWidth)
        let videoMaxHeight: CGFloat = CGFloat(defaultHeight)
        
        let originalFrameSize = self.frame.size
        var moveTranslation = CGPoint(x: 0, y: 0)
        
        if castOrientation == .portrait {
            let ratio = videoMaxHeight / videoMaxWidth
            let estimateHeight = ratio * self.frame.width
            let removeHeight = self.frame.height - estimateHeight
            self.frame.size = CGSize(width: self.frame.width, height: estimateHeight)
            moveTranslation = CGPoint(x: 0, y: removeHeight * -0.5)
        } else {
            let ratio = videoMaxWidth / videoMaxHeight
            let estimateWidth = ratio * self.frame.height
            let removeWidth = self.frame.width - estimateWidth
            self.frame.size = CGSize(width: estimateWidth, height: self.frame.height)
            moveTranslation = CGPoint(x: removeWidth * -0.5, y: 0)
        }
        for sticker in stickerViews {
            sticker.updatePosition()
            sticker.updateTransformWithoffset(trans: moveTranslation)
        }
        
        let imageSize = CGSize(width: videoMaxWidth, height: videoMaxHeight)
        let drawRect = CGRect(x: 0, y: 0, width: videoMaxWidth, height: videoMaxHeight )
        UIGraphicsBeginImageContext(imageSize)
        self.drawHierarchy(in: drawRect, afterScreenUpdates: true )
        let textEffectimage = CIImage(image: UIGraphicsGetImageFromCurrentImageContext()!, options: nil)
        UIGraphicsEndImageContext()
                
        self.textEffect.addCIImage = textEffectimage
        for sticker in stickerViews {
            sticker.updateTransformWithoffset(trans: CGPoint(x: 0, y: 0))
        }
        self.frame.size = originalFrameSize
        return true
    }
    
    
    func remakeTetxEffect() {
        if stickerViews.isEmpty {
            return
        }
        // 저화질일때는 글자 깨짐이 심하다.
        
        let videoMaxWidth : CGFloat = CGFloat(defaultWidth)
        let videoMaxHeight: CGFloat = CGFloat(defaultHeight)
        var moveTranslation = CGPoint(x: 0, y: 0)
        if castOrientation == .portrait {
            let ratio = videoMaxHeight / videoMaxWidth
            let estimateHeight = ratio * self.frame.width
            let removeHeight = self.frame.height - estimateHeight
            self.frame.size = CGSize(width: self.frame.width, height: estimateHeight)
            moveTranslation = CGPoint(x: 0, y: removeHeight * -0.5)
        } else {
            let ratio = videoMaxWidth / videoMaxHeight
            let estimateWidth = ratio * self.frame.height
            let removeWidth = self.frame.width - estimateWidth
            self.frame.size = CGSize(width: estimateWidth, height: self.frame.height)
            moveTranslation = CGPoint(x: removeWidth * -0.5, y: 0)
        }
        
        for sticker in stickerViews {
            sticker.isHidden = false
            sticker.updatePosition()
            sticker.updateTransformWithoffset(trans: moveTranslation)
        }
        let imageSize = CGSize(width: videoMaxWidth, height: videoMaxHeight)
        let drawRect = CGRect(x: 0, y: 0, width: videoMaxWidth, height: videoMaxHeight )
        UIGraphicsBeginImageContext(imageSize)
        self.drawHierarchy(in: drawRect, afterScreenUpdates: true )
        let textEffectimage = CIImage(image: UIGraphicsGetImageFromCurrentImageContext()!, options: nil)
        UIGraphicsEndImageContext()
        self.textEffect.addCIImage = textEffectimage
        
        for sticker in stickerViews {
            sticker.isHidden = true
        }
    }

    func creatTextEff() {
        if let text = textView.text {
            if text.isEmpty == false {
                addTextEffect(text: text)
            } else {
                helpInfoView.isHidden = stickerViews.count > 0 ? true : false
            }
            
            textView.frame.size = CGSize(width: textDefaultWidth, height: textDefaultHeight)
            textView.isHidden = true
            textView.text = ""
        }
    }
    
    func unlockAddEffect() {
        self.isAddingEff = false
    }
    
    /// 텍스트 출력 최종 이미지 돌리기.
    /// - Warning: webRTC 연결시에는 해당이미지와 webRTC와 일치하지 않는 경우가 있다. 가로/세로 전방/후방 모두 체크해볼 필요가 있음.
    func orientedFinalImage(with orientation: CGImagePropertyOrientation = .down) {
        if var image = self.textEffect.addCIImage {
            image = image.oriented(orientation)
            self.textEffect.addCIImage = image
        }
    }
}

extension UITextEffContainerView : UITextViewDelegate {
    
    func finishTextEditing() {
        self.creatTextEff()
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//
//    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        finishTextEditing()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        var size = textView.sizeThatFits(CGSize(width: frame.width * 0.8, height: frame.height*0.8))
        
        if size.width < textDefaultWidth {
            size.width = textDefaultWidth
        }
        if size.height < textDefaultHeight {
            size.height = textDefaultHeight
        }
        textView.frame.size = size
        
        if let attr = getAttributeText() {
            textView.attributedText = attr
        }
    }
    
    func getAttributeText() -> NSAttributedString? {
        if textSections.count > 0 {
            
            var textSectionLength = 0
            for item in textSections {
                textSectionLength = textSectionLength + item.text.count
            }
            
            if textView.text.count < textSectionLength {
                let last = textSections.removeLast()
                currentSize  = last.size
                currentColor = last.color
            }
            
            if textSections.isEmpty {
                return nil
            }
            
            let totalAttributedStr = NSMutableAttributedString()
            
            var totalText = ""
            //let shadow = NSShadow()
            //shadow.shadowColor = UIColor.darkGray.withAlphaComponent(0.8)
            //shadow.shadowOffset = CGSize(width: 1.0, height: 1.0)
            
            for item in textSections {
                let addText = NSAttributedString(string: item.text, attributes: [NSAttributedString.Key.font: UIFont.notoMediumFont(ofSize: item.size) ,NSAttributedString.Key.foregroundColor: item.color ])
                totalAttributedStr.append(addText)
                totalText.append(item.text)
            }
            
            if var viewText = textView.text {
                viewText = String.removeLastEmptyLine(text: viewText)
                if let range = viewText.range(of: totalText) {
                    viewText.removeSubrange(range)
                    let addText = NSAttributedString(string: viewText, attributes: [NSAttributedString.Key.font: UIFont.notoMediumFont(ofSize: currentSize) ,NSAttributedString.Key.foregroundColor: currentColor])
                    totalAttributedStr.append(addText)
                }
            }
            
            return totalAttributedStr
        }
        return nil
    }
    
    /// 최종적으로 해제처리한다
    /// - Note: 메모리상 남지 않도록 연결된 함수등을 다 초기화처리한다.
    func unSetup() {
        onStartEdit = { }
        onEndEdit = { }
        editorView.resetAction()
        
        currentSticker = nil
        for item in stickerViews {
            item.clear()
        }
        stickerViews.removeAll()
        textSections.removeAll()
        
        videoEffectManager = nil
        hkEffectManager = nil
    }
    
    
}

//MARK: - UIImagePickerControllerDelegate
extension UITextEffContainerView: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.parentViewController?.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.addImageSticker(targetImage: image)
        }else{
            log.debug("[Error] UIImage failed.")
        }
        self.parentViewController?.dismiss(animated: true, completion: nil)
    }
    
}
