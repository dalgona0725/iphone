//
//  TextEditToolView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 8. 7..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit

enum TextEditMode : Int {
    case none
    case textColor
    case backColor
    case fontSize
}

class TextEditToolView: UIView {
    
    @IBOutlet var contentView: UIView!
    
    @IBOutlet weak var buttonMenuView: UIView!
    @IBOutlet weak var colorPickView: ColorPickerView!

    var editMode : TextEditMode = .none
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //var onBack : (Bool) -> Void = { invert in }
    
    // var onAlpha : () -> Void = {  }
    var onSize : () -> Void = { }
    var onTextColor: () -> Void = { }
    var onBackColor: () -> Void = {  }
    var onChangeColor : (TextEditMode, UIColor) -> Void = { (_,_) in }
    var onChangeValue : (TextEditMode, Float) -> Void = { (_,_) in }
    var onClose : () -> Void = { }
    
    @IBOutlet weak var textSizeButton: UIButton!
    @IBOutlet weak var textColorButton: UIButton!
    @IBOutlet weak var backColorButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var slideValueLabel: UILabel!
    @IBOutlet weak var valueSlider: UISlider!
    
    //MARK: - UI Init
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
        let nib = UINib(nibName: "TextEditToolView", bundle: bundle)
        contentView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        //contentView.isUserInteractionEnabled = false
        self.addSubview(contentView)
        
        
        colorPickView.backgroundColor = UIColor.clear
        colorPickView.setupColors(colors: [UIColor.white, UIColor.black, UIColor.red, UIColor.blue, UIColor.yellow, UIColor.orange, UIColor.green, UIColor.brown, UIColor.purple, UIColor.darkGray, UIColor.cyan, UIColor.gray, UIColor.lightGray, UIColor.magenta ] )
        colorPickView.isHidden = true
        colorPickView.onPickColor = { color in
            self.onChangeColor(self.editMode,color)
        }
        
        slideView.isHidden = true
        
        buttonMenuView.layer.cornerRadius  = 7
        buttonMenuView.layer.masksToBounds = true
        
        doneButton.setTitle(I18N.ui_editDone.localized, for: .normal)
        textSizeButton.setTitle(I18N.ui_textSize.localized, for: .normal)
        textColorButton.setTitle(I18N.ui_textColor.localized, for: .normal)
        backColorButton.setTitle(I18N.ui_backgroundColor.localized, for: .normal)
        
    }
    
    func setPickColor(color : UIColor) {
//        let ci = CIColor(color: color)
//        log.debug("setPickColor \(ci.red) \(ci.green) \(ci.blue)")
        
        colorPickView.selectColor(value: color)
    }
        
    func resetAction() {
        self.onClose = {  }
        self.onSize = {  }
        self.onTextColor = {  }
        self.onBackColor = {  }
        self.onChangeColor = { _,_ in }
        self.onChangeValue = { _,_ in  }
        self.colorPickView.onPickColor = { _ in  }
    }
    
    func hideUI() {
        editMode = .none
        colorPickView.isHidden = true
        slideView.isHidden = true
        
        textColorButton.isSelected = false
        backColorButton.isSelected = false
        textSizeButton.isSelected = false
        
        valueSlider.value = 1.0
        colorPickView.alphaSlider.value = 1.0
    }
    
    func setInvert(bInvert: Bool) {
        backColorButton.isSelected = bInvert
    }
    
    func setSliderValue(value : Float) {
        slideValueLabel.text = String(describing: Int(value))
        valueSlider.value = value
    }
    
    func hideDoneButton(hide: Bool) {
        doneButton.isHidden = hide
    }

    @IBAction func changedFontSize(_ sender: Any) {
        slideValueLabel.text = String(describing: Int(valueSlider.value))
        onChangeValue( editMode, valueSlider.value )
    }

    @IBAction func clickTextColor(_ sender: UIButton) {
        
        backColorButton.isSelected = false
        textSizeButton.isSelected = false
        
        if editMode != .backColor {
            colorPickView.isHidden = !colorPickView.isHidden
        }
        
        if editMode == .textColor {
            colorPickView.isHidden = true
            editMode = .none
        }
        
        if colorPickView.isHidden == false {
            slideView.isHidden = true
            editMode = .textColor
            onTextColor()
        }
        textColorButton.isSelected = colorPickView.isHidden == false ? true : false
    }
    
    @IBAction func clickBackgroundColor(_ sender: UIButton) {
        
        textColorButton.isSelected = false
        textSizeButton.isSelected = false
        
        if editMode != .textColor {
            colorPickView.isHidden = !colorPickView.isHidden
        }
        
        if editMode == .backColor {
            colorPickView.isHidden = true
            editMode = .none
        }
        
        if colorPickView.isHidden == false {
            slideView.isHidden = true
            editMode = .backColor
            onBackColor()
        }
        backColorButton.isSelected = colorPickView.isHidden == false ? true : false
    }
    
    @IBAction func clickFontSize(_ sender: UIButton) {

        textColorButton.isSelected = false
        backColorButton.isSelected = false
        
        if editMode == .fontSize {
            slideView.isHidden = true
            editMode = .none
        } else {
            editMode = .fontSize
            slideView.isHidden = false
            colorPickView.isHidden = true
            valueSlider.minimumValue = 10
            valueSlider.maximumValue = 40
        }
        
        textSizeButton.isSelected = slideView.isHidden == false ? true : false
        onSize()
    }
    
    @IBAction func onCloseButton(_ sender: UIButton) {
        onClose()
    }
    @IBAction func onBlockButton(_ sender: UIButton) {
        
        log.debug("Tab onBlockButton")
    }
}
