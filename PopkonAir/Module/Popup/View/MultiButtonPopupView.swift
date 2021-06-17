//
//  MultiButtonPopupView.swift
//  PopkonAir
//
//  Created by Steven on 21/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class MultiButtonPopupView: PopupView {
    
    //title + cancel button
    let defaultHeight = 55 + 4 + 51
    let rowHeight = 40

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleBar: UIView!
    
    var buttonTitles : [String] = [] {
        didSet {
            self.setLayerOutLine(borderWidth: 1, cornerRadius: 3)
            
            titleLabel.textColor = .white
            titleBar.backgroundColor = popupMainColor
            cancelButton.backgroundColor = popupMainColor
            cancelButton.setTitleColor(.white, for: .normal)
			cancelButton.setTitle(I18N.ui_cancel.localized, for: .normal)

            let tableHeight = buttonTitles.count * rowHeight
            tableViewHeightConstraint.constant = CGFloat(tableHeight)
            
            dispatchMain.async {
                var rect = self.frame
                rect.size.height = CGFloat(self.defaultHeight + tableHeight)
                
                self.frame = rect
            }
        }
    }
    var buttonAction : (_ selectedIndex : Int) -> Void = { index in }
    var cancelAction : ()->Void = {}
    
    
    //MARK: - Class Func
    class func instanceFromNib() -> MultiButtonPopupView {
        return (Bundle.main.loadNibNamed("MultiButtonPopupView", owner: self, options: nil)![0] as? MultiButtonPopupView)!
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        
        dispatchMain.async {
            popupManager.hide(popup: self)
            self.cancelAction()
            self.buttonAction = { index in }
            self.cancelAction = {  }
        }
    }
    
    override func closePopup() {
        
        dispatchMain.async {
            self.hide()
            self.buttonAction = { index in }
            self.cancelAction = {  }
        }
        
    }

}

extension MultiButtonPopupView : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buttonTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
            
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            cell.textLabel?.text = buttonTitles[indexPath.row]
            
            return cell
            
        }else {
            let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
            
            cell.textLabel?.text = buttonTitles[indexPath.row]
            cell.textLabel?.textAlignment = .center
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        dispatchMain.async {
            popupManager.hide(popup: self)
            self.buttonAction(indexPath.row)
        }
    }
}
