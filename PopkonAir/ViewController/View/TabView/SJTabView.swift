//
//  SJTabView.swift
//  PopkonAir
//
//  Created by Steven on 15/12/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

struct SJTabButtonInfo {
    var title : String = ""
    var image : UIImage?
    var titleColor : UIColor = #colorLiteral(red: 0.2666666667, green: 0.6392156863, blue: 0.6705882353, alpha: 1)
    var titleColorSelected : UIColor = #colorLiteral(red: 0.3019607843, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
    var font : UIFont = UIFont.notoFont(ofSize: 14)
    var actionHandler  : (_ sender : UIButton)->Void  = {sender in }
    var size : CGSize = CGSize.zero
}

protocol SlideTabButtonProtocol {
    /// SJTabButtonInfo 프로퍼티 값을 이용하여 버튼 생성
    /// - Note: The function exists to get you up and running quickly, but it's recommended that you use the advanced usage configuration for most projects.
    /// - Parameters: SJTabButtonInfo 데이터
    /// - Returns:  UIView 인스턴스
    func createButton(with info : SJTabButtonInfo) -> UIView
    func buttonPressed(_ sender: AnyObject)
}


//MARK: - SlideTabMenuView
class SlideTabMenuView: UIView {
    
    //MARK: - Property
    var buttonArr : [SJTabButtonView] = []
    var scrollView : UIScrollView?
    var selectedIndex : Int = 0
    
    @IBInspectable var enableSelected : Bool = true
    
    /// - Note : 0 일때는 no scroll
    var numOfItemsShown = 0
    /// Button width
    var buttonWidth : Int {
        get {
            if buttonInfos.count == 0 {
                return 0
            }
            if numOfItemsShown > 0 {
                return Int(self.bounds.width) / numOfItemsShown
            }
            return Int(self.bounds.width) / buttonInfos.count
        }
    }
    var buttonInfos : [SJTabButtonInfo] = []
    var needResetOnLayoutSubvies = true
    
    //MARK: - Setup Button
    func setup() {
    }
    
    func unSetup() {
        clear()
        buttonInfos = []
    }
    
    /// 생성된 버튼 제거 및 스크롤뷰 제거
    func clear() {
        for button in buttonArr {
            button.removeFromSuperview()
        }
        buttonArr = []
        
        if scrollView != nil {
            scrollView?.removeFromSuperview()
            scrollView = nil
        }
    }
    
    /// 버튼이 눌렸을때 해당 버튼업데이트 및 다른 버튼들 일반상태로 변경처리
    /// - Note: 버튼 상태를 status 및 interactionEanbled 변경 처리
    /// - scrollView: nil이 아닐경우 스크롤이 필요하면 offset값 계산해서 setContentOffset
    func updateSelectedButton() {
        for (index,button) in buttonArr.enumerated() {
            button.frame = CGRect(x: index * buttonWidth, y: 0, width: buttonWidth, height: Int(self.bounds.height))
            if selectedIndex == index {
                if enableSelected {
                    button.button.isSelected = true
                    button.button.isUserInteractionEnabled = false
                }
                if let scrollView = self.scrollView {
                    var offset = CGPoint.zero
                    if scrollView.contentSize.width > scrollView.frame.width {
                        offset.x = min(scrollView.contentSize.width - scrollView.frame.width, button.frame.minX - buttonArr[0].frame.minX)
                    }
                    scrollView.setContentOffset(offset, animated: false)
                }
            }else {
                if enableSelected {
                    button.button.isSelected = false
                    button.button.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    /// 버튼 타이틀 이름 변경 처리
    /// - Parameters:
    ///     - buttonIndex:버튼리스트 인덱스
    ///     - title:버튼에 명시될 이름
    func setButtonTitle(with buttonIndex: Int, title: String) {
        for (index,button) in buttonArr.enumerated() {
            if index == buttonIndex {
                button.button.setTitle(title, for: .normal)
            }
        }
    }
    
    func selectTabButton(index: Int) {
        selectedIndex = index
        let selectButton = buttonArr[selectedIndex]
        if enableSelected {
            for button in buttonArr {
                if button.button == selectButton.button! {
                    button.button.isSelected = true
                    button.button.isUserInteractionEnabled = false
                }else {
                    button.button.isSelected = false
                    button.button.isUserInteractionEnabled = true
                }
            }
            
            // 탭버튼 위치가 스크롤뷰의 바운드밖이라면 스크롤이 되도록 한다.
            if let scView = scrollView {
                let addRange = selectButton.frame.width / 2
                if scView.bounds.maxX <= selectButton.frame.minX + addRange  ||
                    scView.bounds.minX >= selectButton.frame.maxX - addRange  {
                    scrollView?.scrollRectToVisible(selectButton.frame, animated: true)
                }
            }
        }
        buttonInfos[selectedIndex].actionHandler(selectButton.button)
    }
}

//MARK: - GiftTabMenuView
/// 선물하기뷰에서 표시된 탭메뉴
class GiftTabMenuView : SlideTabMenuView {
    
    /// 디바이스가 portrait 상태일때 한 화면에 표시될 버튼수
    var numsOnVertical  = 0
    /// 디바이스가 landscape 상태일때 한 화면에 표시될 버튼수
    var numsOnHorizon   = 0

    /// 선택된 경우 버튼 바탕색
    var selectedMainColor : UIColor = #colorLiteral(red: 1, green: 0.2901960784, blue: 0.337254902, alpha: 1)
    /// 선택안된 경우 버튼 바탕색
    var unselectedMainColor : UIColor = UIColor.white
    
    var isPortrait : Bool = true
    
    var leftSideView : UIView? = nil
    var rightSideView : UIView? = nil
    
    override var buttonWidth : Int {
        get {
            if buttonInfos.count == 0 {
                return 0
            }
            if numOfItemsShown > 0 {
                return Int(self.bounds.width) / numOfItemsShown
            }
            
//            let screenAspect = UIScreen.main.bounds.height / UIScreen.main.bounds.width
//            self.isPortrait = screenAspect > 1 ? true : false
//            //self.isPortrait = currentOrientation() == .portrait || currentOrientation() == .portraitUpsideDown
//            log.debug("[CO] \(screenAspect)")
            
            if numsOnVertical > 0 && isPortrait {
                return Int(self.bounds.width / CGFloat(numsOnVertical)) + 1
            }
            if numsOnHorizon > 0 && isPortrait == false {
                return Int(self.bounds.width / CGFloat(numsOnHorizon)) + 1
            }
            
            return Int(self.bounds.width) / buttonInfos.count
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = mainColor
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if needResetOnLayoutSubvies == false {
            return
        }
        
        for (index,button) in buttonArr.enumerated() {
            button.frame = CGRect(x: index * buttonWidth, y: 0, width: buttonWidth, height: Int(self.bounds.height))
        }
        
        if scrollView != nil {
            scrollView!.contentSize = CGSize(width: max(buttonWidth * buttonInfos.count, Int(self.bounds.width)), height: Int(self.bounds.height))
            updateSideIndicatorView(scrollView!)
        }
        
        updateSelectedButton()
    }
    
    
    func resizeFrame() {
        for (index,button) in buttonArr.enumerated() {
            button.frame = CGRect(x: index * buttonWidth, y: 0, width: buttonWidth, height: Int(self.bounds.height))
        }
        
        if scrollView != nil {
            scrollView!.contentSize = CGSize(width: max(buttonWidth * buttonInfos.count, Int(self.bounds.width)), height: Int(self.bounds.height))
            updateSideIndicatorView(scrollView!)
        }
        updateSelectedButton()
    }
    
    //MARK: - Setup
    /// 프로퍼티 속성값에 따라 버튼 생성하고 버튼이벤트를 연결한다. 뷰전체 사이즈에 맞게 보여질 갯수에 따른 버튼 사이즈맞게 생성한다.
    /// - Note: 특정값이 없을 경우 버튼 모두 표시. 스크롤뷰는 무시된다.
    /// - numOfItemsShown : 0이 아닐 경우 뷰사이즈 상관없이 해당 갯수에 버튼 표시되도록 한다.
    /// - numsOnHorizon & numsOnVertical : numOfItemsShown == 0 일 경우에 해당 값들 모두 0 일상일 때 적용된다
    override func setup(){
        self.clear()
        if buttonInfos.count > 0 {
            if numOfItemsShown > 0 || ( numsOnVertical > 0 && numsOnHorizon > 0 ) {    // 한화면에 나오는 아이템 갯수를 특정할때.
                let scrollView = UIScrollView(frame: self.bounds)
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.showsVerticalScrollIndicator = false
                scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                scrollView.delegate = self
                self.addSubview(scrollView)
                
                let addBound = CGRect(x: 0, y: 0, width: 10, height: self.bounds.height)
                let leftView = UIView(frame: addBound)
                leftView.backgroundColor = #colorLiteral(red: 0.7529411765, green: 0.1843137255, blue: 0.2235294118, alpha: 1)
                leftView.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(leftView)
                self.leftSideView = leftView
                
                leftView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
                leftView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
                leftView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
                leftView.widthAnchor.constraint(equalToConstant: 10).isActive = true
                
                
                let rightView = UIView(frame: addBound)
                rightView.backgroundColor = #colorLiteral(red: 0.7529411765, green: 0.1843137255, blue: 0.2235294118, alpha: 1)
                rightView.translatesAutoresizingMaskIntoConstraints = false
                self.addSubview(rightView)
                self.rightSideView = rightView
                
                rightView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
                rightView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
                rightView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
                rightView.widthAnchor.constraint(equalToConstant: 10).isActive = true
                
                //append buttons
                for (index, info) in buttonInfos.enumerated() {
                    if let button = self.createButton(with: info) as? SJTabButtonView {
                        button.button.tag = index
                        button.button.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
                        
                        if index == selectedIndex {
                            button.button.backgroundColor = selectedMainColor
                        } else {
                            button.button.backgroundColor = unselectedMainColor
                        }
                        buttonArr.append(button)
                        scrollView.addSubview(button)
                    }
                }
                scrollView.contentSize = CGSize(width: max(buttonWidth * buttonInfos.count, Int(self.bounds.width)), height: Int(self.bounds.height))
                self.scrollView = scrollView
            } else {
                // 특정갯수 값이 없을 경우 스크롤뷰 사용하지 않는다.
                for (index, info) in buttonInfos.enumerated() {
                    if let button = self.createButton(with: info) as? SJTabButtonView {
                        button.button.tag = index
                        button.button.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
                        
                        if index == selectedIndex {
                            button.button.backgroundColor = selectedMainColor
                        } else {
                            button.button.backgroundColor = unselectedMainColor
                        }
            
                        buttonArr.append(button)
                        self.addSubview(button)
                    }
                }
            }
        }
    }
    
    override func clear() {
        super.clear()
        if(leftSideView != nil) {
            leftSideView?.removeFromSuperview()
        }
        if(rightSideView != nil) {
            rightSideView?.removeFromSuperview()
        }
    }
    
    override func selectTabButton(index: Int)
    {
        selectedIndex = index
        let selectButton = buttonArr[selectedIndex]
        if enableSelected {
            for button in buttonArr {
                if button.button == selectButton.button! {
                    button.button.isSelected = true
                    button.button.isUserInteractionEnabled = false
                    button.button.backgroundColor = selectedMainColor
                }else {
                    button.button.isSelected = false
                    button.button.isUserInteractionEnabled = true
                    button.button.backgroundColor = unselectedMainColor
                }
            }
            
//            // 탭버튼 위치가 스크롤뷰의 바운드밖이라면 스크롤이 되도록 한다.
//            if let scView = scrollView {
//                let addRange = selectButton.frame.width / 2
//                if scView.bounds.maxX <= selectButton.frame.minX + addRange  ||
//                    scView.bounds.minX >= selectButton.frame.maxX - addRange  {
//                    scrollView?.scrollRectToVisible(selectButton.frame, animated: true)
//                }
//            }
        }
        buttonInfos[selectedIndex].actionHandler(selectButton.button)
        moveSelectedButton()
    }
    
    override func updateSelectedButton() {
        for (index,button) in buttonArr.enumerated() {
            button.frame = CGRect(x: index * buttonWidth, y: 0, width: buttonWidth, height: Int(self.bounds.height))
            if selectedIndex == index {
                if enableSelected {
                    button.button.isSelected = true
                    button.button.isUserInteractionEnabled = false
                }
                moveSelectedButton()
            }else {
                if enableSelected {
                    button.button.isSelected = false
                    button.button.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    /// 사이드 인디케이터 표시 업데이트
    /// - Note: 스크롤뷰 offset 값으로 판단하여 좌측,우측 표시자를 보일지 말지 결정한다.
    /// - Parameters: scrollView 인스턴스
    /// - Returns:  없음
    func updateSideIndicatorView(_ scrollView: UIScrollView) {
        guard let leftView = leftSideView else {
            return
        }
        guard let rightView = rightSideView else {
            return
        }
        
        let showButtonNums = isPortrait ? numsOnVertical : numsOnHorizon
        if scrollView.contentOffset.x > 5 {
            leftView.isHidden   = false
        } else {
            leftView.isHidden   = true
        }
        
        if scrollView.contentOffset.x + CGFloat(showButtonNums * buttonWidth) < scrollView.contentSize.width - 5 {
            rightView.isHidden = false
        } else {
            rightView.isHidden = true
        }
    }
    
    /// 선택된 탭메뉴로 이동
    /// - Note: 선택된 탭버튼으로 이동처리한다. 가운데 표시되도록 한다
    func moveSelectedButton() {
        if isPortrait == false {
            return
        }
        
        for (index,button) in buttonArr.enumerated() {
            //button.frame = CGRect(x: index * buttonWidth, y: 0, width: buttonWidth, height: Int(self.bounds.height))
            if selectedIndex == index {
                if let scrollView = self.scrollView {
                    var offset = CGPoint.zero
                    if scrollView.contentSize.width > scrollView.frame.width {
                        offset.x = min(scrollView.contentSize.width - scrollView.frame.width, button.frame.minX - buttonArr[0].frame.maxX)
                        if offset.x < 0 {
                            offset.x = 0
                        }
                    }
                    scrollView.setContentOffset(offset, animated: true)
                    if abs( scrollView.contentOffset.x - offset.x ) < 2 {
                        // 스크롤이 되지않으므로 바로 표시 업데이트
                        updateSideIndicatorView(scrollView)
                    }
                }
                break 
            }
        }
    }
}

extension GiftTabMenuView : SlideTabButtonProtocol {
    func createButton(with info: SJTabButtonInfo) -> UIView {
        let button = SJTabButtonView(frame:CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.height))
        button.setup(with: info)
        return button
    }
    
    @objc func buttonPressed(_ sender: AnyObject) {
        let button = sender as! UIButton
        selectedIndex = button.tag
        
        if enableSelected {
            for button in buttonArr {
                if button.button == sender as? NSObject {
                    button.button.isSelected = true
                    button.button.isUserInteractionEnabled = false
                    button.button.backgroundColor = selectedMainColor
                }else {
                    button.button.isSelected = false
                    button.button.isUserInteractionEnabled = true
                    button.button.backgroundColor = unselectedMainColor
                }
            }
        }
        
        buttonInfos[selectedIndex].actionHandler(button)
        
        // 센터로
        moveSelectedButton()
    }
}

extension GiftTabMenuView : UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        //log.debug("scrollViewWillBeginDragging")        
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate == false {
            self.updateSideIndicatorView(scrollView)
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateSideIndicatorView(scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.updateSideIndicatorView(scrollView)
    }
}


class SJTabView: SlideTabMenuView {

    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    //private var buttonArr : [SJTabButtonView] = []
    
    //BottomBlock View
    ///아이콘 표시여부
    @IBInspectable var enableBottomBlock : Bool = true
    @IBInspectable var bottomBlockColor : UIColor = tabUnderBarColor
    @IBInspectable var showBottomLine : Bool = false
    @IBInspectable var bottomLineColor : UIColor = tabUnderBarColor
    
    fileprivate var bottomBlock : TabBottomView! // = TabBottomView()
    
    //MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = mainColor
        self.setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if needResetOnLayoutSubvies == false {
            return
        }
        
        //selectedIndex = 0
        
        for (index,button) in buttonArr.enumerated() {
            button.frame = CGRect(x: index * buttonWidth, y: 0, width: buttonWidth, height: Int(self.bounds.height))
        }
        
        if enableBottomBlock {
            bottomBlock.frame = CGRect(x: 0, y: Int(self.bounds.height-3), width: buttonWidth, height: 3)
        }
        
        if scrollView != nil {
            scrollView!.contentSize = CGSize(width: max(buttonWidth * buttonInfos.count, Int(self.bounds.width)), height: Int(self.bounds.height))
        }
        
        updateSelectedButton()
    }
    
    //MARK: - Setup
    override func setup(){
        //Clear
        self.clear()
        
        if buttonInfos.count > 0 {
            
            if numOfItemsShown > 0 {
                scrollView = UIScrollView(frame: self.bounds)
                scrollView!.showsHorizontalScrollIndicator = false
                scrollView!.showsVerticalScrollIndicator = false
                scrollView!.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.addSubview(scrollView!)
                
                //append buttons
                for (index, info) in buttonInfos.enumerated() {
                    if let button = self.createButton(with: info) as? SJTabButtonView {
                        button.button.tag = index
                        button.button.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
                        buttonArr.append(button)
                        scrollView!.addSubview(button)
                    }
                }
                
                if showBottomLine {
                    let line = UIView()
                    line.backgroundColor = bottomLineColor
                    
                    var lineWidth = self.bounds.width
                    if let w = UIApplication.shared.keyWindow?.bounds.width {
                        lineWidth = w
                    }
                    
                    line.frame = CGRect(x: 0, y: self.bounds.height-2, width: lineWidth, height: 1)
                    scrollView?.addSubview(line)
                }
                
                if enableBottomBlock {
                    self.bottomBlock = TabBottomView()
                    //Add bottom block
                    bottomBlock.frame = CGRect(x: 0, y: Int(self.bounds.height-3), width: buttonWidth, height: 3)
                    bottomBlock.fillColor = bottomBlockColor
                    scrollView!.addSubview(bottomBlock)
                }
                
                scrollView?.contentSize = CGSize(width: max(buttonWidth * buttonInfos.count, Int(self.bounds.width)), height: Int(self.bounds.height))

                
            }else {
                //append buttons
                for (index, info) in buttonInfos.enumerated() {
                    if let button = self.createButton(with: info) as? SJTabButtonView {
                        button.button.tag = index
                        button.button.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
                        buttonArr.append(button)
                        self.addSubview(button)
                    }
                }
                
                if enableBottomBlock {
                    //Add bottom block
                    bottomBlock.frame = CGRect(x: 0, y: Int(self.bounds.height-3), width: buttonWidth, height: 3)
                    bottomBlock.fillColor = bottomBlockColor
                    self.addSubview(bottomBlock)
                }
            }
        }
    }
    
    override func clear() {
        super.clear()
        if(bottomBlock != nil) {
            bottomBlock.removeFromSuperview()
        }
    }
    
    //MARK: - Setter
    override func updateSelectedButton() {
        
        //        bottomBlock.frame = CGRect(x: buttonWidth * selectedIndex, y: Int(self.bounds.height-3), width: buttonWidth, height: 3)
        for (index,button) in buttonArr.enumerated() {
            
            button.frame = CGRect(x: index * buttonWidth, y: 0, width: buttonWidth, height: Int(self.bounds.height))
            
            if selectedIndex == index {
                
                if enableSelected {
                    button.button.isSelected = true
                    button.button.isUserInteractionEnabled = false
                }
                
                if enableBottomBlock {
                    bottomBlock.frame = CGRect(x: 0, y: Int(self.bounds.height-3), width: buttonWidth, height: 3)
                    bottomBlock.moveTo(x: Double(button.frame.minX))
                }
                
                if scrollView != nil {
                    var offset = CGPoint.zero
                    if scrollView!.contentSize.width > scrollView!.frame.width {
                        offset.x = min(scrollView!.contentSize.width - scrollView!.frame.width, button.frame.minX - buttonArr[0].frame.minX)
                    }
                    
                    self.scrollView!.setContentOffset(offset, animated: false)
                    
                }
                
            }else {
                
                if enableSelected {
                    button.button.isSelected = false
                    button.button.isUserInteractionEnabled = true
                }
            }
        }
    }
    
//    func updateButtonTitle(buttonIndex: Int, title: String) {
//        for (index,button) in buttonArr.enumerated() {
//            if index == buttonIndex {
//                button.button.setTitle(title, for: .normal)
//            }
//        }
//    }
    
    override func selectTabButton(index: Int)
    {
        selectedIndex = index
        let selectButton = buttonArr[selectedIndex]
        if enableSelected {
            for button in buttonArr {
                if button.button == selectButton.button! {
                    button.button.isSelected = true
                    button.button.isUserInteractionEnabled = false
                    
                    if enableBottomBlock {
                        bottomBlock.moveTo(x: Double(button.frame.minX))
                    }
                }else {
                    button.button.isSelected = false
                    button.button.isUserInteractionEnabled = true
                }
            }
            
            // 탭버튼 위치가 스크롤뷰의 바운드밖이라면 스크롤이 되도록 한다.
            if let scView = scrollView {
                let addRange = selectButton.frame.width / 2
                if scView.bounds.maxX <= selectButton.frame.minX + addRange  ||
                    scView.bounds.minX >= selectButton.frame.maxX - addRange  {
                    scrollView?.scrollRectToVisible(selectButton.frame, animated: true)
                }
            }
        }
        buttonInfos[selectedIndex].actionHandler(selectButton.button)
    }

    
}



extension SJTabView : SlideTabButtonProtocol {
    func createButton(with info : SJTabButtonInfo) -> UIView {
        let button = SJTabButtonView(frame:CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.height))
        button.setup(with: info)
        return button
    }
    
    //MARK: - IBAction
    @objc func buttonPressed(_ sender: AnyObject) {
        
        let button = sender as! UIButton
        selectedIndex = button.tag
        
        if enableSelected {
            for button in buttonArr {
                if button.button == sender as? NSObject {
                    button.button.isSelected = true
                    button.button.isUserInteractionEnabled = false

//                    log.debug(self.bottomBlock.frame)
//                    log.debug(button.frame.minX)
                    
                    if enableBottomBlock {
                        bottomBlock.moveTo(x: Double(button.frame.minX))
                    }
                    
//                    log.debug(self.bottomBlock.frame)
                }else {
                    button.button.isSelected = false
                    button.button.isUserInteractionEnabled = true
                }
            }
        }
        
        buttonInfos[selectedIndex].actionHandler(button)
        
    }
}
