//
//  ClipCellView.swift
//  Celuv
//
//  Created by Steven on 17/01/2017.
//  Copyright © 2017 roy. All rights reserved.
//

import UIKit

class ClipCellView: UIView {
    
    //stevenj edit
    let leftSpace : CGFloat = 5
    let topSpace : CGFloat = 0

    @IBOutlet var contView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var nickNameLabel: UILabel!
	@IBOutlet weak var cntLabel: UILabel!
	
    var bLoadImage = true
    
    var cast : CastInfo = CastInfo() {
        didSet {
            udpateContent()
        }
    }
    
    var onClick : (_ cast : CastInfo) -> Void = {
        cast in
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    //MARK: - Init
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
        let nib = UINib(nibName: "ClipCellView", bundle: bundle)
		contView = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        
        //stevenj edit
        contView.frame = CGRect(origin: CGPoint(x: leftSpace, y: topSpace), size: CGSize(width: bounds.width - (leftSpace*2), height: bounds.height - (topSpace*2)))
        contView.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        

        
        self.addSubview(contView)
        
        //additional setups
        self.backgroundColor = UIColor.clear
        
        //contView.layer.borderColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1).cgColor
        //contView.layer.borderWidth = 1
        contView.layer.masksToBounds = true
        
    }
    
    func loadImage() {
        bLoadImage = true
        self.imageView.sd_setImage(with: URL(string: self.cast.pFileName))
    }

    
    private func udpateContent() {
        if bLoadImage {
            self.imageView.sd_setImage(with: URL(string: self.cast.pFileName))
        }
		
        self.nameLabel.text = cast.nickName
        self.titleLabel.text = cast.castTitle
		self.nickNameLabel.text = cast.nickName
		self.cntLabel.text = "\(cast.watchCnt)".getDecimalString

    }
    
    @IBAction func clickAction(_ sender: Any) {
        onClick(cast)
    }
}
