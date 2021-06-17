//
//  EntranceAnimationView.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 2. 5..
//  Copyright © 2018년 eugene. All rights reserved.
//

struct EntranceItemUser {
    var  userId : String = ""
    var  userNick : String = ""
    var  item : EntranceItem = .bike
}

enum EntranceItem : Int {
    case bike       = 1
    case car        = 2
    case train      = 3
    case plane      = 4
    
    func getResourceName() -> String {
        switch self {
        case .bike:     return "mobile_ios_bike_"
        case .car:      return "mobile_ios_car_"
        case .train:    return "mobile_ios_train_"
        case .plane:    return "mobile_ios_plane_"
        }
    }
    
    func getDuration() -> Float {
        return 1.5
    }
    
    func getFrameNum() -> Int {
        return 15
    }
}


class EntranceAnimationView : UIView {
    
    var imageSize : CGSize = CGSize.zero
    var imageRatio : CGFloat = 0
    var imageView : UIImageView?
    var textLabel : UILabel = UILabel()
    var item : EntranceItem = .bike
    var isPlayerViewFullScreen = false
    var defaultFrame : CGRect = CGRect()
    var backPanelView = UIView()
    
    @objc var onFinished : () -> Void = { }
    var reserveTimer : Timer? = nil

    func setFrameRect(of totalFrame: CGRect)
    {
        defaultFrame = totalFrame
    }
    
    func setup(of totalFrame: CGRect) {
        setFrameRect(of: totalFrame)
        //self.backgroundColor = UIColor.darkGray
        //self.addSubview(imageView)
        self.backgroundColor = UIColor.clear
        //self.alpha = 0.7
        
        backPanelView = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        backPanelView.backgroundColor = UIColor.black
        backPanelView.alpha = 0.3
        backPanelView.isHidden = true
        self.addSubview(backPanelView)
        
        self.textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 40))
        self.textLabel.font = UIFont.notoMediumFont(ofSize: 17)
        self.textLabel.textAlignment = .right
        self.addSubview(textLabel)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(self.tapHandler(_:)))
        self.addGestureRecognizer(gesture)
    }
    
    func unSetup() {
        onFinished = {}
    }
    
    //MARK: - Action
    @objc func tapHandler(_ sender:UITapGestureRecognizer){
        if self.alpha > 0.9 {
            self.vanishView()
        }
    }
    
    func play(entranceInfo: EntranceItemUser, totalFrame: CGRect ) {
        
        self.alpha = 1.0
        if reserveTimer != nil {
            reserveTimer?.invalidate()
            reserveTimer = nil
        }
        
        self.item = entranceInfo.item
   
        let images = (1...item.getFrameNum()).compactMap { (index) -> UIImage? in
            if let path = Bundle.main.path(forResource: String(format: "%@%02d_default", item.getResourceName(), index) , ofType: "png") {
                return UIImage(contentsOfFile: path) ?? nil
            }
            return nil
        }
   
        if images.count > 0 {
            imageRatio = images[0].size.height / images[0].size.width
            imageSize = images[0].size
            
            let imgView = UIImageView()
            imgView.animationImages = images
            imgView.animationDuration = TimeInterval(item.getDuration())
            imgView.animationRepeatCount = 1
            imgView.startAnimating()
            
            self.imageView = imgView
            //self.addSubview(imageView!)
            self.insertSubview(imageView!, belowSubview: textLabel)
            
            self.isHidden = false
            self.backPanelView.isHidden = false
            self.updateLayout()
            
            reserveTimer = Timer.scheduledTimer(withTimeInterval: TimeInterval(item.getDuration()), repeats: false, block: { (timer) in
                //self.onFinshed()
                self.vanishView()
            })
        }
    
        let totalAttr = NSMutableAttributedString(string: "")
        totalAttr.append(NSAttributedString(string: entranceInfo.userNick, attributes: [NSAttributedString.Key.font: UIFont.notoBoldFont(ofSize: 19) ,NSAttributedString.Key.foregroundColor: #colorLiteral(red: 1, green: 0.8, blue: 0, alpha: 1)] ))
        totalAttr.append(NSAttributedString(string: self.protectUserID(with: " (" + entranceInfo.userId + ")", to: "*"), attributes: [NSAttributedString.Key.font: UIFont.notoFont(ofSize: 14) ,NSAttributedString.Key.foregroundColor:#colorLiteral(red: 0.6784, green: 0.8667, blue: 0.302, alpha: 1) ] ))
        totalAttr.append(NSAttributedString(string: I18N.text_watcherEnter.localized, attributes: [NSAttributedString.Key.font: UIFont.notoFont(ofSize: 14) ,NSAttributedString.Key.foregroundColor: UIColor.darkGray]))
        textLabel.attributedText = totalAttr
    }
    
    func protectUserID(with message: String, to : String) -> String {
        if let part = message.range(of: "\\([^)]+\\)", options: .regularExpression) {
            if part.isEmpty == false {
                let distance = message.distance(from: part.lowerBound, to: part.upperBound)
                let length = distance/2
                let cStr = String(repeating: to, count: length)
                
                if length > 0  {
                    let start = message.index(part.upperBound, offsetBy: -length)
                    let end = message.index(part.upperBound, offsetBy: -1)
                    let idRange = Range(uncheckedBounds: (start, end))
                    let total = message.replacingCharacters(in: idRange, with: cStr)
                    return total
                }
            }
        }
        return message
    }
    
    func vanishView() {
        if reserveTimer != nil {
            reserveTimer?.invalidate()
            reserveTimer = nil
        }
        
        UIView.animate(withDuration: 0.4, animations: {
            self.alpha = 0
        }) { (succeed) in
            
            if let imgView = self.imageView {
                imgView.stopAnimating()
                imgView.removeFromSuperview()
                imgView.animationImages?.removeAll()
            }
            self.imageView = nil
            self.onFinished()
        }
    }
    
    func isAnimating() -> Bool {
        //return imageView.isAnimating
        
        if imageView != nil {
            return imageView!.isAnimating
        }
        
        return false
    }
    
    func updateLayout() {
        if imageView == nil {
            return
        }
        
        if imageSize.width == 0 && imageSize.height == 0 {
            return
        }
        
        var xPos : CGFloat = 0.0
        var yPos : CGFloat = 0.0
        
        let totalWidth = defaultFrame.width
        let totalHeight = defaultFrame.height
        let screenAspectRatio = totalHeight / totalWidth
        
        var width : CGFloat = 0.0
        var height: CGFloat = 0.0
        
        // 가로화면 일때
        if screenAspectRatio <  1 {
            height  = totalHeight
            width   = height / imageRatio
            xPos    = (totalWidth - width) * 0.5
            yPos    = 0
        } else {
            // 세로화면 일경우.
            width   = totalWidth
            height  = width * imageRatio
            xPos    = 0
            yPos    = totalHeight - height
        }
        
        self.frame = CGRect(x: xPos, y: yPos, width: width, height: height)
        imageView!.frame = CGRect(x: 0, y: 0, width: width, height: height)
        textLabel.frame.origin = CGPoint(x: self.frame.width - textLabel.frame.width - 15, y: self.frame.height - textLabel.frame.height - 5)
        
        backPanelView.frame = imageView!.frame
    }
    
}
