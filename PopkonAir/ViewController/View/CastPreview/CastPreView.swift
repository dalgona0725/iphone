//
//  CastPreView.swift
//  PopkonAir
//
//  Created by Steven on 02/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import AVFoundation

let previewHeight : CGFloat = 120

class CastPreView: UIView {
    
    private let audioSession = AVAudioSession.sharedInstance()
    
    @IBOutlet private var container: UIView!
    @IBOutlet weak var playerView: CastPlayerView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var volumeButton: UIButton!
    
    var onSwipeHandler : (_ x : CGFloat)->Void = {x in }
    var onSwipeAnimationFinishedHandler : ()->Void = {}
    
    var onTapHandler : (_ cast : CastInfo ,_ castMember : CastMemberInfo)->Void = {_,_ in }
    
    fileprivate let panGesture : UIPanGestureRecognizer = UIPanGestureRecognizer()
    fileprivate let tapGesture : UITapGestureRecognizer = UITapGestureRecognizer()
    
    private var cast        : CastInfo = CastInfo()
    private var castMember  : CastMemberInfo = CastMemberInfo()
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
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
        let nib = UINib(nibName: "CastPreView", bundle: bundle)
        container = nib.instantiate(withOwner: self, options: nil)[0] as? UIView
        container.frame = bounds
        
        self.addConstraint(NSLayoutConstraint(item: container as Any, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: container as Any, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: container as Any, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: container as Any, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        //        container.autoresizingMask = [.flexibleBottomMargin,.flexibleHeight,.flexibleLeftMargin,.flexibleRightMargin,.flexibleTopMargin,.flexibleWidth]
        //        container.updateConstraintsIfNeeded()
        self.addSubview(container)
    }
    
    private func initSetup() {
        volumeButton.isSelected = !(audioSession.outputVolume==0)
        
        //Add gestureRecognizer
        panGesture.addTarget(self, action: #selector(handlePan))
        panGesture.delegate = self
        
        tapGesture.addTarget(self, action: #selector(handleTap))
        tapGesture.delegate = self
        
        self.addGestureRecognizer(panGesture)
        self.addGestureRecognizer(tapGesture)
        
        playerView.outVolumeChange = updateVolumeStatus
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //        container.frame = self.bounds
    }
    
    func setup(with cast : CastInfo , castMember : CastMemberInfo) {
        self.cast = cast
        self.castMember = castMember
        //log.debug(castMember.castURL)
        
        if playerView.isPlaying() {
            if self.playerView.isSameURL(url: castMember.castURL) {
                return
            }
            self.playerView.player?.close()
            dispatchMain.asyncAfter(deadline: .now()+0.5) {
                self.playerView.setMute(mute: !self.volumeButton.isSelected )
                self.playerView.setup(with: self.castMember.castURL)
                self.titleLabel.text = self.cast.castTitle
            }
        } else {
            initSetup()
            playerView.setMute(mute: !volumeButton.isSelected )
            playerView.setup(with: castMember.castURL)
            self.titleLabel.text = cast.castTitle
        }
    }
    
    func unsetup() {
        playerView.unSetup()
    }
    
    @IBAction func volButtonAction(_ sender: AnyObject) {
        volumeButton.isSelected = !volumeButton.isSelected
        playerView.setMute(mute: !volumeButton.isSelected)
    }
    
    //MARK: - Volume
    func updateVolumeStatus() {
        //log.debug("outputvolume = \(self.audioSession.outputVolume)")
        volumeButton.isSelected = !(audioSession.outputVolume==0)
        playerView.setMute(mute: !volumeButton.isSelected)
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        
        log.debug("handle start")
        
        let translation = recognizer.translation(in: self.playerView)
        
        //log.debug(translation.x)
        if recognizer.state == .ended {
            
            if abs(translation.x) <= UIScreen.main.bounds.width/4 {
                //Revert
                UIView.animate(withDuration: 0.25, animations: {
                    self.layer.transform = CATransform3DIdentity
                    
                    self.onSwipeHandler(abs(0))
                    
                })
            }else {
                //Hide preview
                UIView.animate(withDuration: 0.25, animations: {
                    
                    if translation.x > 0 {
                        self.layer.transform = CATransform3DMakeTranslation(UIScreen.main.bounds.width, 0, 0)
                    }else {
                        self.layer.transform = CATransform3DMakeTranslation(-UIScreen.main.bounds.width, 0, 0)
                    }
                    
                    self.onSwipeHandler(UIScreen.main.bounds.width/2)
                    
                }, completion: { (finished) in
                    self.onSwipeAnimationFinishedHandler()
                    
                    let deadlineTime = DispatchTime.now() + .milliseconds(200)
                    dispatchMain.asyncAfter(deadline: deadlineTime, execute: {
                        self.unsetup()
                    })
                    
                    
                })
            }
            
        }else {
            //On changed
            self.layer.transform = CATransform3DTranslate(self.playerView.layer.transform, translation.x, 0, 0)
            
            self.onSwipeHandler(abs(translation.x))
        }
    }
    
    @IBAction func handleTap(recognizer:UITapGestureRecognizer) {
        
        //log.debug("handle tap start")
        
        onTapHandler(cast, castMember)
    }
}

extension CastPreView : UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer == tapGesture {
            if tapGesture.numberOfTouches == 1{
                return true
            }else {
                return false
            }
        }
        
        return true
    }
}
