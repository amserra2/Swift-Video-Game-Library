//
//  PlatformViewController.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/5/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Cocoa

public class PlatformViewController: NSViewController {
    
    @IBOutlet var tabView: NSTabView!
    @IBOutlet weak var addEdit: NSTabViewItem!
    @IBOutlet weak var platformView: NSTabViewItem!
    
    //addEdit items
    @IBOutlet weak var nameTextField: NSTextField!
    @IBOutlet weak var releaseDatePicker: NSDatePicker!
    @IBOutlet weak var typeComboBox: NSComboBox!
    @IBOutlet weak var developerComboBox: NSComboBox!
    @IBOutlet weak var manufacturerComboBox: NSComboBox!
    @IBOutlet weak var generationComboBox: NSComboBox!
    @IBOutlet weak var image: NSImageView!
    @IBOutlet weak var clearButton: NSButton!
    
    //platformView items
    @IBOutlet weak var nameLabel: NSTextField!
    @IBOutlet weak var platformImage: NSImageView!
    @IBOutlet weak var developerLabel: NSTextField!
    @IBOutlet weak var generationLabel: NSTextField!
    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet weak var typeLabel: NSTextField!
    @IBOutlet weak var manufacturerLabel: NSTextField!
    
    var resultPath : String = String()
    var isOldPlatform : Bool = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func viewPlatform() {
        nameLabel.stringValue = selectedPlatform.name
        platformImage.image = selectedPlatform.image
        developerLabel.stringValue = selectedPlatform.developer
        generationLabel.stringValue = selectedPlatform.generation
        dateLabel.stringValue = dateToString(selectedPlatform.released)
        typeLabel.stringValue = selectedPlatform.type
        manufacturerLabel.stringValue = selectedPlatform.manufacturer
    }
    
    public func addPlatform() {
        setDate()
        clearButton.isHidden = false
        isOldPlatform = false
        
        developerComboBox.removeAllItems()
        manufacturerComboBox.removeAllItems()
        generationComboBox.removeAllItems()

        developerComboBox.addItems(withObjectValues: viewController.platformsArrayController.developersData())
        manufacturerComboBox.addItems(withObjectValues: viewController.platformsArrayController.manufacturersData())
        generationComboBox.addItems(withObjectValues: viewController.platformsArrayController.generationsData())
        
        clear(self)
    }
    
    public func setDate() {
        releaseDatePicker.dateValue = Date()
    }
    
    @IBAction func upload(_ sender: Any) {
        let dialog = NSOpenPanel();
        
        dialog.title = "Pick an image file"
        dialog.showsResizeIndicator = true
        dialog.showsHiddenFiles = false
        dialog.canChooseDirectories = true
        dialog.canCreateDirectories = true
        dialog.allowsMultipleSelection = false
        dialog.allowedFileTypes = ["jpg","png","jpeg", "tiff"]
        
        if (dialog.runModal() == NSApplication.ModalResponse.OK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                resultPath = result!.path
                let newImage = NSImage(contentsOfFile: resultPath)
                newImage?.size = NSSize(width: 300, height: 150)
                image.image = newImage
            }
        }
    }
    
    public func editPlatform() {
        
        addPlatform()
        clearButton.isHidden = true
        isOldPlatform = true
        
        image.image = selectedPlatform.image
        nameTextField.stringValue = selectedPlatform.name
        releaseDatePicker.dateValue = selectedPlatform.released
        
        typeComboBox.selectItem(withObjectValue: selectedPlatform.type)
        developerComboBox.selectItem(withObjectValue: selectedPlatform.developer)
        manufacturerComboBox.selectItem(withObjectValue: selectedPlatform.manufacturer)
        generationComboBox.selectItem(withObjectValue: selectedPlatform.generation)
        
    }
    
    @IBAction func done(_ sender: Any) {
        var missing : String = String()
        
        let name : String = nameTextField.stringValue.trimmingCharacters(in: .whitespaces)
        if name.isEmpty { missing += "Name\n" }
        
        if releaseDatePicker.dateValue > Date() { missing += "Valid Date\n" }
        
        let developer : String = developerComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        if developer.isEmpty { missing += "Developer\n" }
        
        let manufacturer : String = manufacturerComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        if manufacturer.isEmpty { missing += "Manufacturer\n" }
        
        let generation : String = generationComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        if generation.isEmpty { missing += "Generation\n" }
        
        if image.image?.name() == "NSUpload2" { missing += "Image" }
        
        if missing.isEmpty {
            if isOldPlatform { updatePlatform() }
            else { createNewPlatform() }
        }
        else { dialogOKCancel(question: "Platform is missing the following information:", text: missing) }
    }
    
    public func updatePlatform() {
        
        print("hit")
        if image.image?.name() == nil {
            
            try? fm.removeItem(at: url.appendingPathComponent("Images/Platforms/\(selectedPlatform.identifier)").appendingPathExtension("png"))
            
            try? fm.copyItem(atPath: resultPath, toPath: "\(path)\("/Images/Platforms/\(selectedPlatform.identifier).png")")
            
            selectedPlatform.loadPicture()
        }
        
        selectedPlatform.name = nameTextField.stringValue.trimmingCharacters(in: .whitespaces)
        selectedPlatform.released = releaseDatePicker.dateValue
        selectedPlatform.developer = developerComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        selectedPlatform.manufacturer = manufacturerComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        selectedPlatform.generation = generationComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        selectedPlatform.type = typeComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        
        viewController.platformsArrayController.necessaryUpdate()
        self.dismiss(self)
        platformEditConfirmation()
    }
    
    public func createNewPlatform() {
        // create new UUID
        let id : UUID = UUID()
        //create the image before the platform
        try? fm.copyItem(atPath: resultPath, toPath: "\(path)\("/Images/Platforms/\(id.uuidString).png")")
        
        //create the new platform
        let newPlatform : Platform = Platform(uuid: id)
        newPlatform.loadPicture()
        newPlatform.name = nameTextField.stringValue.trimmingCharacters(in: .whitespaces)
        newPlatform.released = releaseDatePicker.dateValue
        newPlatform.developer = developerComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        newPlatform.manufacturer = manufacturerComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        newPlatform.generation = generationComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        newPlatform.type = typeComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        
        self.dismiss(self)
        
        if viewController.platformsArrayController.exists(newPlatform) { platformNotAdded() }
        else {
            viewController.platformsArrayController.addPlatform(newPlatform)
            platformCreatedConfirmation(newPlatform)
        }
        
    }
    
    @IBAction func clear(_ sender: Any) {
        developerComboBox.deselectItem(at: developerComboBox.indexOfSelectedItem)
        manufacturerComboBox.deselectItem(at: manufacturerComboBox.indexOfSelectedItem)
        generationComboBox.deselectItem(at: generationComboBox.indexOfSelectedItem)
        typeComboBox.deselectItem(at: typeComboBox.indexOfSelectedItem)

        nameTextField.stringValue = String()
        nameTextField.placeholderString = String()
        image.image = NSImage(named: "NSUpload2")
        resultPath = String()
        setDate()
    }
    
    @IBAction func edit(_ sender: Any) {
        self.editPlatform()
        self.tabView.selectTabViewItem(addEdit)
        self.view.window?.title = "Editing \(selectedPlatform.name)"
    }
    
    @IBAction func delete(_ sender: Any) {
        self.dismiss(self)
        windowController.delete(self)
    }
    
}
