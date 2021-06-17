//
//  Extension.swift
//  PopkonAir
//
//  Created by roy on 2016. 8. 14..
//  Copyright © 2016년 roy. All rights reserved.
//

import UIKit
import SDWebImage
import FLAnimatedImage

extension NSArray {
	func toJsonString() -> String? {
		var error: NSError? = nil
		var jsonData: Data?
		do {
			jsonData = try JSONSerialization.data( withJSONObject: self, options: .prettyPrinted)
		} catch let error1 as NSError {
			error = error1
			jsonData = nil
		}
		var jsonString: String? = nil
		
		if error != nil {
            print( "toJsonString error : \(String(describing: error?.localizedDescription))" )
		} else {
			jsonString = NSString( data: jsonData!, encoding: String.Encoding.utf8.rawValue ) as? String
			jsonString = jsonString!.replacingOccurrences( of: "\n", with: "", options: .literal, range: nil )
		}
		
		return jsonString
	}
}

extension Date {
    public func strDateToString (_ format: String) -> String {
        let formatter = DateFormatter ()
        formatter.locale = Locale.current
        formatter.dateFormat = format
        
        return formatter.string(from: self)
    }
}

extension Dictionary {
	func toJsonString() -> String? {
		var error: NSError? = nil
		var jsonData: Data?
		do {
			jsonData = try JSONSerialization.data( withJSONObject: self as AnyObject, options: .prettyPrinted)
		} catch let error1 as NSError {
			error = error1
			jsonData = nil
		}
		var jsonString: String? = nil
		
		if error != nil {
			print( "toJsonString error : \(String(describing: error?.localizedDescription))" )
		} else {
			jsonString = NSString( data: jsonData!, encoding: String.Encoding.utf8.rawValue ) as? String
			jsonString = jsonString!.replacingOccurrences( of: "\n", with: "", options: .literal, range: nil )
		}
		
		return jsonString
	}
}

extension String {
	func toDouble() -> Double {
		return (self as NSString).doubleValue
	}
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
	
	func isValidEmail() -> Bool {
		let regex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: .caseInsensitive)
		return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
	}
	
	func hasCharacters() -> Bool{
		do {
			let regex = try NSRegularExpression(pattern: "^[가-힣a-zA-Z0-9]*$", options: .caseInsensitive)
			if let _ = regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, self.count)) {
				return true
			}
		} catch {
			print(error.localizedDescription)
			return false
		}
		return false
	}
	
	var getDecimalString: String {
		let decimalFormatter = NumberFormatter()
		decimalFormatter.numberStyle = .decimal
		
		if let number = Int(self) {
			return decimalFormatter.string(from: NSNumber(value:number)) ?? ""
		}
		return ""
	}
	
	var htmlToAttributedString: NSAttributedString? {
		 guard let data = data(using: .utf8) else { return NSAttributedString() }
		 do {
			 return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
		 } catch {
			 return NSAttributedString()
		 }
	 }
	
	 var htmlToString: String {
		 return htmlToAttributedString?.string ?? ""
	 }
    
    /// 한글 문자열 조합관련 두개를 조합가능 여부 체크 함수
    /// - Note: 키보드 입력 문자열 조합할때 해당문자 글자수 변화 체크용도로 사용한다. 내부적으로 유니코드 값으로 해당 음절분해해서 처리한다.
    /// - Parameters:
    ///    - addText : 추가할 글자 (1음절) 구분이 없는 호환용 한글코드값이 아닐경우 무조건 false 리턴한다.
    /// - Returns: 결합하여 1글자로 처리된다면 true를 리턴한다.
    func canCombineKoreanCharacter(addText: String) -> Bool {
        
        guard let lastText = self.last else {
            return false
        }
        guard  let currentValue = UnicodeScalar(String(lastText))?.value else {
            return false
        }
        guard let addValue = UnicodeScalar(addText)?.value else {
            return false
        }
        
        /// 추가되는 음절
        var isConsonant = false
        var isVowel = false
        var isMiddleDot = false
        var addIndex = 0
        
        if addValue < 0x3131 || addValue > 0x3163 {
            if addText.containMiddleDot() {
                isVowel = true
                isMiddleDot = true
            } else {
                return false
            }
        } else {
            if addValue > 0x314E {
                isVowel = true
                addIndex = Int(addValue - 0x314F)
            } else {
                isConsonant = true
                addIndex = Int(addValue - 0x3131)
            }
        }
        
        
        /// '가' ~ '힣' 사이안에 있으면 한글음절로 판단
        let value = Int(currentValue)
        if value >= 0x3131 && value <= 0x3163 {
            if isConsonant {
                // 된소리가 가능한 자음이 올경우
                // ㄲ, ㄸ, ㅃ, ㅆ, ㅉ
                let fortisIndices = [1,7,18,21,24]
                let index = Int(value - 0x3131)
                if index == addIndex && fortisIndices.contains(addIndex) {
                    return true
                }
                return false
            }  else if isVowel {
                if value > 0x314E {
                    // 모음 + 모음이 될경우
                    var enableIndex = [Int]()
                    let index = Int(value - 0x314F)
                    switch index {
                    case 0:
                        fallthrough
                    case 2:
                        fallthrough
                    case 4:
                        fallthrough
                    case 6:
                        fallthrough
                    case 9:
                        fallthrough
                    case 18:
                        fallthrough
                    case 17:    // ㅏ,ㅑ,ㅕ,ㅓ,ㅠ,ㅘ,ㅡ   + ㅣ
                        enableIndex = [20]
                    case 8:     // ㅗ +  ㅏ ㅣ ㅐ
                        enableIndex = [0, 1, 20]
                    case 13:    // ㅜ + ㅣ ㅓ ㅔ
                        enableIndex = [4, 5, 20]
                    default:
                        break
                    }
                    if enableIndex.contains(addIndex) {
                        return true
                    }
                } else {
                    // 자음 + 모음
                    return true
                }
            }
        }
        
        if isVowel && self.containMiddleDot() {
            /// 한글 자모상에서 인덱스
            let enableIndex = [ 0, 4, 8, 11, 13, 18, 20 ]
            if enableIndex.contains( addIndex ) {
                return true
            }
        }
        
        if value >= 0xAC00 && value <= 0xD7A3 {
            let initial = (value - 0xac00) / 28 / 21
            let medial = ((value - 0xac00) / 28) % 21
            let final = (value - 0xac00) % 28
            if initial >= 0 && medial < 0 {
                // i) 초성만 있을 경우
                if isConsonant {
                    // 된소리가 가능한 자음이 올경우
                    // ㄲ, ㄸ, ㅃ, ㅆ, ㅉ
                    let fortisIndices = [1,7,18,21,24]
                    if initial == addIndex && fortisIndices.contains(addIndex) {
                        return true
                    }
                    return false
                }  else if isVowel {
                    return true
                }
            } else if initial >= 0  && medial >= 0 && final < 1 {
                // ii) 중성까지 있을 경우
                
                if isConsonant {
                    // 자음이 올경우
                    return true
                } else if isVowel {
                    // 합성이 될 수 있은 모음이 올경우
                    var enableIndex = [Int]()
                    switch medial {
                    case 0:
                        fallthrough
                    case 2:
                        fallthrough
                    case 4:
                        fallthrough
                    case 6:
                        fallthrough
                    case 9:
                        fallthrough
                    case 18:
                        fallthrough
                    case 17:    // ㅏ,ㅑ,ㅕ,ㅓ,ㅠ,ㅘ,ㅡ   + ㅣ
                        enableIndex = [20]
                    case 8:     // ㅗ +  ㅏ ㅣ ㅐ
                        enableIndex = [0, 1, 20]
                    case 13:    // ㅜ + ㅣ ㅓ ㅔ
                        enableIndex = [4, 5, 20]
                    default:
                        break
                    }
                    if enableIndex.contains(addIndex) {
                        return true
                    }
                    
                    if isMiddleDot {
                        /// 중성상에서 인덱스
                        enableIndex = [ 0, 4, 8, 11, 13, 18, 20 ]
                        if enableIndex.contains( medial ) {
                            return true
                        }
                    }
                }
            } else {
                // iii) 종성까지 있을 경우.
                if isConsonant && final > 0 {
                    var enableIndex = [Int]()
                    switch final {
                    case 4 :    /// ㄴ   앉 않
                        enableIndex = [ 23, 29 ]
                    case 8 :    /// ㄹ   앍 앎 앏 앐 앒 앑 앓
                        enableIndex = [ 0, 16, 17, 20, 27, 28, 29 ]
                    case 18 :   /// ㅂ    앖
                        enableIndex = [ 17 ]
                    default:
                        break
                    }
                    if enableIndex.contains(addIndex) {
                        return true
                    }
                }
            }
        }
        return false
    }
}


extension UIAlertController {
	
	static func showMessage(_ message: String) {
		showAlert(title: "", message: message, actions: [UIAlertAction(title: "OK", style: .cancel, handler: nil)])
	}
	
	static func showAlert(title: String?, message: String?, actions: [UIAlertAction]) {
		DispatchQueue.main.async {
			let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
			for action in actions {
				alert.addAction(action)
			}
			if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController, let presenting = navigationController.topViewController {
				presenting.present(alert, animated: true, completion: nil)
			}
		}
	}
}

extension UILabel {
	func setLabel(text: String, size: CGFloat, weight: UIFont.Weight, color: UIColor) {
		self.text = text
		self.font = UIFont.systemFont(ofSize: size, weight: weight)
		self.textColor = color
		self.sizeToFit()
	}
	
	func setNeoLabel(text: String, size: CGFloat, color: UIColor) {
		self.text = text
		self.font = UIFont(name: "AppleSDGothicNeo-Regular", size: size)
		self.textColor = color
		self.sizeToFit()
	}
	
	func setNeoBoldLabel(text: String, size: CGFloat, color: UIColor) {
		self.text = text
		self.font = UIFont(name: "AppleSDGothicNeo-Bold", size: size)
		self.textColor = color
		self.sizeToFit()
	}
	
	func setNotoLabel(text: String, size: CGFloat, color: UIColor) {
		self.text = text
		self.font = UIFont(name: "NotoSansCJKkr-Regular", size: size)
		self.textColor = color
		self.sizeToFit()
	}
	
	func setNotoBoldLabel(text: String, size: CGFloat, color: UIColor) {
		self.text = text
		self.font = UIFont(name: "NotoSansCJKkr-Bold", size: size)
		self.textColor = color
		self.sizeToFit()
	}
	
	func setNotoLightLabel(text: String, size: CGFloat, color: UIColor) {
		self.text = text
		self.font = UIFont(name: "NotoSansCJKkr-Light", size: size)
		self.textColor = color
		self.sizeToFit()
	}
	
}

extension String {
    
    var urlQueryAllowedString: String {
        if let encoded  = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
            return encoded
        } else {
            return self
        }
    }
    
    var composedCount : Int {
        var count = 0
        //enumerateSubstringsInRange(startIndex..<endIndex, options: .ByComposedCharacterSequences) {_ in count++}
        enumerateSubstrings(in: startIndex..<endIndex, options: .byComposedCharacterSequences) { (subString, subStringRange, _, _) in
            
            //let upper1 = subStringRange.upperBound.encodedOffset
            //let lower1 = subStringRange.lowerBound.encodedOffset
            //let count1 = count + (upper1-lower1)
            
            if let text = subString {
                let upper = subStringRange.upperBound.utf16Offset(in: text)
                let lower = subStringRange.lowerBound.utf16Offset(in: text)
                count = count + (upper-lower)
            }
            //log.debug("TEST - \(count1) : \(count)")
        }
        return count
    }
    
    func needComposedCounting() -> Bool {
        return containsEmoji() || containMiddleDot()
    }
    
    func containMiddleDot() -> Bool {
        for scalar in self.unicodeScalars {
            switch scalar.value {
            case 4514,  // ᆢ
            4510,  // ᆞ
            12685:  // ㆍ
                return true
            default:
                continue
                
            }
        }
        return false
    }
    
    func containsEmoji() -> Bool {
        for scalar in self.unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x1F1E6...0x1F1FF, // Regional country flags
            0x2600...0x26FF, // Misc symbols
            0x2700...0x27BF, // Dingbats
            0xE0020...0xE007F, // Tags
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            0x1F018...0x1F270, // Various asian characters
            0x238C...0x2454, // Misc items
            0x20D0...0x20FF: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// 채팅메세지값 마지막 의미없는 "\n" 값 제거처리
    static func removeLastEmptyLine(text: String) -> String {
        if let sub = text.range(of: "\n") {
            let endIndex = sub.lowerBound
            let startIndex = sub.upperBound
            var curr = String(text[..<endIndex])
            let check = String(text[startIndex...])
            
            let all = check.replacingOccurrences(of: "\n", with: "")
            if all.isEmpty == false {
                curr.append("\n" + removeLastEmptyLine(text: check) )
            }
            return curr
        }
        return text
    }
    
    
}

extension UIButton {
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))
        
        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
         
        self.setBackgroundImage(backgroundImage, for: state)
    }
}


extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension FLAnimatedImageView {
    func setImage(with url: URL?) {
        sd_internalSetImage(with: url,
                            placeholderImage: UIImage(),
                            options: SDWebImageOptions(rawValue: 0),
                            context: nil,
                            setImageBlock: { [weak self] (image, imageData, cache, url) in
                                guard let sf = self else { return }
                                
                                let imageFormat = NSData.sd_imageFormat(forImageData: imageData)
                                if imageFormat == .GIF {
                                    DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                                        let animatedImage = FLAnimatedImage(animatedGIFData: imageData)
                                        DispatchQueue.main.async { [weak self] in
                                            guard let sf = self else { return }
                                            
                                            sf.animatedImage = animatedImage
                                            sf.image = nil
                                        }
                                    }
                                } else {
                                    sf.image = image
                                    sf.animatedImage = nil
                                }
                            },
                            progress: nil,
                            completed: nil)
    }
}
