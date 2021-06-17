//
//  LetterDetailViewController.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2018. 5. 21..
//  Copyright © 2018년 eugene. All rights reserved.
//

import Foundation

class LetterDetailViewController : BaseViewController {
    
    @IBOutlet weak var letterOwnerTypeLabel: UILabel!
    @IBOutlet weak var letterDateTitleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var sentDateLabel: UILabel!
    @IBOutlet weak var messageTextView: UITextView!
    
    @IBOutlet weak var buttonWidthEqualConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButtonLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var replyButtonWidthConstraint: NSLayoutConstraint!
    var paperType : LetterReadType = .received
    var paperInfo = PaperDetailInfo()
    
    var isAdminLetter : Bool = false
    
    //MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if paperType == .received {
            
            senderLabel.text = paperInfo.sendSignID
            letterOwnerTypeLabel.text = I18N.text_sender.localized
            letterDateTitleLabel.text = I18N.text_receiveDate.localized
            
        } else {
            
            senderLabel.text = paperInfo.receiveSignID
            letterOwnerTypeLabel.text = I18N.text_receiver.localized
            letterDateTitleLabel.text = I18N.text_sendDate.localized
            
            deleteButton.setTitle(I18N.ui_actionDelete.localized, for: .normal)
            deleteButton.setTitleColor(UIColor.white, for: .normal)
            deleteButton.backgroundColor = #colorLiteral(red: 0.9334709048, green: 0.3915753365, blue: 0.3600414693, alpha: 1)
            
            replyButton.setTitle(I18N.ui_actionReply.localized, for: .normal)
            replyButtonWidthConstraint.constant = 0
            deleteButtonLeadingConstraint.constant = 0
            buttonWidthEqualConstraint.isActive = false 
        }
        
        // 관리자 쪽지
        if isAdminLetter {
            senderLabel.text = I18N.text_supervisor.localized
        }
        
        sentDateLabel.text = CellUtil.getFullDateString(with: paperInfo.sendDate)
        messageTextView.text = paperInfo.text
        
        
        deleteButton.setLayerOutLine(borderWidth: 1, cornerRadius: 0, borderColor: UIColor.darkGray)
        replyButton.setLayerOutLine(borderWidth: 1, cornerRadius: 0, borderColor: UIColor.darkGray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if paperType == .received {
            self.setBarTitle(with: I18N.text_receivedLetter.localized)
        } else if paperType == .sent {
            self.setBarTitle(with: I18N.text_sendLetter.localized)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - User Log out
    override func willLogOut() {
    }
    override func didLogOut(_ notification: NSNotification) {
    }
    
    //MARK: - Setup UI
    @IBAction func replyLetterAction(_ sender: Any) {
        dispatchMain.async {
            let writeVC = self.viewController(storyboard: "Letter", identifier: "LetterWriteViewController") as! LetterWriteViewController
            self.navigationController?.pushViewController(writeVC, animated: true)
            writeVC.setup(targetID: self.paperInfo.sendSignID, isAdmin: self.isAdminLetter)
        }
    }
    @IBAction func deleteLetterAction(_ sender: Any) {
        
        let deletePaperProcess : () -> Void = {
            popupManager.showAlert(content: I18N.text_removeLetter.localized, buttonTitles: [I18N.ui_ok.localized,I18N.ui_cancel.localized], buttonActions: [{
                popupManager.showLoadingView()
                connection.deletePaper(paperID: self.paperInfo.code, isSender: self.paperType == .sent , complete: { (succeed, resultInfo ) in
                    if succeed {
                        /*popupManager.showAlert(content: "쪽지를 삭제하였습니다.", buttonTitles: ["확인"], buttonActions: [{
                         self.navigationController?.popViewController(animated: true)
                         }])*/
                        dispatchMain.async {
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                    popupManager.hideLoadingView()
                })
                },{}])
        }
        
        userInfo.checkLoginStatus(finished: {
            dispatchMain.async {
                deletePaperProcess()
            }
        }, failed: {
            dispatchMain.async {
                if let navigator = self.navigationController {
                    for vc in navigator.viewControllers {
                        
                        if ((vc as? MyInfoViewController) != nil) ||
                            ((vc as? RankViewController) != nil) {
                            self.navigationController?.popToViewController(vc, animated: true)
                        }
                    }
                }
            }
        })
        
    }
    
    func setInfo(info: PaperDetailInfo, type: LetterReadType, isAdmin: Bool = false) {
        self.paperInfo = info
        self.paperType = type
        self.isAdminLetter = isAdmin
    }
    
}
