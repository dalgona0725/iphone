//
//  SendPopkonView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 7. 6..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit

enum AutomaticSendGift {
    case none
    case asending
    case series
    
    static let allValues = [ none, asending, series, ]
    func stringValue()->String {
        switch self {
        case .none:
            return I18N.text_unknown.localized
        case .asending:
            return I18N.text_asending.localized
        case .series:
            return I18N.text_series.localized
        }
    }
    
    func getKey() -> String? {
        switch self {
        case .none:
            return nil
        case .asending:
            return "M"
        case .series:
            return "C"
        }
    }
}

class SendPopkonView: UIView {
    
    @IBOutlet private var contView: UIView!
    
    @IBOutlet weak var sendTabMenu: GiftTabMenuView!
    @IBOutlet weak var pageOneView: UIView!
    @IBOutlet weak var pageTwoView: UIView!
    
    //MARK: - Part One
    @IBOutlet weak var textLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    //@IBOutlet weak var closeButton: RoundButton!
    @IBOutlet weak var buyButton: RoundButton!
    @IBOutlet weak var giftButton: UIButton!
    @IBOutlet weak var itemsTableView: UICollectionView!
    
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var backPanelView: UIView!
    
    @IBOutlet weak var backGestureOneView: UIView!
    @IBOutlet weak var backGestureTwoView: UIView!
    
    @IBOutlet var titleLabelTrailConstraints: [NSLayoutConstraint]!
    
    //MARK: - Part Two
    @IBOutlet weak var userPopkonNumLabel: UILabel!
    @IBOutlet weak var inputOneTextField: UITextField!
    @IBOutlet weak var inputTwoTextField: UITextField!
    @IBOutlet weak var itemOneLabel: UILabel!
    @IBOutlet weak var itemTwoLabel: UILabel!
    @IBOutlet weak var miniPopupView: UIView!
    @IBOutlet weak var totalGiftPopkonNumLabel: UILabel!
    @IBOutlet weak var miniPopupImageView: UIImageView!
    @IBOutlet weak var miniPopupTextLabel: UILabel!
    @IBOutlet weak var sendPageTwoButton: UIButton!
    @IBOutlet weak var chooseSendDelayTime: SelectDropButton!
    @IBOutlet weak var buyPageTwoButton: RoundButton!
    
    @IBOutlet weak var questionButton: UIButton!
    @IBOutlet weak var giftCoinLabel: UILabel!
    @IBOutlet weak var totalGiftCoinLabel: UILabel!
    
    var toolBar         : UIToolbar? = nil
    
    let defaultSeondCoin    : Int = 1
    
    let defaultStartCoin    : Int = 1
    let defaultEndCoin      : Int = 100
    let defaultSeriesCoin   : Int = 0
    let defaultSeriesCount  : Int = 50
    
    let defaultStartMax     : Int = 499
    let defaultEndMax       : Int = 500
    let defaultSeriesMax    : Int = 1000

    var savedFirstValue     : Int = 0
    var savedSecondValue    : Int = 0
    var calculatedTotalValue: Int = 0
    
    var onCloseMenu : () -> Void = {  }
    var onChangeTab : () -> Void = {  }
    var onSendCoin  : () -> Void = {  }
    var onBuyCoin   : () -> Void = {  }
    var onMoveItem  : (Int) -> Void = { step in }
    var onAutomaticSend: (Int, Int, Int, GiftMenuTab) -> Void = { (first, second, delay, menuTab) in }
    
    var currentTab : GiftMenuTab = .coin {
        didSet {
            leftButton.isHidden = currentTab == .luxury ? false : true
            rightButton.isHidden = currentTab == .luxury ? false : true
            resetSelectedItem()
            updateInfoLabel()
        }
    }
    
    var nCoin : NormalPopkonType = .none
    var eCoin : EventPopkonType = .none
    var lCoin : LuxuryPopkonType = .none
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    let categoryArr = [ "\(coinName)", "\(I18N.text_evenrt.localized)\(coinName)", "\(I18N.text_luxury.localized)\(coinName)", "\(I18N.text_asending.localized)\(coinName)", "\(I18N.text_series.localized)\(coinName)" ]
    let delayTimeArr = [3,4,5,6,7,8,9,10]
    
    //MARK: - UI 초기화 및 설정
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
        let nib = UINib(nibName: "SendPopkonView", bundle: bundle)
        contView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        contView.frame = bounds
        contView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        
        self.addSubview(contView)
        
        //additional setups
        contView.backgroundColor = #colorLiteral(red: 0.949, green: 0.8353, blue: 0.1137, alpha: 1) // mainColor
        pageOneView.backgroundColor = #colorLiteral(red: 0.949, green: 0.8353, blue: 0.1137, alpha: 1)
        pageTwoView.backgroundColor = #colorLiteral(red: 0.949, green: 0.8353, blue: 0.1137, alpha: 1)
        
        giftButton.layer.cornerRadius = 3
        sendPageTwoButton.layer.cornerRadius = 3
        
        textLabel.layer.cornerRadius = 10
        itemsTableView.layer.cornerRadius = 10
        
        currentTab = .coin
        //closeButton.setTitle("\u{2716}", for: .normal)
        leftButton.setTitle("\u{2770}", for: .normal)
        rightButton.setTitle("\u{2771}", for: .normal)
        buyButton.setTitle(String(format: I18N.text_buyCoin.localized, coinName), for: .normal)
        buyPageTwoButton.setTitle(String(format: I18N.text_buyCoin.localized, coinName), for: .normal)
        
        giftCoinLabel.text = "\(I18N.text_present.localized)\(coinName)"
        totalGiftCoinLabel.text = String(format: I18N.text_totalPresent.localized, coinName)

        
        leftButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold",size:34)
        rightButton.titleLabel?.font = UIFont(name:"HelveticaNeue-Bold",size:34)

        textField.delegate = self
        inputOneTextField.delegate = self
        inputTwoTextField.delegate = self
        
        backPanelView.layer.borderColor = UIColor.black.cgColor
        backPanelView.layer.borderWidth = 2
        
//        pageTwoView.isHidden = true
        let image = UIImage(named: "bg_miniPopup1")
        let strechedImage = image?.resizableImage(withCapInsets: UIEdgeInsets(top: 1, left: 15, bottom: 1, right: 15), resizingMode: .stretch)
        miniPopupImageView.image = strechedImage
        
        pageTwoView.isHidden = true
        
        if let inputToolBar = accessoryView() {
            textField.inputAccessoryView = inputToolBar
            inputOneTextField.inputAccessoryView = inputToolBar
            inputTwoTextField.inputAccessoryView = inputToolBar
        }
        
        self.setupTabView()
        
        self.setupChooseDropDown()
        
        // Page One
        var swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture(recognizer:)))
        swipeGesture.direction = .right
        self.backGestureOneView.addGestureRecognizer(swipeGesture)
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture(recognizer:)))
        swipeGesture.direction = .left
        self.backGestureOneView.addGestureRecognizer(swipeGesture)
        
        // Page Two
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture(recognizer:)))
        swipeGesture.direction = .right
        self.backGestureTwoView.addGestureRecognizer(swipeGesture)
        swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipeGesture(recognizer:)))
        swipeGesture.direction = .left
        self.backGestureTwoView.addGestureRecognizer(swipeGesture)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(recognizer:)))
        self.backGestureTwoView.addGestureRecognizer(tapGesture)
        
        miniPopupTextLabel.font = UIFont.notoMediumFont(ofSize: 11)
        
        if UIDevice.current.isScreen4inch() {
            for item in titleLabelTrailConstraints {
                item.constant = 5
            }
        }

    }
    
    //MARK: - Gesture Handling
    @objc func handleSwipeGesture(recognizer: UISwipeGestureRecognizer) {
        var currentIndex = sendTabMenu.selectedIndex
        if recognizer.direction == .right {
            currentIndex = currentIndex - 1
        } else if recognizer.direction == .left {
            currentIndex = currentIndex + 1
        }
        if currentIndex < 0 || currentIndex >= categoryArr.count {
            return
        }
        sendTabMenu.selectTabButton(index: currentIndex)
    }
    
    @objc func handleTapGesture(recognizer: UITapGestureRecognizer) {
        miniPopupView.isHidden = true
    }
    
    func viewWillAppear(_ animated: Bool) {
        if userInfo.isLogined == false {
            return
        }
    }
    
    func setupChooseDropDown() {
        let delayTimeLabels = delayTimeArr.map { (time) -> String in
            return "\(time)\(I18N.text_second.localized)"
        }
        chooseSendDelayTime.dataSource = delayTimeLabels
    }
    
    func resetTab() {
        sendTabMenu.selectTabButton(index: 0)
    }

    func selectTab(with index: Int) {
        //currentTabIndex = sender.selectedSegmentIndex
        if let newTab = GiftMenuTab(rawValue: index) {
            currentTab = newTab
        }
        
        textField.text = ""
        backPanelView.isHidden = true
        
        if currentTab == .ascending || currentTab == .series {
            pageOneView.isHidden = true
            pageTwoView.isHidden = false
        } else {
            pageOneView.isHidden = false
            pageTwoView.isHidden = true
        }
        
        switch currentTab {
        case .coin:
            backPanelView.isHidden = false
            textField.isEnabled = true
            textField.placeholder = I18N.text_directInput.localized
            self.savedFirstValue = 10
        case .event:
            fallthrough
        case .luxury:
            self.resetKeyboardInput()
            textField.isEnabled = false
        case .ascending:
            self.setupDefaultAsedningMenu()
        case .series:
            self.setupDefaultSeriesMenu()
        }
        
        onChangeTab()
        updateUserCoin()
    }
    
    /// 두산팝콘 뷰화면 기본표시
    /// - Note: 탭선택이 되었을 경우 두산팝콘 기본표시내용
    /// - 설명팝업 텍스트 변경 및 선물하기 버튼 상태 변경 처리.
    /// - 텍스트 필드 값들 기본 설정값으로 복구 등등
    private func setupDefaultAsedningMenu() {
        itemOneLabel.text = I18N.text_start.localized
        itemTwoLabel.text = I18N.text_end.localized
        inputOneTextField.text = "\(defaultStartCoin)"
        inputTwoTextField.text = "\(defaultEndCoin)"
        let totalCoin = getSumofIsometricSequences(with: defaultStartCoin, end: defaultEndCoin)
        totalGiftPopkonNumLabel.text = CellUtil.getNumberCommaFormat(text: "\(totalCoin)")
        miniPopupTextLabel.text = String(format: I18N.text_asedningDescription.localized, coinName)
        miniPopupView.isHidden = true
        sendPageTwoButton.isEnabled = true
        
        savedFirstValue     = defaultStartCoin
        savedSecondValue    = defaultEndCoin
        chooseSendDelayTime.selectedIndex = 0
        
        self.updateSendButtonLock(with: totalCoin)
        self.resetKeyboardInput()
    }
    
    /// 연속팝콘 뷰화면 기본표시
    /// - Note:  탭선택이 되었을 경우 연속팝콘 기본표시내용
    /// - 설명팝업 텍스트 변경 및 선물하기 버튼 상태 변경 처리.
    /// - 텍스트 필드 값들 기본 설정값으로 복구 등등
    private func setupDefaultSeriesMenu() {
        itemOneLabel.text = I18N.text_number.localized
        itemTwoLabel.text = I18N.text_repeat.localized
        inputOneTextField.text = "\(defaultSeriesCoin)"
        inputTwoTextField.text = "\(defaultSeriesCount)"
        let totalCoin = defaultSeriesCoin * defaultSeriesCount
        totalGiftPopkonNumLabel.text = " "
        miniPopupTextLabel.text = String(format: I18N.text_seriesDescription.localized, coinName)
        miniPopupView.isHidden = true
        sendPageTwoButton.isEnabled = false
        
        savedFirstValue     = defaultSeriesCoin
        savedSecondValue    = defaultSeriesCount
        chooseSendDelayTime.selectedIndex = 0
        
        self.updateSendButtonLock(with: totalCoin)
        self.resetKeyboardInput()
    }
    
    /// 최상단 탭메뉴 설정
    /// - Note:  탭메뉴 설정 및 선택시 이벤트 연결.
    private func setupTabView() {
        
        var buttonInfos : [SJTabButtonInfo] = []
        for (_, category) in categoryArr.enumerated() {
            var button = SJTabButtonInfo()
            button.font = UIFont.notoBoldFont(ofSize: 12)
            button.title =  category
            button.titleColor = #colorLiteral(red: 1, green: 0.2901960784, blue: 0.337254902, alpha: 1)
            button.titleColorSelected = UIColor.white
            button.actionHandler = { sender in
               self.selectTab(with: self.sendTabMenu.selectedIndex)
            }
            buttonInfos.append(button)
        }

        sendTabMenu.backgroundColor = UIColor.white
        sendTabMenu.buttonInfos = buttonInfos
        sendTabMenu.enableSelected = true
        sendTabMenu.selectedIndex = 0
        //sendTabMenu.numOfItemsShown = buttonInfos.count
        
        sendTabMenu.numsOnVertical = 3
        sendTabMenu.numsOnHorizon = buttonInfos.count
        sendTabMenu.setup()
    }
    
    /// 유저 현재 코인갯수 업데이트
    /// - Note:  유저 코인정보 읽어와서 표시를 업데이트 한다.
    func updateUserCoin() {
        connection.loadCoinStatus(complete: { (succeed, resultInfo) in
            if succeed {
                dispatchMain.async {
                    self.updateInfoLabel()
                }
            }
        })
    }
    
    //MARK: - UI Update
    func openCurrentMenu() {
        //menuTabControl.selectedSegmentIndex = newTab.rawValue
        //onTabChanged(menuTabControl)
        self.selectTab(with: self.sendTabMenu.selectedIndex)
    }
    
    func selectItem(itemID: Int) {
        switch currentTab {
        case .coin:
            if let item = NormalPopkonType(rawValue: itemID) {
                textField.text = "\(itemID)"
                nCoin = item
            }
        case .event:
            if let item = EventPopkonType(rawValue: itemID) {
                textField.text = String(format: I18N.text_giftSomething.localized, item.stringValue())
                eCoin = item
                updateInfoLabel()
            }
        case .luxury:
            if let item = LuxuryPopkonType(rawValue: itemID) {
                textField.text = String(format: I18N.text_giftSomething.localized, item.stringValue())
                lCoin = item
                updateInfoLabel()
            }
        case .ascending:
            break
        case .series:
            break
        }
        
        //log.debug("selectItem \(self.textField.text!)")
    }
    
    /// 디바이스 회전시 설명창 높이값 조정
    /// - Note:  디바이스 회전시 설명창 높이 변경
    /// - 세로 상태일 경우 50으로 설정
    /// - 가로 상태일 경우 30으로 설정
    func updateRotation(isPortrait: Bool) {
        self.sendTabMenu.isPortrait = isPortrait
        self.sendTabMenu.resizeFrame()
        
//        if isPortrait {
//            popupViewHeightConstraint.constant = 50
//            miniPopupTextLabel.font = UIFont.notoBoldFont(ofSize: 10)
//        } else {
//            popupViewHeightConstraint.constant = 30
//        }
    }
    
    func updateInfoLabel() {
        dispatchMain.async {
            let userCoinText = "\(coinName): \(CellUtil.getNumberCommaFormat(text: "\(userInfo.coin)"))\(I18N.ui_numOfCoin.localized)"
            switch self.currentTab {
            case .coin:
                self.textLabel.text = userCoinText
            case .event:
                if self.eCoin == .none {
                    self.textLabel.text = ""
                    return
                }
                self.textLabel.text = "\(self.eCoin.stringValue()): \(self.eCoin.getUserCoin())\(I18N.ui_numOfCoin.localized)"
            case .luxury:
                if self.lCoin == .none {
                    self.textLabel.text = ""
                    return
                }
                self.textLabel.text = "\(self.lCoin.stringValue()): \(self.lCoin.getUserCoin())\(I18N.ui_numOfCoin.localized)"
            case .ascending:
                fallthrough
            case .series:
                self.userPopkonNumLabel.text = userCoinText
            }
        }
    }
    
    /// 선택된 아이템정보 초기화
    /// - Note:  팝콘/이벤트팝콘/럭셔리팝콘 선택된 아이템정보 초기화
    func resetSelectedItem() {
        nCoin = .none
        eCoin = .none
        lCoin = .none
    }
    
    /// 키보드 내리기 처리
    /// - Note:  텍스트필드 키보드 내림 처리
    func resignAllTextField() {
        textField.resignFirstResponder()
        inputOneTextField.resignFirstResponder()
        inputTwoTextField.resignFirstResponder()
    }
    
    func resetKeyboardInput() {
        self.resignAllTextField()
        textField.text = ""
    }
    
    func restorePageTwoFields() {
        if inputOneTextField.isEditing && inputOneTextField.text != nil {
            inputOneTextField.text = "\(savedFirstValue)"
        }
        
        if inputTwoTextField.isEditing && inputTwoTextField.text != nil {
            inputTwoTextField.text = "\(savedSecondValue)"
        }
    }
    
    func updatePageTwoFields() {
        if inputOneTextField.isEditing && inputOneTextField.text != nil {
            self.updatePageTwoFirstField()
        }
        
        if inputTwoTextField.isEditing && inputTwoTextField.text != nil {
            self.updatePageTwoSecondField()
        }
    }
    
    func unSetup() {
        self.onCloseMenu = {  }
        self.onChangeTab = {  }
        self.onSendCoin = {  }
        self.onBuyCoin = {  }
        self.onMoveItem = { item in  }
        self.onAutomaticSend = { _,_,_,_ in }
    }
    
    func isEditiong() -> Bool {
        if textField.isEditing ||
            inputOneTextField.isEditing ||
            inputTwoTextField.isEditing {
            return true
        }
        
        return false
    }
    
    //MARK: - Button Event
    
    /// UISegment 탭했을 경우 뷰화면 변경 처리
    /// - Note: 자동선물 작업이후 해당UI 제거처리.
    @IBAction func segmentTabChanged(_ sender: UISegmentedControl) {
        //currentTabIndex = sender.selectedSegmentIndex
        if let newTab = GiftMenuTab(rawValue: sender.selectedSegmentIndex) {
            currentTab = newTab
        }
        
        if currentTab == .coin {
            backPanelView.isHidden = false
        } else {
            backPanelView.isHidden = true 
        }
        
        textField.text = ""
        if currentTab == .coin {
            textField.isEnabled = true
            textField.placeholder = I18N.text_directInput.localized
        } else {
            textField.resignFirstResponder()
            textField.isEnabled = false
            textField.placeholder = ""
        }
        onChangeTab()
        updateUserCoin()
    }
    
    @IBAction func leftMove(_ sender: Any) {
        onMoveItem(-1)
    }
    @IBAction func rightMove(_ sender: Any) {
        onMoveItem(1)
    }
    
    @IBAction func closeMenu(_ sender: Any) {
        // self.isHidden = true
        resetKeyboardInput()
        resetSelectedItem()
        onCloseMenu()
    }
    
    @IBAction func buyCoin(_ sender: Any) {
        //resetKeyboardInput()
        self.resignAllTextField()
        self.miniPopupView.isHidden = true
        onBuyCoin()
        //self.isHidden = true
    }
    
    @IBAction func sendCoinGift(_ sender: Any) {
        self.resignAllTextField()
        
        if currentTab == .ascending || currentTab == .series {
            guard let valueA = Int( inputOneTextField.text! ) else {
                return
            }
            guard let valueB = Int( inputTwoTextField.text! ) else {
                return
            }
            
            let delay = delayTimeArr[ chooseSendDelayTime.selectedIndex ?? 0 ]
            onAutomaticSend(valueA,valueB,delay,currentTab)
        } else {
            onSendCoin()
        }
        //resetSelectedItem()
        //textFiled.text = ""
    }
    
    @IBAction func showHelpMessage(_ sender: Any) {
        self.miniPopupView.isHidden = self.miniPopupView.isHidden ? false : true
    }
    
    @IBAction func chooseDelay(_ sender: AnyObject) {
        self.resignAllTextField()
        chooseSendDelayTime.showDropdown()
        self.miniPopupView.isHidden = true
    }
    
    /// 보내려는 전체 코인 갯수 계산
    /// - Note: 두개 텍스트 필드 입력된 값을 가지고 총합을 계산
    /// 필드값이 정상적이지 않을때는 빈칸으로 표시
    private func updateTotalCoin() {
        guard let firstValue = Int( inputOneTextField.text! ) else  {
            self.totalGiftPopkonNumLabel.text = " "
            self.updateSendButtonLock(with: 0)
            return
        }
        guard let secondValue = Int( inputTwoTextField.text! ) else {
            self.totalGiftPopkonNumLabel.text = " "
            self.updateSendButtonLock(with: 0)
            return
        }
        
        if currentTab == .ascending {
            var totalCoin = self.getSumofIsometricSequences(with: firstValue, end: secondValue)
            if firstValue == secondValue {
               totalCoin = 0 
            }
            self.totalGiftPopkonNumLabel.text = CellUtil.getNumberCommaFormat(text: "\(totalCoin)")
            self.updateSendButtonLock(with: totalCoin)
            
        } else if currentTab == .series {
            let totalCoin = firstValue * secondValue
            self.totalGiftPopkonNumLabel.text = CellUtil.getNumberCommaFormat(text: "\(totalCoin)")
            self.updateSendButtonLock(with: totalCoin)
        }
    }
    
    /// 선물보내기 버튼 상태 업데이트
    /// - Note: 보내는 코인 전체값이 0이하 유효하지 않을때는 불능상태로 바꾼다.
    private func updateSendButtonLock(with total: Int) {
        if total > 0 {
            sendPageTwoButton.isEnabled = true
            sendPageTwoButton.backgroundColor = #colorLiteral(red: 0.1215686275, green: 0.1294117647, blue: 0.1411764706, alpha: 1)
        } else {
            sendPageTwoButton.isEnabled = false
            sendPageTwoButton.backgroundColor = UIColor.darkGray
        }
    }
    
    /// 일반팝콘 코인 갯수 입력창 업데이트
    /// - Note: 코인 입력 필드 키입력 완료후 값체크
    func updatePageOneTextField() {
        if currentTab == .coin {
            if let amount = Int( textField.text! ) {
                var checkValue = amount
                if checkValue < 1 {
                    textField.text = "\(defaultSeondCoin)"
                    checkValue = defaultSeondCoin
                }
                self.savedFirstValue = checkValue
            } else {
                textField.text = "\(self.savedFirstValue)"
            }
        }
    }
    
    
    /// 두산/연속팝콘 뷰화면 첫번째 텍스트필드 업데이트
    /// - Note: 첫번째 텍스트필드 키입력 완료후 값체크하여 조정
    private func updatePageTwoFirstField() {
        if let amount = Int( inputOneTextField.text! ) {
            var checkValue = amount
            if currentTab == .ascending {
                // 최대값 보다 작은지 (499)
                if checkValue > defaultStartMax {
                    //self.makeToast("최대 \(defaultStartMax)까지 가능합니다.")
                    inputOneTextField.text = "\(defaultStartMax)"
                    checkValue = defaultStartMax
                    //return
                }
                
                if checkValue < 1 {
                    inputOneTextField.text = "\(defaultStartCoin)"
                    checkValue = defaultStartCoin
                    //self.makeToast("최소 1이상 해야 합니다.")
                    //return
                }
                
            } else if currentTab == .series {
                // 값이 1000이상 넘는지
                if checkValue > defaultSeriesMax {
                    //self.makeToast("최대 \(defaultSeriesMax)까지 가능합니다.")
                    inputOneTextField.text = "\(defaultSeriesMax)"
                    checkValue = defaultSeriesMax
                    //return
                }
            }
            
            
            if self.checkRightNumericalExpression(with: inputOneTextField.text! ) == false {
                inputOneTextField.text = "\(checkValue)"
            }
            
            self.savedFirstValue = checkValue
            self.updateTotalCoin()
        } else {
            self.inputOneTextField.text = "" //"\(savedFirstValue)"
            self.updateTotalCoin()
        }
    }
    
    /// 두산/연속팝콘 뷰화면 두번째 텍스트필드 업데이트
    /// - Note: 두번째 텍스트필드 키입력 완료후 값체크하여 조정
    private func updatePageTwoSecondField() {
        if let amount = Int( inputTwoTextField.text! ) {
            var checkValue = amount
            if currentTab == .ascending {
                // 최대값 500이상 입력 불가
                if checkValue > defaultEndMax {
                    //self.makeToast("최대 \(defaultEndMax)까지 가능합니다.")
                    inputTwoTextField.text = "\(defaultEndMax)"
                    checkValue = defaultEndMax
                    //return
                }
            } else if currentTab == .series {
                // 값이 1000이상 넘는지
                if checkValue > defaultSeriesMax {
                    //self.makeToast("최대 \(defaultSeriesMax)까지 가능합니다.")
                    inputTwoTextField.text = "\(defaultSeriesMax)"
                    checkValue = defaultSeriesMax
                    //return
                }
            }
            
            if self.checkRightNumericalExpression(with: inputTwoTextField.text! ) == false {
                inputTwoTextField.text = "\(checkValue)"
            }
            
            self.savedSecondValue = checkValue
            self.updateTotalCoin()
        } else {
            self.inputTwoTextField.text = "" //"\(savedSecondValue)"
            self.updateTotalCoin()
        }
    }
    
    /// 텍스트필드 입력 완료 버튼 누를 경우 처리 이벤트
    /// - Note: 입력 완료버튼 누를 경우 키보드숨김처리후 입력값에 대한 체크한다.
    @IBAction func doneAction(_ sender: Any) {
        if textField.isEditing {
            textField.resignFirstResponder()
            self.updatePageOneTextField()
        }
        
        if inputOneTextField.isEditing && inputOneTextField.text != nil {
            inputOneTextField.resignFirstResponder()
            self.updatePageTwoFirstField()
        }
        
        if inputTwoTextField.isEditing && inputTwoTextField.text != nil {
            inputTwoTextField.resignFirstResponder()
            self.updatePageTwoSecondField()
        }
    }
    
    @objc func closeAllTextField() {
        if textField.isEditing {
            textField.resignFirstResponder()
            self.updatePageOneTextField()
        }
        
        if inputOneTextField.isEditing && inputOneTextField.text != nil {
            inputOneTextField.resignFirstResponder()
            self.updatePageTwoFirstField()
        }
        
        if inputTwoTextField.isEditing && inputTwoTextField.text != nil {
            inputTwoTextField.resignFirstResponder()
            self.updatePageTwoSecondField()
        }
    }
    
    //MARK: - 기타 함수들
    
    /// 1씩 증가하는 등차수열값의 합계산 함수.
    /// - Note: 시작값부터 끝값까지 1씩 증가시켜 모두 더한 값을 구한다.
    /// - Parameters:
    ///     - start: 시작값
    ///     - end: 끝값
    /// - Returns:  start부터 end까지 합한 값
    func getSumofIsometricSequences(with start: Int, end: Int) -> Int {
        
        let returnValue = ( end * ( end + 1) - (start - 1) * start ) / 2
        
        return returnValue < 0 ? 0 : returnValue
    }
    
    /// 입력된 문자열값이 제대로된 숫자열 표시인지 검사
    /// - Note: 예를 들어 "0010" 이렇게 0으로 시작될 경우 불필요한 0이 있는지 체크
    /// - Parameters:
    ///     - value: 입력된 문자열
    /// - Returns: 값 앞에 0이 존재하지 않을 경우 true
    private func checkRightNumericalExpression(with value: String) -> Bool {
        if value.first == "0" {
            return false
        }
        return true
    }
    
}

extension SendPopkonView : UITextFieldDelegate {
    
    /// 텍스트필드 입력 완료시
    /// - Note: 입력완료시 설명창을 숨김 처리한다.
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == inputOneTextField ||
            textField == inputTwoTextField {
            textField.text = ""
            self.miniPopupView.isHidden = true
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 7
    }
    
    func accessoryView() -> UIToolbar? {
        toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30))
        toolBar?.barTintColor = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: I18N.ui_editDone.localized, style: .done, target: self, action: #selector(closeAllTextField))
        doneBtn.setTitleTextAttributes( [NSAttributedString.Key.font : UIFont.notoBoldFont(ofSize:(18.0)), NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.01680417731, green: 0.1983509958, blue: 1, alpha: 1)], for: .normal)
        toolBar?.setItems([flexSpace, doneBtn], animated: false)
        toolBar?.sizeToFit()
        toolBar?.isUserInteractionEnabled = true
        
        return toolBar
    }
}
