//
//  SelectDropButton.swift
//  PopkonAir
//
//  Created by Steven on 02/11/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit
import DropDown

class SelectDropButton: UIButton {

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
            dropdown.selectRow(at: 0)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupDropDown()
        
    }
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.setImage(#imageLiteral(resourceName: "selectdrop"), for: .normal)
        
        self.updateContentEdgeinsets()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.updateContentEdgeinsets()
        
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
    
    func resetSelectionAction() {
        dropdown.selectionAction = nil
    }
    
    func deselectRow() {
        dropdown.selectRow(at: nil)
    }
    
    //MARK: - Private
    private func updateContentEdgeinsets() {
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.frame.width - 25, bottom: 0, right: 0)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
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
		// 드랍다운 커스텀 UI
		dropdown.backgroundColor = .white
		dropdown.selectedTextColor = UIColor.celuvPupleColor()
		dropdown.selectionBackgroundColor = .white
		dropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
			cell.optionLabel.textAlignment = .center
		}

    }
    


}
