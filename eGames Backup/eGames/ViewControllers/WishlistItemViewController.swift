//
//  WishlistItemViewController.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/5/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Cocoa

public class WishlistItemViewController: NSViewController {
    
    @IBOutlet var tabView: NSTabView!
    @IBOutlet weak var addEdit: NSTabViewItem!
    @IBOutlet weak var itemView: NSTabViewItem!
    
    //add edit items
    @IBOutlet weak var tagTextField: NSTextField!
    @IBOutlet weak var releaseYearTextField: NSTextField!
    @IBOutlet weak var estimatedPriceTextField: NSTextField!
    @IBOutlet weak var typeComboBox: NSComboBox!
    
    @IBOutlet weak var clearButton: NSButton!
    
    var isOldItem : Bool = false
    
    //itemView
    @IBOutlet weak var tagLabel: NSTextField!
    @IBOutlet weak var yearLabel: NSTextField!
    @IBOutlet weak var priceLabel: NSTextField!
    @IBOutlet weak var typeLabel: NSTextField!
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func viewItem() {
        tagLabel.stringValue = selectedItem.tag
        yearLabel.stringValue = String(selectedItem.releaseYear)
        priceLabel.stringValue = "$\(String(format: "%.2f", selectedItem.estimatedPrice))"
        typeLabel.stringValue = selectedItem.type
    }
    
    public func addItem() {
        clear(self)
        clearButton.isHidden = false
        isOldItem = false
    }
    
    public func editItem() {
        clear(self)
        clearButton.isHidden = true
        isOldItem = true
        
        tagTextField.stringValue = selectedItem.tag
        releaseYearTextField.stringValue = "\(selectedItem.releaseYear)"
        estimatedPriceTextField.stringValue = "$\(selectedItem.estimatedPrice)"
        typeComboBox.selectItem(withObjectValue: selectedItem.type)
    }
    
    @IBAction func done(_ sender: Any) {
        var missing : String = String()
        
        let name : String = tagTextField.stringValue.trimmingCharacters(in: .whitespaces)
        if name.isEmpty { missing += "Title/Name\n" }
        
        let year : String = releaseYearTextField.stringValue.trimmingCharacters(in: .whitespaces)
        if year.isEmpty { missing += "Release Year\n" }
        
        let ep : String = estimatedPriceTextField.stringValue.trimmingCharacters(in: .whitespaces)
        if ep.isEmpty { missing += "Estimated Price\n" }
        
        let type : String = typeComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        if type.isEmpty { missing += "Type\n" }
        
        if missing.isEmpty {
            if isOldItem { updateItem() }
            else { createNewItem() }
        }
        else { dialogOKCancel(question: "Wishlist Item is missing the following information:", text: missing) }
    }
    
    public func createNewItem() {
        
        let tag : String = tagTextField.stringValue.trimmingCharacters(in: .whitespaces)
        let year : String = releaseYearTextField.stringValue.trimmingCharacters(in: .whitespaces)
        let price : String = estimatedPriceTextField.stringValue.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "$", with: "")
        
        let wishlistitem : WishlistItem = WishlistItem()
        wishlistitem.tag = tag
        wishlistitem.releaseYear = Int(year)!
        wishlistitem.dateAdded = Date()
        wishlistitem.estimatedPrice = Double(price)!
        
        wishlistitem.type = typeComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        if wishlistitem.type == "Game" { wishlistitem.image = NSImage(named: "Game")! }
        else { wishlistitem.image = NSImage(named: "Platform")! }

        viewController.wishlistArrayController.addItem(wishlistitem)
        self.dismiss(self)
        wishlistItemCreatedConfirmation(wishlistitem)
    }
    
    public func updateItem() {
        let tag : String = tagTextField.stringValue.trimmingCharacters(in: .whitespaces)
        let year : String = releaseYearTextField.stringValue.trimmingCharacters(in: .whitespaces)
        let price : String = estimatedPriceTextField.stringValue.trimmingCharacters(in: .whitespaces).replacingOccurrences(of: "$", with: "")
        let type = typeComboBox.stringValue.trimmingCharacters(in: .whitespaces)
    
        selectedItem.tag = tag
        selectedItem.releaseYear = Int(year)!
        selectedItem.estimatedPrice = Double(price)!
        
        if selectedItem.type != type  { viewController.wishlistArrayController.swapItem() }
        
        viewController.wishlistArrayController.necessaryUpdate(selectedItem.type)
        self.dismiss(self)
        itemEditConfirmation()
    }
    
    @IBAction func clear(_ sender: Any) {
        typeComboBox.deselectItem(at: typeComboBox.indexOfSelectedItem)
        
        tagTextField.stringValue = String()
        tagTextField.placeholderString = String()
        releaseYearTextField.stringValue = String()
        releaseYearTextField.placeholderString = String()
        estimatedPriceTextField.stringValue = String()
        estimatedPriceTextField.placeholderString = String()
        
    }
    
    @IBAction func edit(_ sender: Any) {
        self.editItem()
        self.tabView.selectTabViewItem(addEdit)
        self.view.window?.title = "Editing \(selectedItem.tag)"
    }
    
    @IBAction func delete(_ sender: Any) {
        self.dismiss(self)
        windowController.delete(self)
    }
}
