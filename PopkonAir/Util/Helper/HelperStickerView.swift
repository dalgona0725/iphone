//
//  HelperStickerView.swift
//  PopCasterAir
//
//  Created by Eugene Jeong on 2020/08/21.
//  Copyright © 2020 Eugene Jeong. All rights reserved.
//

import UIKit
import SnapKit
import WebKit
import Then

protocol HelperStickerViewDelegate {
    func tapSticker(sticker: HelperStickerView)
}

class HelperStickerView: UIView {
    deinit {
        log.debug("Deinit \(presetType.getName())")
    }
    
    /// 조작모드 상태
    enum ModulateMode {
        /// 아무런 조작없음
        case none
        /// 이동처리중
        case translate
        /// 우측편 드래그 사이즈조절
        case sizeRight
        /// 좌측편 드래그 사이즈조절
        case sizeLeft
    }
        
    /// 프리셋 웹뷰 화면
    var webView: WKWebView = {
        let preference = WKPreferences()
        preference.javaScriptEnabled = true
        
        let webConfiguration = WKWebViewConfiguration()
        webConfiguration.preferences = preference
        webConfiguration.allowsInlineMediaPlayback = true
        webConfiguration.allowsAirPlayForMediaPlayback = true
        webConfiguration.mediaTypesRequiringUserActionForPlayback = []
        webConfiguration.suppressesIncrementalRendering = true
        /// web data 비지속성 상태로 로드 처리
        webConfiguration.websiteDataStore = WKWebsiteDataStore.nonPersistent()
        
        let  wkView = WKWebView(frame: .zero, configuration: webConfiguration).then{
            $0.isOpaque = false
            $0.backgroundColor = UIColor.clear
            $0.scrollView.backgroundColor = UIColor.clear
            $0.isUserInteractionEnabled = false
            $0.setLayerOutLine(borderWidth: 0, cornerRadius: 4, borderColor: .clear)
        }
        return wkView
    }()
    
    // MARK: - 뷰 조작관련 영역 뷰
    /// 이동 영역 뷰
    var moveAreaView: UIView = {
        let view = UIView(frame: .zero).then {
            $0.backgroundColor = UIColor.clear
        }
        return view
    }()
    /// 좌축 화면사이즈 영역
    var sizeLeftView: UIView = {
        let view = UIView(frame: .zero).then {
            $0.backgroundColor = UIColor.clear ///red.withAlphaComponent(0.5)
        }
        return view
    }()
    /// 우측 화면사이즈 영역
    var sizeRightView: UIView = {
        let view = UIView(frame: .zero).then {
            $0.backgroundColor = UIColor.clear //blue.withAlphaComponent(0.5)
        }
        return view
    }()
    
    
    // MARK: - 위치,스케일 복구용도 Properties
    /// 변경전 영역 크기 정보
    var preBound = CGRect.zero
    /// 변경전 이동행렬 정보
    var preTransform = CGAffineTransform.identity
        
    /// 스케일값
    var scale   : CGFloat = 1.0
    /// 이동 변경시 뷰 위치
    var viewPosition: CGPoint = CGPoint()
    /// 사이즈 변경시 최소 사이즈
    var minimumSize = CGSize(width: 100, height: 100)
    var maximumSize = CGSize.zero
    /// 사이즈 변경시 (임시) 현재 사이즈
    var originalSize = CGSize.zero
    /// 현재 조작 모드 상태
    var editMode : ModulateMode = .none

    /// 해당뷰가 터치로 선택되어 있는지 여부
    var isSelected = false
    /// 연결된 프리셋 URL
    var widgetURL = ""
    /// 프리셋 타입 정보
    var presetType : PopkonHelper = .alert
    /// 프리셋 관리 키 값
    var userKey: String = ""
    /// 스티커 처리 델리게이트
    var delegate: HelperStickerViewDelegate? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXIB()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
    }
    
    func initFromXIB() {
        self.layer.cornerRadius = 4
        self.layer.masksToBounds = true
        self.isUserInteractionEnabled = true
        resetProperty()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.hadleTap(_:)))
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(_:)))
        //let pinch = UIPinchGestureRecognizer(target: self, action: #selector(self.handlePinch(_:)))
        self.gestureRecognizers =  [ pan, tap ]
        
        for recognizer in self.gestureRecognizers! {
            recognizer.delegate = self
        }
        
        self.addSubview(webView)
        webView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        
        self.addSubview(sizeRightView)
        sizeRightView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview()
        }
        self.addSubview(sizeLeftView)
        sizeLeftView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.bottom.trailing.equalToSuperview().inset(40)
        }
        self.addSubview(moveAreaView)
        moveAreaView.snp.makeConstraints {
            $0.leading.trailing.top.bottom.equalToSuperview().inset(40)
        }

        showGuideView(show: false)
    }
    
    /// 프리셋 설정
    /// - Parameters:
    ///     - type: 프리셋 타입
    ///     - info: 프리셋 정보
    ///     - delegate: 해당 스티커 델리게이트
    func setup(type: PopkonHelper, info: HelperPresetInfo, delegate: HelperStickerViewDelegate) {
        self.presetType = type
        self.userKey = info.key
        self.LoadPage(url: info.url)
        self.showGuideView(show: true)
        self.delegate = delegate
        
        if let size = self.superview?.bounds.size {
            self.maximumSize = size
        } else {
            self.maximumSize = UIScreen.main.bounds.size
        }
    }
    /// 프리셋 웹뷰 로드
    /// - Parameters:
    ///     - url: 연결할 URL
    func LoadPage(url: String) {
        widgetURL = url
        if let url = URL(string: self.widgetURL) {
            let myRequest = URLRequest(url: url)
            webView.load(myRequest)
        }
    }
    
    /// 프리셋 가이드 라인 표시
    func showGuideView(show: Bool) {
        if show {
            setLayerOutLine(borderWidth: 2, cornerRadius: 4, borderColor: mainColor)
        } else {
            setLayerOutLine(borderWidth: 0, cornerRadius: 4, borderColor: .clear)
        }
        isSelected = show
        
        sizeRightView.isHidden = show ? false : true
        sizeLeftView.isHidden = show ? false : true
    }
    
    /// 현재 행렬,영역 크기 정보 저장하기
    func storeTrasfrom() {
        self.preTransform = self.transform
        self.preBound = self.bounds
    }
    /// 행렬,영역크기 복원하가ㅣ
    func restoreTransform() {
        self.transform = self.preTransform
        self.bounds = self.preBound
    }
    /// 행렬,위치 초기화
    func resetProperty() {
        self.transform = .identity
        self.viewPosition = CGPoint(x: 0, y: 0)
    }
    
    func updateTransformWithoffset( trans: CGPoint) {
        self.transform = CGAffineTransform(translationX: trans.x + self.viewPosition.x, y: trans.y + self.viewPosition.y)
        self.transform = self.transform.scaledBy(x: scale , y: scale)
    }
    
    // MARK: - IBACTION
    @objc func hadleTap(_ gesture: UIPanGestureRecognizer) {
        if isSelected == false {
            delegate?.tapSticker(sticker: self)
        }
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        let tranlastion = gesture.translation(in: self.superview)
        switch gesture.state {
        case .began:
            if isSelected == false {
                delegate?.tapSticker(sticker: self)
            }
            
            let location = gesture.location(in: self)
            if moveAreaView.frame.contains(location) {
                editMode = .translate
            } else if sizeLeftView.frame.contains(location) {
                editMode = .sizeLeft
                originalSize = self.bounds.size
            } else if sizeRightView.frame.contains(location) {
                editMode = .sizeRight
                originalSize = self.bounds.size
            }
        case .changed:
            if editMode == .translate {
                updateTransformWithoffset(trans: tranlastion)
            } else if editMode == .sizeLeft || editMode == .sizeRight {
                
                let dir: CGFloat = editMode == .sizeRight ? 1.0 : -1.0
                var newWidth = originalSize.width + tranlastion.x * 2 * dir
                var newHeight = originalSize.height + tranlastion.y * 2 * dir
                if newWidth < minimumSize.width {
                    newWidth = minimumSize.width
                }
                if newHeight < minimumSize.height {
                    newHeight = minimumSize.height
                }
                if newWidth > maximumSize.width {
                    newWidth = maximumSize.width
                }
                if newHeight > maximumSize.height {
                    newHeight = maximumSize.height
                }
                
                UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseInOut], animations: {
                    self.bounds = CGRect(x: 0, y: 0, width: newWidth, height: newHeight)
                } , completion: nil)
            }
        case .cancelled, .ended:
            editMode = .none
        default:
            break
        }
    }
    
    @objc func onRemoveAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
}


extension HelperStickerView : UIGestureRecognizerDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubviewToFront(self)
        self.viewPosition.x = self.transform.tx
        self.viewPosition.y = self.transform.ty
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if touches.count == 3 {
            resetProperty()
        } else {
            //log.debug("!!!touchesEnded!! \(pos.y)")
        }
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.touchesEnded(touches, with: event)
    }
}
