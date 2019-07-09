//
//  GameViewController.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/5/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Cocoa

public class GameViewController: NSViewController {
    
    
    @IBOutlet var tabView: NSTabView!
    @IBOutlet weak var addEdit: NSTabViewItem!
    @IBOutlet weak var gameView: NSTabViewItem!
    
    // addEdit items
    @IBOutlet weak var boxart: NSImageView!
    @IBOutlet weak var titleTextField: NSTextField!
    @IBOutlet weak var releaseDatePicker: NSDatePicker!
    
    @IBOutlet weak var singleplayer: NSButton!
    @IBOutlet weak var multiplayer: NSButton!
    
    @IBOutlet weak var formatSegmentedControl: NSSegmentedControl!
    
    @IBOutlet weak var publisherComboBox: NSComboBox!
    @IBOutlet weak var developerComboBox: NSComboBox!
    @IBOutlet weak var platformComboBox: NSComboBox!
    @IBOutlet weak var genreComboBox: NSComboBox!
    
    @IBOutlet weak var uploadButton: NSButton!
    @IBOutlet weak var doneButton: NSButton!
    @IBOutlet weak var clearButton: NSButton!
    
    var resultPath : String = String()
    //var resultURL : URL = URL()
    
    var isOldGame : Bool = false
    
    //gameView items
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var publisherLabel: NSTextField!
    @IBOutlet weak var platformLabel: NSTextField!
    @IBOutlet weak var formatLabel: NSTextField!
    @IBOutlet weak var formatImage: NSImageView!
    
    @IBOutlet weak var boxartImage: NSImageView!
    
    
    @IBOutlet weak var singleStack: NSStackView!
    @IBOutlet weak var multiStack: NSStackView!
    
    @IBOutlet weak var releaseLabel: NSTextField!
    @IBOutlet weak var developerLabel: NSTextField!
    @IBOutlet weak var genreLabel: NSTextField!
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func viewGame() {
        titleLabel.stringValue = selectedGame.title
        publisherLabel.stringValue = selectedGame.publisher
        platformLabel.stringValue = selectedGame.platform
        formatLabel.stringValue = selectedGame.format
        formatImage.image = NSImage(named: selectedGame.format)
        boxartImage.image = selectedGame.image
        
        switch selectedGame.getMode() {
        case "Both":
            singleStack.isHidden = false
            multiStack.isHidden = false
        case "Single-Player":
            singleStack.isHidden = false
            multiStack.isHidden = true
        case "Multiplayer":
            singleStack.isHidden = true
            multiStack.isHidden = false
        default:
            break
        }
        
        releaseLabel.stringValue = dateToString(selectedGame.released)
        developerLabel.stringValue = selectedGame.developer
        genreLabel.stringValue = selectedGame.genre
    }

    public func addGame() {
        setDate()
        clearButton.isHidden = false
        isOldGame = false

        publisherComboBox.removeAllItems()
        developerComboBox.removeAllItems()
        platformComboBox.removeAllItems()
        genreComboBox.removeAllItems()

        publisherComboBox.addItems(withObjectValues: viewController.gamesArrayController.publishersData())
        platformComboBox.addItems(withObjectValues: viewController.gamesArrayController.platformsData())
        developerComboBox.addItems(withObjectValues: viewController.gamesArrayController.developersData())
        genreComboBox.addItems(withObjectValues: viewController.gamesArrayController.genresData())

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
                //resultURL = result!
                let newImage = NSImage(contentsOfFile: resultPath)
                newImage?.size = NSSize(width: 180, height: 255)
                boxart.image = newImage
            }
        }
    }

    @IBAction func done(_ sender: Any) {
        var missing : String = String()

        let title : String = titleTextField.stringValue.trimmingCharacters(in: .whitespaces)
        if title.isEmpty { missing += "Title\n" }

        if releaseDatePicker.dateValue > Date() { missing += "Valid Date\n" }
        if singleplayer.state == .off && multiplayer.state == .off { missing += "Mode(s)\n" }

        let publisher : String = publisherComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        if publisher.isEmpty { missing += "Publisher\n" }

        let developer : String = developerComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        if developer.isEmpty { missing += "Developer\n" }

        let platform : String = platformComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        if platform.isEmpty { missing += "Platform\n" }

        let genre : String = genreComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        if genre.isEmpty { missing += "Genre\n" }

        if boxart.image?.name() == "NSUpload" { missing += "Boxart" }

        if missing.isEmpty {
            if isOldGame { updateGame() }
            else { createNewGame() }
        }
        else { dialogOKCancel(question: "Game is missing the following information:", text: missing) }
    }
    
    public func updateGame() {
                
        if boxart.image?.name() == nil {

            try? fm.removeItem(at: url.appendingPathComponent("Images/Games/\(selectedGame.identifier)").appendingPathExtension("png"))

            try? fm.copyItem(atPath: resultPath, toPath: "\(path)\("/Images/Games/\(selectedGame.identifier).png")")

            selectedGame.loadPicture()
        }
        
        selectedGame.title = titleTextField.stringValue.trimmingCharacters(in: .whitespaces)
        selectedGame.released = releaseDatePicker.dateValue
        selectedGame.platform = platformComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        if formatSegmentedControl.selectedSegment == 0 { selectedGame.format = "Physical" }
        else { selectedGame.format = "Digital" }

        if singleplayer.state == .on && multiplayer.state == .on { selectedGame.setMode("Both") }
        else if singleplayer.state == .on { selectedGame.setMode("Single-Player") }
        else { selectedGame.setMode("Multiplayer") }
        selectedGame.publisher = publisherComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        selectedGame.developer = developerComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        selectedGame.genre = genreComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        
        viewController.gamesArrayController.necessaryUpdate()
        self.dismiss(self)
        gameEditConfirmation()
    }

    public func createNewGame() {

        // create new UUID
        let id : UUID = UUID()
        //create the image before the game
        try? fm.copyItem(atPath: resultPath, toPath: "\(path)\("/Images/Games/\(id.uuidString).png")")

        //create the new game
        let newGame : Game = Game(uuid: id)
        newGame.loadPicture()
        newGame.title = titleTextField.stringValue.trimmingCharacters(in: .whitespaces)
        newGame.released = releaseDatePicker.dateValue
        newGame.platform = platformComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        if formatSegmentedControl.selectedSegment == 0 { newGame.format = "Physical" }
        else { newGame.format = "Digital" }

        if singleplayer.state == .on && multiplayer.state == .on { newGame.setMode("Both") }
        else if singleplayer.state == .on { newGame.setMode("Single-Player") }
        else { newGame.setMode("Multiplayer") }
        newGame.publisher = publisherComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        newGame.developer = developerComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        newGame.genre = genreComboBox.stringValue.trimmingCharacters(in: .whitespaces)
        
        self.dismiss(self)
        
        if viewController.gamesArrayController.exists(newGame) { gameNotAdded() }
        else {
            viewController.gamesArrayController.addGame(newGame)
            gameCreatedConfirmation(newGame)
        }

        
    }

    public func editGame() {

        addGame()
        clearButton.isHidden = true
        isOldGame = true

        boxart.image = selectedGame.image
        titleTextField.stringValue = selectedGame.title
        releaseDatePicker.dateValue = selectedGame.released

        if selectedGame.modeImage.name() == "Single-Player" { singleplayer.state = .on }
        else if selectedGame.modeImage.name() == "Multiplayer" { multiplayer.state = .on }
        else {
            singleplayer.state = .on
            multiplayer.state = .on
        }

        if selectedGame.format == "Physical" { formatSegmentedControl.selectedSegment = 0 }
        else { formatSegmentedControl.selectedSegment = 1 }

        publisherComboBox.selectItem(withObjectValue: selectedGame.publisher)
        developerComboBox.selectItem(withObjectValue: selectedGame.developer)
        platformComboBox.selectItem(withObjectValue: selectedGame.platform)
        genreComboBox.selectItem(withObjectValue: selectedGame.genre)
    }

    @IBAction func clear(_ sender: Any) {
        publisherComboBox.deselectItem(at: publisherComboBox.indexOfSelectedItem)
        developerComboBox.deselectItem(at: developerComboBox.indexOfSelectedItem)
        platformComboBox.deselectItem(at: platformComboBox.indexOfSelectedItem)
        genreComboBox.deselectItem(at: genreComboBox.indexOfSelectedItem)
        formatSegmentedControl.selectedSegment = 0
        singleplayer.state = .off
        multiplayer.state = .off
        titleTextField.stringValue = String()
        titleTextField.placeholderString = String()
        boxart.image = NSImage(named: "NSUpload")
        resultPath = String()
        setDate()

    }
    
    @IBAction func edit(_ sender: Any) {
        self.editGame()
        self.tabView.selectTabViewItem(addEdit)
        self.view.window?.title = "Editing \(selectedGame.title)"
    }
    
    @IBAction func delete(_ sender: Any) {
        self.dismiss(self)
        windowController.delete(self)
    }
}
