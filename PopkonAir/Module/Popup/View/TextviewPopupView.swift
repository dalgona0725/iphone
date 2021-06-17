//
//  TextviewPopupView.swift
//  PopkonAir
//
//  Created by Brian Park on 10/09/2019.
//  Copyright © 2019 The E&M. All rights reserved.
//

import UIKit

class TextviewPopupView: AlertPopupView {
	fileprivate var maxTexViewInput = 300
	
	var maxInputText : Int {
		get {
			return maxTexViewInput
		}
		set {
			maxTexViewInput = newValue
		}
	}
	
	var buttonActions : [(_ text : String)->Void] = []
	
	@IBOutlet weak var txtView: UITextView!
	
	//MARK: - Class Func
	override class func instanceFromNib() -> TextviewPopupView {
		return Bundle.main.loadNibNamed("TextviewPopupView", owner: self, options: nil)?.first as! TextviewPopupView
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		
		txtView.layer.borderWidth = 0.3
		txtView.layer.borderColor = UIColor.RGBColor(red: 207, green: 207, blue: 207).cgColor
		txtView.backgroundColor = UIColor.RGBColor(red: 246, green: 246, blue: 246)
		self.updateOkButtonColor(color: popupOkButtonColor)
        
		NotificationCenter.default.addObserver(self,
											   selector: #selector(self.keyboardChanged(notification:)),
											   name: UIResponder.keyboardWillChangeFrameNotification,
											   object: nil)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTapToHideKeyboard(_:)))
		self.addGestureRecognizer(tap)
	}
	
	@objc func handleTapToHideKeyboard(_ sender: UITapGestureRecognizer) {
		self.endEditing(true)
	}
	
	@objc func keyboardChanged(notification : Notification) {
		if let userInfo = notification.userInfo {
			let animationTime = (userInfo["UIKeyboardAnimationDurationUserInfoKey"] as! NSNumber).doubleValue
			let keyboardRect = (userInfo["UIKeyboardFrameEndUserInfoKey"] as! NSValue).cgRectValue
			
			var moveValue : CGFloat = 0
            let maxFrameY = self.frame.origin.y + self.frame.height + ( -1 * self.transform.ty )
			if keyboardRect.origin.y < maxFrameY {
				moveValue = maxFrameY - keyboardRect.origin.y
			}
			
			let trans = CATransform3DMakeTranslation(0, -moveValue, 0)
			UIView.animate(withDuration: animationTime, animations: {
				self.layer.transform = trans
			})
		}
	}
    
	override func updateFrame() {        
        if UIDevice.current.isScreen4inch() || UIDevice.current.isScreen35inch() {
            let width =  min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.height) - 20
            let newFrame = CGRect(x: 0, y: 0, width: width, height: self.frame.height * 0.8 )
            self.frame = newFrame
        }
		orgSize = self.frame.size
	}
	
	func setKeyboardType(keyType : UIKeyboardType ) {
		txtView.keyboardType = keyType
	}
	
	func setPlaceHolder( text : String) {
		setupTextviewPlaceholder = text
	}
	
	func setButtonActions(actions : [(_ text : String)->Void]) {
		buttonActions = actions
	}
	
	//MARK: - IBActions
	@IBAction override func cancelAction(_ sender: AnyObject) {
		self.closeup()
		if self.buttonActions.count > 1 {
			self.buttonActions[1](txtView.text!)
		}
		self.buttonActions.removeAll()
	}
	
	@IBAction override func okAction(_ sender: AnyObject) {
		log.debug("@@@@ txtView.text: \(txtView.text!)")
		self.closeup()
		if self.buttonActions.count > 0 {
			self.buttonActions[0](txtView.text!)
		}
		self.buttonActions.removeAll()
	}
	
	override func closePopup() {
		self.resignFirstResponder()
		dispatchMain.async {
			self.cancelAction(self)
		}
	}
	
	func closeup() {
		self.hide()
		NotificationCenter.default.removeObserver(self)
	}
}

// MARK: - UITextViewDelegate
extension TextviewPopupView: UITextViewDelegate {
	func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
		return textView.text.count + (text.count - range.length) <= maxTexViewInput
	}
	
	override open var bounds: CGRect {
		didSet {
			self.resizePlaceholder()
		}
	}
	
	var setupTextviewPlaceholder: String? {
		get {
			var placeholderText: String?
			
			if let placeholderLabel = self.viewWithTag(100) as? UILabel {
				placeholderText = placeholderLabel.text
			}
			
			return placeholderText
		}
		set {
			if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
				placeholderLabel.text = newValue
				placeholderLabel.sizeToFit()
			} else {
				self.addPlaceholder(newValue!)
			}
		}
	}

	func textViewDidChange(_ textView: UITextView) {
		if let placeholderLabel = self.viewWithTag(100) as? UILabel {
			placeholderLabel.isHidden = textView.text.count > 0
		}
	}
	
	private func resizePlaceholder() {
		if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
			let labelX = self.txtView.textContainer.lineFragmentPadding
			let labelY = self.txtView.textContainerInset.top - 2
			let labelWidth = self.frame.width - (labelX * 2)
			let labelHeight = placeholderLabel.frame.height
			
			placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
		}
	}
	
	private func addPlaceholder(_ placeholderText: String) {
		let placeholderLabel = UILabel()
		
		placeholderLabel.text = placeholderText
		placeholderLabel.sizeToFit()
		
		placeholderLabel.font = self.txtView.font
		placeholderLabel.textColor = UIColor.lightGray
		placeholderLabel.tag = 100
		
		placeholderLabel.isHidden = self.txtView.text.count > 0
		
		self.txtView.addSubview(placeholderLabel)
		self.resizePlaceholder()
		self.txtView.delegate = self
	}
}
