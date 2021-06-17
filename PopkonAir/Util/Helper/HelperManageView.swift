//
//  HelperManageView.swift
//  PopCasterAir
//
//  Created by Eugene Jeong on 2020/08/26.
//  Copyright © 2020 Eugene Jeong. All rights reserved.
//

import UIKit
import WebKit

// MARK: - Protocol
protocol HelperManageDelegate {
    /// 조작 모드로 진입시
    func enterManipulate(manageView: HelperManageView)
    /// 프리셋 적용시
    func applyHelpers(manageView: HelperManageView)
}

// MARK: - Class
class HelperManageView: UIView {
    
    enum HelpManagerMode {
        /// 숨김
        case hide
        /// 활성화
        case open
        /// 사이즈,변경 조작
        case manipulate
        /// 신규 프리셋추가후 조작 모드
        case newPreset
        
        /// 현재 조작 모드 상태인지
        var isEditing: Bool {
            return self == .manipulate || self == .newPreset
        }
    }
    
    /// 프리셋뷰 관리용도 상위뷰
    var stickerContainerView: UIView!
    
    /// 활성화시 터치처리 용도 배경뷰
    var backgroudView: UIView!
    /// 메뉴 배경뷰
    var pannelView: UIImageView!
    /// 메뉴 타이틀
    var titleLabel: UILabel!
    /// 프리셋 위치 변경
    var translationButton: UIButton!
    /// 프리셋 카테고리 메뉴 버튼
    var helperButtons = [UIButton]()
    
    /// 프리셋 위치변경 모드
    /// 뒤로가기 버튼
    var backButton: UIButton!
    /// 저장하기 버튼
    var saveButton: UIButton!
    
    /// 프리셋 관리용도
    var stickers = [String: HelperStickerView]()
    /// 현재 모드 상태
    var currentMode: HelpManagerMode = .hide
    /// 프리셋 관리 처리 델리게이트
    var delegate : HelperManageDelegate? = nil
    
    /// 신규프리셋 추가후 미완료 상태시 뒤로가기시 복구용도 정보
    /// 신규추가된 스티커 키값 (임시)
    var newAddStickerKey = ""
    /// 신규추가된 스티커로 인해 제거된 키값 (임시)
    var removeStickerKey = ""
    /// 신규추가된 스티커로 인해 제거된 프리셋뷰
    var removeStickerView: HelperStickerView? = nil
    /// 복구용도 프리셋뷰 깊이순서 값
    var orderOfStikcer = [String]()
    
    /// 현재 프리셋 갯수
    var numberOfStickers : Int {
        get {
            return stickers.count
        }
    }
    /// 캡쳐되어야 할 대상 뷰
    var captureView : UIView {
        get {
            return stickerContainerView
        }
    }
    /// 현재 보여지고 있는 상태인지 여부
    var isShow: Bool {
        get {
            return currentMode != .hide
        }
    }
    
    // MARK: - 생성
    override init(frame: CGRect) {
        super.init(frame: frame)
        initFromXIB()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initFromXIB()
    }
    func initFromXIB() {
        stickerContainerView = UIView().then{
            $0.backgroundColor = UIColor.clear
        }
        self.addSubview(stickerContainerView)

        backgroudView = UIView().then{
            $0.backgroundColor = UIColor.clear
        }
        self.addSubview(backgroudView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureRecognizer(_:)))
        backgroudView.addGestureRecognizer(gesture)
        
        pannelView = UIImageView().then {
            $0.image = #imageLiteral(resourceName: "dialogV")
        }
        self.addSubview(pannelView)
        
        titleLabel = UILabel().then {
            $0.text = String(format: I18N.ui_helper_menu_title.localized, appName)
            $0.font = UIFont.boldSystemFont(ofSize: 24)
            $0.textColor = UIColor.white
            $0.textAlignment = .left
        }
        self.addSubview(titleLabel)
        
        translationButton = UIButton().then{
            $0.setTitle(I18N.ui_helper_menu_setup.localized, for: .normal)
            $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            $0.contentHorizontalAlignment = .left
            $0.addTarget(self, action: #selector(self.adjustViews), for: .touchUpInside)
        }
        self.addSubview(translationButton)
        
        for (index, item) in PopkonHelper.allValues.enumerated() {
            let button = UIButton().then{
                $0.setTitle( item.getName(), for: .normal)
                $0.setTitleColor(UIColor.white, for: .normal)
                $0.contentHorizontalAlignment = .left
                $0.tag = index
                $0.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
                $0.addTarget(self, action: #selector(self.showHelperPopup), for: .touchUpInside)
            }
            self.addSubview(button)
            self.helperButtons.append(button)
        }
        
        backButton = UIButton().then{
            $0.setImage(#imageLiteral(resourceName: "beforeBtn"), for: .normal)
            $0.addTarget(self, action: #selector(self.exitManipulate), for: .touchUpInside)
        }
        self.addSubview(backButton)
        saveButton = UIButton().then{
            $0.setImage(#imageLiteral(resourceName: "presetSaveBtn"), for: .normal)
            $0.addTarget(self, action: #selector(self.saveChanges), for: .touchUpInside)
        }
        self.addSubview(saveButton)
    }
    
    func setup(anchorView: UIView, isVertical: Bool) {
        if isVertical {
            pannelView.image = #imageLiteral(resourceName: "dialogV")
        } else {
            pannelView.image = #imageLiteral(resourceName: "dialogH")
        }
        self.setupViewConstraints(anchorView: anchorView, isVertical: isVertical)
        self.show(.hide)
    }
    
    func setupViewConstraints(anchorView: UIView, isVertical: Bool) {
        
        stickerContainerView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        backgroudView.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.width.height.equalToSuperview()
        }
        
        pannelView.snp.makeConstraints {
            $0.width.equalTo(260)
            $0.height.equalTo(230) /// 255
                        
            //$0.centerX.equalToSuperview()
            $0.trailing.equalTo(anchorView.snp.leading).offset(-10)
            if isVertical {
                $0.centerY.equalTo(anchorView).offset(8)
            } else {
                $0.bottom.equalTo(anchorView).offset(20)
            }
            
        }
        titleLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(pannelView).inset(20)
            $0.top.equalTo(pannelView).inset(24)
            $0.height.equalTo(30)
            //$0.width.greaterThanOrEqualTo(self.snp.width).multipliedBy(0.4)
        }
        
        translationButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(pannelView).inset(25)
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.height.equalTo(25)
        }
        var preItem = translationButton
        for button in helperButtons {
            button.snp.makeConstraints {
                $0.leading.trailing.equalTo(pannelView).inset(25)
                $0.top.equalTo(preItem!.snp.bottom).offset(10)
                $0.height.equalTo(25)
            }
            preItem = button
        }

        backButton.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(8)
            $0.width.height.equalTo(45)
        }
        saveButton.snp.makeConstraints {
            $0.trailing.top.equalToSuperview().inset(8)
            $0.width.height.equalTo(45)
        }
        
    }
    
    // MARK: - Show
    func show(_ mode: HelpManagerMode) {
        self.currentMode = mode
        
        var show01 = false
        var show02 = false
        if mode != .hide {
            if mode == .open {
                show01 = true
                self.stickerContainerView.isUserInteractionEnabled = false
                 self.backgroudView.isUserInteractionEnabled = true
            } else if mode.isEditing {
                show02 = true
                self.stickerContainerView.isUserInteractionEnabled = true
                 self.backgroudView.isUserInteractionEnabled = false
                
                for subView in self.stickerContainerView.subviews {
                    if let helperView = subView as? HelperStickerView {
                        helperView.storeTrasfrom()
                    }
                }
                
                if mode == .newPreset {
                    if newAddStickerKey.isEmpty == false {
                        stickers.forEach { (key, stickerView) in
                            if newAddStickerKey != key {
                                stickerView.isUserInteractionEnabled = false
                            }
                        }
                    }
                }
            }
            self.isUserInteractionEnabled = true
            self.stickerContainerView.snp.remakeConstraints {
                $0.leading.top.equalToSuperview()
                $0.width.height.equalToSuperview()
            }
        } else {
            self.isUserInteractionEnabled = false
            self.stickerContainerView.snp.remakeConstraints {
                $0.leading.equalTo(self.snp.trailing).offset(200)
                $0.top.equalToSuperview()
                $0.width.height.equalToSuperview()
            }
        }
        
        self.pannelView.isHidden = show01 ? false : true
        self.titleLabel.isHidden = show01 ? false : true
        self.translationButton.isHidden = show01 ? false : true
        for button in helperButtons {
            button.isHidden = show01 ? false : true
        }
        
        self.backButton.isHidden = show02 ? false : true
        self.saveButton.isHidden = show02 ? false : true
        
        if mode.isEditing {
            delegate?.enterManipulate(manageView: self)
        }
    }
    
    /// 프리셋뷰 가이드 라인 보이기/ 숨기기
    /// - Parameters:
    ///     - view: 처리할 프리셋뷰
    func showGuideline(view: HelperStickerView?) {
        for subView in self.stickerContainerView.subviews {
            if let helperView = subView as? HelperStickerView {
                if helperView == view {
                    helperView.showGuideView(show: true)
                } else {
                    helperView.showGuideView(show: false)
                }
            }
        }
    }
    
    /// 기존 프리셋 제거하기
    /// - Note: 현재 프리셋정보리스트를 갱신하는 경우 기존에 생성된게 존재하지 않을경우 제거처리
    /// - Parameters:
    ///     - helper: 지운고자 하는 현재 생성된 프리셋 종류
    func removeCurrentHelper(helper: PopkonHelper) {
        let existingSticker = self.stickers.first { (key, _) -> Bool in
            return key.hasPrefix(helper.getName())
        }
        if let existingSticker = existingSticker {
            dispatchMain.async {
                existingSticker.value.removeFromSuperview()
            }
            self.stickers.removeValue(forKey: existingSticker.key)
        }
    }
    
    /// 프리셋 설정 팝업창 보여주기
    @objc func showHelperPopup(_ sender: UIButton) {
        //log.debug("clicked \(sender.tag)")
                
        if let helper = PopkonHelper(rawValue: sender.tag) {
            popupManager.showLoadingView()
            connection.getWidetLink(page: helper) { (succced, infos, resultInfo) in
                if succced {
                    
                    /// 현재 리스트와 연결된게 없다면 삭제
                    /// 현재 연결된 정보를 가져온다.
                    var finded = false
                    for item in infos {
                        let keyItem = "\(helper.getName())_\(item.name)_\(item.index)_\(item.url)"
                        if let _ = self.stickers[ keyItem ] {
                            item.selected = true
                            finded = true
                            break
                        }
                    }
                    
                    if finded == false {
                        self.removeCurrentHelper(helper: helper)
                    }
                    
                    if infos.isEmpty {
                        dispatchMain.async {
                            self.superview?.makeToast(String(format: I18N.err_helper_no_preset.localized, appName))
                        }
                    } else {
                        popupManager.showPresetPopup(type: helper, infos: infos, delegate: self)
                    }
                }
                popupManager.hideLoadingView()
            }
        }
    }
    
    /// 조작모드 열기
    @objc func adjustViews(_ sender: UIButton) {
        if numberOfStickers < 1 {
            self.superview?.makeToast(I18N.err_helper_cant_setup.localized)
            return
        }
        self.storeOrderInSticker()
        show(.manipulate)
    }
    /// <조작모드> 저장없이 닫기 처리
    @objc func exitManipulate(_ sender: UIButton) {
        /// 모두 이전 위치 / 사이즈로 롤백 처리
        for subView in self.stickerContainerView.subviews {
            if let helperView = subView as? HelperStickerView {
                helperView.restoreTransform()
            }
        }
        
        if currentMode == .newPreset {
            if newAddStickerKey.isEmpty == false {
                if let target = stickers[ newAddStickerKey ] {
                    target.removeFromSuperview()
                    stickers.removeValue(forKey: newAddStickerKey)
                }
                newAddStickerKey = ""
            }
            
            
            if let restore = self.removeStickerView {
                self.stickerContainerView.addSubview(restore)
                stickers[ removeStickerKey ] = restore
                
                self.removeStickerView = nil
                self.removeStickerKey = ""
            }
            
            stickers.forEach { (key, stickerView) in
                if newAddStickerKey != key {
                    stickerView.isUserInteractionEnabled = true
                }
            }
        }
        self.restoreOrderInSticker()
        
        self.showGuideline(view: nil)
        self.close()
    }
    /// <조작모드> 변경점 저장하기 처리
    @objc func saveChanges(_ sender: UIButton) {
        self.newAddStickerKey = ""
        self.removeStickerKey = ""
        self.removeStickerView = nil
        
        if currentMode == .newPreset {
            stickers.forEach { (key, stickerView) in
                if newAddStickerKey != key {
                    stickerView.isUserInteractionEnabled = true
                }
            }
        }
        
        self.showGuideline(view: nil)
        self.close()
    }
        
    @objc func tapGestureRecognizer(_ sender:UITapGestureRecognizer){
        if currentMode == .open {
            self.close()
        }
    }
    
    /// 메뉴 닫기 처리
    /// - Note: 숨김처리 및 프리셋 적용 호출처리
    func close() {
        show(.hide)
        delegate?.applyHelpers(manageView: self)
    }
}

// MARK: - Preset Delegate
extension HelperManageView: HelperPresetDelegate {
    
    /// 프리셋 순서 저장
    func storeOrderInSticker() {
        orderOfStikcer.removeAll()
        for subView in self.stickerContainerView.subviews {
            if let helperView = subView as? HelperStickerView {
                let find = stickers.first { (key, sticker) -> Bool in
                    return subView == sticker
                }
                if let key = find?.key {
                    orderOfStikcer.append(key)
                }
            }
        }
    }
    /// 프리셋 순서 복구 처리
    func restoreOrderInSticker() {
        for key in orderOfStikcer {
            if let target = stickers[ key ] {
                target.removeFromSuperview()
                self.stickerContainerView.addSubview(target)
            }
        }
    }
    
    /// 프리셋 설정 팝업 변경버튼 처리
    /// - Note: 변경버튼을 눌렀을 경우에 대한 처리
    /// - Parameters:
    ///     - helper: 프리셋 타입 (알람,목표치 등등)
    ///     - infos: 해당 프리셋정보들. selected 값이 선택된게 현재 적용중인 프리셋
    func add(helper: PopkonHelper, infos: [HelperPresetInfo]) {
        //print(helper.getName(), info?.name)
        let selected = infos.first { (item) -> Bool in
            return item.selected
        }
        
        /// 선택된게 있을 경우
        if let item = selected {
            let keyItem = "\(helper.getName())_\(item.name)_\(item.index)_\(item.url)"
            
            /// 이전과 동일한게 존재한다면
            /// 동일한 프리셋을 선택하게 되면 그냥 팝업 닫기 처리 2021.02.26 사업부 요청
            if let item = stickers[ keyItem ] {
//                item.showGuideView(show: true)
//                //show(.manipulate)
//
//                newAddStickerKey = "existItem"
//                show(.newPreset)
//                item.isUserInteractionEnabled = true
//                storeOrderInSticker()
                return
            }
            
            /// 이전 존재한 같은 종류 프리셋이 존재한다면
            /// 해당 프리셋을 일단 백업해두고, 최종적으로 저장버튼이 눌릴 경우 제거 처리 한다.
            /// 저장버튼이 눌리지 않으면 다시 원복처리.
            let existingSticker = stickers.first { (key, _) -> Bool in
                return key.hasPrefix(helper.getName())
            }
            if let existingSticker = existingSticker {
                removeStickerKey = existingSticker.key
                removeStickerView = existingSticker.value
                
                existingSticker.value.removeFromSuperview()
                stickers.removeValue(forKey: existingSticker.key)
            }
            
            
            /// 현재 해당 선택된게 없다면.
            let viewSize = helper.getDefalutSize()
            /// 위치값을 가져온다.
            let pos = getSpawnLocation()
            
            let webSticker = HelperStickerView(frame:CGRect(x: pos.x, y: pos.y, width: viewSize.width, height: viewSize.height)).then {
                $0.backgroundColor = UIColor.clear
            }
            self.stickerContainerView.addSubview(webSticker)
                        
            webSticker.setup(type: helper, info: item, delegate: self)
            
            newAddStickerKey = keyItem
            stickers[ keyItem ] = webSticker
            show(.newPreset)
            
        } else {
            /// 선택된게 없을 경우
            /// 해당 타입 프리셋이 현재 있으면 제거처리한다.
            self.removeCurrentHelper(helper: helper)
        }
    }
    
    /// 프리셋 설정 갱신버튼 처리
    /// - Note: 갱신버튼을 눌렀을 경우, 현재 적용된 프리셋이 삭제되었을 경우 제거처리 용도
    /// - Parameters:
    ///     - helper: 프리셋 타입 (알람,목표치 등등)
    ///     - infos: 해당 프리셋정보들. selected 값이 선택된게 현재 적용중인 프리셋
    func refresh(helper: PopkonHelper, infos: [HelperPresetInfo]) {
        /// 현재 리스트와 연결된게 없다면 삭제
        /// 현재 연결된 정보를 가져온다.
        for item in infos {
            let keyItem = "\(helper.getName())_\(item.name)_\(item.index)_\(item.url)"
            if let _ = self.stickers[ keyItem ] {
                return
            }
        }
        self.removeCurrentHelper(helper: helper)
    }
    
    // MARK: - 프리셋 생성 좌표 관련 계산 함수
    func getSpawnLocation() -> CGPoint {
        let orign = CGPoint(x: 50, y: 100)
        let direct = CGPoint(x: 20, y: 20)
        var step = 0
        for item in stickers.values {
            let pos = item.frame.origin
            let value = distanceFromPoint(point: pos, orign: orign, dir: direct)
            if value < 0.1 {
                let space = pos.y - orign.y
                let result = Int( space / direct.y)
                if result >= step {
                    step = result + 1
                }
            }
        }
        return CGPoint(x: orign.x + CGFloat(step) * direct.x , y: orign.y + CGFloat(step) * direct.y)
    }
    
    func dot(a: CGVector,b: CGVector) -> CGFloat {
        return a.dx*b.dx + a.dy*b.dy;
    }
    func magnitude(v: CGVector) -> CGFloat {
        return sqrt(v.dx*v.dx + v.dy*v.dy);
    }
    func unit(v: CGVector) -> CGVector {
        let length = magnitude(v: v)
        return CGVector(dx: v.dx / length, dy: v.dy / length)
    }
    func distanceFromPoint(point p: CGPoint, orign v: CGPoint, dir d: CGPoint) -> CGFloat {
        let vp = CGVector(dx: p.x - v.x, dy: p.y - v.y)
        let vd = CGVector(dx: d.x, dy: d.y)

        let a1 = dot(a: vp, b: vd)
        let n1 = magnitude(v: vd)
        let uw = unit(v: vd)
        
        let param = a1/n1
        let proj = CGVector(dx: uw.dx * param, dy: uw.dy * param  )
        let t = CGVector(dx: proj.dx - vp.dx, dy: proj.dy - vp.dy)
        return magnitude(v: t)
    }
}

// MARK: - 프리셋뷰 델리게이트 처리
extension HelperManageView: HelperStickerViewDelegate  {
    func tapSticker(sticker: HelperStickerView) {
        self.showGuideline(view: sticker)
    }
}

// MARK: - 웹 JavaScript 함수 호출
extension HelperManageView {
    
    /// 코인 선물 이벤트 웹통신 전송
    /// - Parameters:
    ///     - coinValue: 선물의 실제 코인수
    ///     - coinType: 선물 타입 ( from chat message)
    ///     - userID: 유저아이디
    ///     - userNickname: 유저 닉네임
    ///     - message: 선물 메세지 ( from chat message)
    func sendCoinUpdate(coinValue: Int,
                        coinType: String,
                        userID: String,
                        userNickname: String,
                        message: String) {
        let nickname = userNickname
        let msg = message
        let imageURL = getCoinImageURL(coinType: coinType)
        let parameters: [String: String] = [
            "signId" : userID,
            "nickName" : nickname,
            "coinvalue" : "\(coinValue)",
            "cointype": coinType,
            "coinurl" : imageURL,
            "msg" : msg
        ]
        let param = parameters.compactMap{"\"\($0)\":\"\($1)\""}.joined(separator: ",")
        let script = "{\"type\":\"star\",\"data\":{\(param)}}"
        sendJavaScriptRequest(data: script)
    }
    
    /// 추천 이벤트 웹통신 전송
    /// - Parameters:
    ///     - recommend: 누적된 추천수
    ///     - msg: 추천메세지
    func sendRecommendUpdate(recommed: Int = 0,
                        message: String = "") {
        let parameters: [String: String] = [
            "recomcnt" : "\(recommed)",
            "msg" : message
        ]
        let param = parameters.compactMap{"\"\($0)\":\"\($1)\""}.joined(separator: ",")
        let script = "{\"type\":\"up\",\"data\":{\(param)}}"
        sendJavaScriptRequest(data: script)
    }
        
    /// 현재 방송내 데이터 정보 웹통신 전송
    /// - Parameters:
    ///     - castTitle: 방송제목
    ///     - viewer: 전체 누적 시청자수
    ///     - upCount: 전체 누적 추천수
    ///     - fanCount: 팬수 (사용하지 않음)
    ///     - followCount: 즐겨찾기 누적 수
    ///     - donation: 후원 누적수
    func sendLiveStatus(castTitle: String = "",
                        viewer: Int = 0,
                        upCount: Int = 0,
                        fanCount: Int = 0,
                        followCount: Int = 0,
                        donation: Int = 0) {
        let parameters: [String: String] = [
            "live" : "true",
            "title" : castTitle,
            "start" : "",
            "view" : "\(viewer)",
            "up" : "\(upCount)",
            "fan" : "\(fanCount)",
            "follow" : "\(followCount)",
            "donation" : "\(donation)"
            
        ]
        let param = parameters.compactMap{"\"\($0)\":\"\($1)\""}.joined(separator: ",")
        let script = "{\"type\":\"stats\",\"data\":{\(param)}}"
        sendJavaScriptRequest(data: script, isStats: true)
    }
    
    /// 채팅 메세지 웹통신 전송
    /// - Parameters:
    ///     - signId: 회원아이디
    ///     - nickName: 닉네임
    ///     - roomLevel: 권한 등급 (0:  일반 시청자, 1: 방송자 권한, 2: 매니저 권한, 3: 운영자 권한, 4: 관리자 권한)
    ///     - fanLevel: 팬등급 (0: 최상위 팬등급 (VIP), 1: 상위 팬등급 (다이아), 2: 하위 팬등급 (골드), 3: 최하위 팬등급 (실버), 4: 팬등급 없음)
    ///     - gradeimg: 등급 아이콘
    ///     - memberSex: 성별
    ///     - message: 메시지
    func sendChatMessage(signId: String = "",
                         nickName: String = "",
                         roomLevel: String = "",
                         fanLevel: String = "",
                         memberSex: String = "",
                         message: String = "") {
        
        var urlString = ""

        if let nRoomLevel = Int(roomLevel) {
            if nRoomLevel == 0 {
                if let nFanLevel = Int(fanLevel), let fanGrade = FanGradeIcon(rawValue: nFanLevel) {
                    urlString = fanGrade.stringValue()
                }
            } else if nRoomLevel == 1 {
                let gradeIcon: GradeIconImage = memberSex == "0" ? .mc_women : .mc_man
                urlString = gradeIcon.stringValue()
                
            } else {
                if let gradeIcon = GradeIconImage(rawValue: nRoomLevel) {
                    urlString = gradeIcon.stringValue()
                }
            }
        }
        
        let parameters: [String: String] = [
            "signId" : signId,
            "nickName" : nickName,
            "roomLevel" : roomLevel,
            "fanLevel" : fanLevel,
            "gradeimg" : "",
            "memberSex" : memberSex,
            "message" : message
        ]
        let param = parameters.compactMap{"\"\($0)\":\"\($1)\""}.joined(separator: ",")
        let script = "{\"type\":\"chat\",\"data\":{\(param)}}"
        sendJavaScriptRequest(data: script, isStats: true)
    }
    
    /// 열혈팬 입장 인사 웹통신 전송
    /// - Parameters:
    ///     - msg: 메시지
    func sendFanEntranceMessage(message: String = "") {
        let parameters: [String: String] = [
            "msg" : message
        ]
        let param = parameters.compactMap{"\"\($0)\":\"\($1)\""}.joined(separator: ",")
        let script = "{\"type\":\"join\",\"data\":{\(param)}}"
        
        sendJavaScriptRequest(data: script, isStats: true)
    }
    
    /// 웹 자바스크립트 함수 호출 연동
    /// - Parameters:
    ///     - data: 프리셋 자바스크립트 요청할 파라미터값 구성 데이터
    /// - Note: 웹뷰 모두에게 적용해야된다. 하나 웹뷰에서만 호출한다고 공유되진 않는다.
    func sendJavaScriptRequest(data: String, isStats: Bool = false ) {
        let javascript = "page.popkon('\(data)')"
        for sticker in stickers.values {
            if isStats, sticker.presetType == .alert {
                continue
            }
            
            sticker.webView.evaluateJavaScript(javascript, completionHandler: nil)
            log.debug(javascript)
        }
    }
    
    /// 팝콘선물 이미지 URL 가져오기
    /// - Parameters:
    ///     - coinType:선물 타입 ( from chat message)
    /// - Returns: 해당 선물의 이미지서버상 URL Address.
    func getCoinImageURL(coinType: String) -> String {
        let coins = [ "CCOIN","SCOIN","ACOIN","L1COIN","L2COIN","L3COIN","L4COIN","L5COIN","L6COIN","L7COIN","L8COIN","L9COIN", "7",
        "11", "19", "22", "24", "31", "32", "33", "66", "77", "79", "82", "90", "92", "99", "100", "103", "109", "112", "119", "124", "125", "175", "200", "214", "300", "314", "333", "337", "365", "400", "500", "505", "514", "522", "524", "555", "600", "614", "700", "717", "777", "800", "815", "900", "952", "982", "1000", "1004", "1009", "1111", "1212", "1225", "1253", "1288", "1414", "5882", "7575", "8253", "9999" ]
        
        var imageURLAddress = ""
        var coinImageName = ""
        
        /// coinUrl: 팝콘 이미지, luxuryUrl: 럭셔리 이미지, luvUrl: 셀럽 럽 이미지
        let coinUrl   = "pic.popkontv.com/images/www/images/sticker/"
        let luxuryUrl = "pic.popkontv.com/images/www/images/popkon/"
        let luvUrl    = "pic.popkontv.com/images/aspw/P-00117/luv/"
        /// 럭셔리 코인인지 판단
        let isLuxuryCoin = coinType.hasPrefix("L")
        
        if let _ = Int(coinType) {
            coinImageName = PARTNER_CODE == "P-00117" ? "luv_default" : "1"
            imageURLAddress = PARTNER_CODE == "P-00117" ? luvUrl : coinUrl
        } else {
            coinImageName = "1"
            imageURLAddress = luxuryUrl
        }
        
        if coins.contains(coinType){
            switch coinType {
            case "CCOIN":
                coinImageName = "c_popkon"
            case "SCOIN":
                coinImageName = "s_popkon"
            case "ACOIN":
                coinImageName = "o_popkon"
            default:
                if PARTNER_CODE == "P-00117" { /// 셀럽티비는 일반 코인은 "럽" 으로 럭셔리 코인은 팝콘티비와 동일하게
                    coinImageName = isLuxuryCoin ?  "\(coinType)" : "luv_\(coinType)_1"
                } else {
                    coinImageName = "\(coinType)"
                }
            }
        }
        return imageURLAddress + coinImageName + ".png"
    }
    
    /// 도우미 메뉴를 최종적으로 제거할 경우 호출한다
    /// - Warning: 콜하지 않으면 프리셋이 메모리상에 남게 된다.
    func clear() {
        for sticker in stickers.values {
            sticker.removeFromSuperview()
        }
        stickers.removeAll()
        self.clearWKWebCashData()
    }
    
    /// WebView 캐시 데이터 관련 제거 함수
    func clearWKWebCashData() {
        let websiteDataTypes = NSSet(array: [WKWebsiteDataTypeDiskCache, WKWebsiteDataTypeMemoryCache, WKWebsiteDataTypeCookies])
        let date = Date(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: websiteDataTypes as! Set<String>, modifiedSince: date, completionHandler:{ })
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            for record in records {
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record]) {
                }
            }
        }
    }
}
