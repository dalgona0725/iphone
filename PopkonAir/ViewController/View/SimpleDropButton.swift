//
//  SimpleDropButton.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 12. 19..
//  Copyright © 2017년 eugene. All rights reserved.
//

import UIKit
import DropDown

class SimpleDropButton: UIButton {
    private let dropdown : DropDown = DropDown()
    
    //선택한 항목
    var selectedItem : String? {
        get {
            return dropdown.selectedItem
        }
        set(newValue) {
            
            if newValue != nil {
                if let index = self.dataSource.firstIndex(of: newValue!) {
                    self.dropdown.selectRow(at: index)
                    self.setTitle(newValue!, for: .normal)
                    return
                }
            }
            
            self.dropdown.selectRow(at: nil)
            self.setTitle("", for: .normal)
        }
    }
    
    var selectedIndex : Int? {
        get {
            if let index = self.dataSource.firstIndex(of: dropdown.selectedItem!) {
                
                return index
            }else {
                return nil
            }
        }
        set(newVlaue) {
            self.dropdown.selectRow(at: newVlaue)
            self.setTitle(self.selectedItem, for: .normal)
        }
    }
    
    var dataSource : [String] {
        get {
            return dropdown.dataSource
        }
        set(newValue) {
            dropdown.dataSource = newValue
            //dropdown.selectRow(at: 0)
        }
    }
    
    open func selectRow(index: Int) {
        dropdown.selectRow(at: index)
    }
    
    open func selectionBackgroundColor(color:UIColor) {
        dropdown.selectionBackgroundColor = color
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupDropDown()
    }
    
    //    // Only override draw() if you perform custom drawing.
    //    // An empty implementation adversely affects performance during animation.
    //    override func draw(_ rect: CGRect) {
    //        // Drawing code
    //        self.setImage(#imageLiteral(resourceName: "selectdrop"), for: .normal)
    //
    //        self.updateContentEdgeinsets()
    //    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //self.updateContentEdgeinsets()
        dropdown.bottomOffset = CGPoint(x: 0, y: self.bounds.height)
    }
    
    
    //MARK: - Public
    ///Show Dropdown
    func showDropdown(){
        self.dropdown.show()
    }
    ///Hide Dropdown
    func hideDropdown(){
        self.dropdown.hide()
    }
    
    func setSelectionAction(action : @escaping (_ index:Int, _ item : String) -> Void) {
        dropdown.selectionAction = { (index, item) in
            action(index, item)
        }
    }
    
    //MARK: - Private
    private func updateContentEdgeinsets() {
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -100, bottom: 0, right: 0)
    }
    
    private func setupDropDown() {
        dropdown.dataSource = [""]
        dropdown.selectRow(at: 0)
        dropdown.direction = .any
        dropdown.dismissMode = .onTap
        dropdown.bottomOffset = CGPoint(x: 0, y: self.bounds.height)
        dropdown.anchorView = self
        dropdown.selectionAction = { [unowned self] (index, item) in
            self.setTitle(item, for: UIControl.State())
        }
        
    }
}
