//
//  ColorPickerView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 8. 1..
//  Copyright © 2017년 roy. All rights reserved.
//

import UIKit

class ColorPickerView: UIView, UIScrollViewDelegate {

    @IBOutlet private var contView: UIView!
    @IBOutlet private weak var colorScrollView: UIScrollView!
    @IBOutlet weak var alphaSlider: UISlider!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var colorInfos : [UIColor] = []
    var onPickColor : (UIColor) -> Void = { color in }
    var pageNums : Int = 0
    
    var colorButtons : [UIButton] = []
    
    var currentColor = UIColor.white
    
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
        let nib = UINib(nibName: "ColorPickerView", bundle: bundle)
        contView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        contView.frame = bounds
        contView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        self.addSubview(contView)
    
        colorScrollView.backgroundColor = UIColor.clear
        contView.backgroundColor = UIColor.clear
    }

    func setupColors(colors: [UIColor]) {
        let viewSize = 44
        let margin = 6
        let buttonSize = viewSize - 2 * margin
        colorInfos = colors
        
        colorButtons = []
        for index in 0..<colors.count {
            let itemView = UIView(frame: CGRect(x: index * viewSize, y: 0, width: viewSize, height: viewSize))
            let button = UIButton(type: .custom)
            itemView.backgroundColor = UIColor.clear
            button.frame = CGRect(x: margin, y: margin, width: buttonSize, height: buttonSize)
            button.tag = index
            //button.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
            button.backgroundColor = colors[index]
            button.layer.borderColor = UIColor.white.cgColor
            button.layer.borderWidth = 2
            button.layer.cornerRadius = button.frame.height * 0.5
            //button.clipsToBounds = true
            button.addTarget(self, action: #selector(self.buttonPressed(_:)), for: .touchUpInside)
            
            itemView.addSubview(button)
            colorScrollView.addSubview(itemView)
            colorButtons.append(button)
        }
        
        colorScrollView.contentSize = CGSize(width: max(viewSize * colorInfos.count, Int(self.bounds.width)), height: viewSize)
        colorScrollView.delegate = self
    }
    
    
    func setAlphaValue(value: Float) {
        alphaSlider.value = value
    }
    
    func selectColor(value: UIColor) {
        for btn in colorButtons {
            btn.layer.borderColor = UIColor.white.cgColor
            btn.layer.borderWidth = 2
        }
        
        if value == UIColor.clear {
            return 
        }
        
        let color = value.withAlphaComponent(1.0)
        setAlphaValue(value: Float(value.cgColor.alpha))
        
        for (index,c) in colorInfos.enumerated() {
            if c == color {
                for btn in colorButtons {
                    if btn.tag == index {
                        btn.layer.borderColor = #colorLiteral(red: 0.8784, green: 0.2196, blue: 0, alpha: 1).cgColor
                        btn.layer.borderWidth = 3
                        break
                    }
                }
                currentColor = value
                break
            }
        }
    }
    
    //MARK: - IBAction
    @objc func buttonPressed(_ sender: UIButton) {
        var result = UIColor.clear
        if sender.tag < colorInfos.count {
            result = colorInfos[sender.tag]
        }
        log.debug("selectedColor \(result)")
        
        for btn in colorButtons {
            if btn.tag == sender.tag {
                btn.layer.borderColor = #colorLiteral(red: 0.8784, green: 0.2196, blue: 0, alpha: 1).cgColor
                btn.layer.borderWidth = 3
            } else {
                btn.layer.borderColor = UIColor.white.cgColor
                btn.layer.borderWidth = 2
            }
        }
        
        currentColor = result.withAlphaComponent(CGFloat(alphaSlider.value))
        onPickColor(currentColor)
    
    }
    
//    @IBAction func pageChangedAction(_ sender: Any) {
//        colorScrollView.setContentOffset(CGPoint(x: CGFloat(pageControl.currentPage) * colorScrollView.frame.width,y:0), animated: true)
//    }
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let pageWidth = scrollView.frame.size.width
//        
//        let value = floor((scrollView.contentOffset.x - pageWidth / CGFloat(pageControl.numberOfPages)) / pageWidth ) + 1.0
//        pageControl.currentPage = Int(value)
//    }
    
    @IBAction func chagedValue(_ sender: Any) {
        
        currentColor = currentColor.withAlphaComponent(CGFloat(alphaSlider.value))
        onPickColor(currentColor)
        
    }
}
