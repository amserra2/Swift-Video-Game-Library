//
//  WindowController.swift
//  test
//
//  Created by Asia Michelle Serrano on 7/2/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Cocoa

public class WindowController: NSWindowController, NSSearchFieldDelegate {

    @IBOutlet weak var mainWindow: NSWindow!
    @IBOutlet weak var addDeleteSegment: NSSegmentedControl!
    @IBOutlet weak var searchBar: NSSearchField!
    
    
    public let games = NSMenuItem()
    public let platforms = NSMenuItem()
    public let wishlists = NSMenuItem()
    
    override public func windowDidLoad() {
        super.windowDidLoad()
        self.showWindow(self)
        searchBar.delegate = self
    }
    
    public func controlTextDidChange(_ notification: Notification) {
        
        if searchBar.stringValue.isEmpty {
            switch searchBar.placeholderString {
            case "Games":
                viewController.gamesArrayController.selection(viewController.gamesArrayController.currentSelection)
            case "Platforms":
                viewController.platformsArrayController.selection(viewController.platformsArrayController.currentSelection)
            case "Wishlists":
                viewController.wishlistArrayController.searchClear()
            default:
                break
            }
        }
    }
    
    public func controlTextDidEndEditing(_ obj: Notification) {
        
        let string = searchBar.stringValue.trimmingCharacters(in: .whitespaces)
        
        if !string.isEmpty {
            switch searchBar.placeholderString {
            case "Games":
                viewController.gamesArrayController.search(searchBar.stringValue)
            case "Platforms":
                viewController.platformsArrayController.search(searchBar.stringValue)
            case "Wishlists":
                viewController.wishlistArrayController.search(searchBar.stringValue)
            default:
                break
            }
        }
        else { searchBar.clear() }
        
        viewController.deselectAll()
    }
    
    @objc func changeSearchFieldItem(_ sender: String) {
        searchBar.placeholderString = sender
    }
    
    @IBAction func edit(_ sender: Any) {
        switch viewController.tabView.selectedTabViewItem {
        case viewController.gameTable:
            if viewController.gameTableView.selectedRow > -1 {
                let index = viewController.gameTableView.selectedRow
                selectedGame = viewController.gamesArrayController.games()[index]
                gameViewController.editGame()
                gameViewController.tabView.selectTabViewItem(gameViewController.addEdit)
                viewController.presentAsModalWindow(gameViewController)
                gameViewController.view.window?.title = "Editing \(selectedGame.title)"
                gameViewController.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
            }
        case viewController.platformTable:
            if viewController.platformTableView.selectedRow > -1 {
                let index = viewController.platformTableView.selectedRow
                selectedPlatform = viewController.platformsArrayController.platforms()[index]
                platformViewConroller.editPlatform()
                platformViewConroller.tabView.selectTabViewItem(platformViewConroller.addEdit)
                viewController.presentAsModalWindow(platformViewConroller)
                platformViewConroller.view.window?.title = "Editing \(selectedPlatform.name)"
                platformViewConroller.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
            }
        case viewController.wishlists:
            if viewController.wishlistTableView.selectedRow > -1 {
                let index = viewController.wishlistTableView.selectedRow
                selectedItem = viewController.wishlistArrayController.items()[index]
                wishlistItemViewController.editItem()
                wishlistItemViewController.tabView.selectTabViewItem(wishlistItemViewController.addEdit)
                viewController.presentAsModalWindow(wishlistItemViewController)
                wishlistItemViewController.view.window?.title = "Editing \(selectedItem.tag)"
                wishlistItemViewController.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
            }
        default:
            break
        }
        
    }
    
    @IBAction func addDelete(_ sender: Any) {
        switch addDeleteSegment.selectedSegment {
        case 0:
            add(self)
        case 1:
            delete(self)
        default:
            break
        }        
    }
    
    public func add(_ sender: Any) {
        
        switch viewController.tabView.selectedTabViewItem {
        case viewController.gameTable:
            gameViewController.addGame()
            gameViewController.tabView.selectTabViewItem(gameViewController.addEdit)
            viewController.presentAsModalWindow(gameViewController)
            gameViewController.view.window?.title = "New Game"
            gameViewController.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
        case viewController.platformTable:
            platformViewConroller.addPlatform()
            platformViewConroller.tabView.selectTabViewItem(platformViewConroller.addEdit)
            viewController.presentAsModalWindow(platformViewConroller)
            platformViewConroller.view.window?.title = "New Platform"
            platformViewConroller.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
        case viewController.wishlists:
            wishlistItemViewController.addItem()
            wishlistItemViewController.tabView.selectTabViewItem(wishlistItemViewController.addEdit)
            viewController.presentAsModalWindow(wishlistItemViewController)
            wishlistItemViewController.view.window?.title = "New Wishlist Item"
            wishlistItemViewController.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
        default:
            break
        }
        

    }
    
    public func delete(_ sender: Any) {
        
        var game : Bool = false
        var platform : Bool = false
        var wishlist : Bool = false
        
        let deleteAlert = NSAlert()
        deleteAlert.addButton(withTitle: "Delete")
        deleteAlert.addButton(withTitle: "Cancel")
        deleteAlert.alertStyle = NSAlert.Style.warning

        if viewController.gameTableView.selectedRow > -1 {
            game = true
            selectedGame = viewController.gamesArrayController.games()[viewController.gameTableView.selectedRow]
            deleteAlert.messageText = "Delete \(selectedGame.title)?"
            deleteAlert.informativeText = "Are you sure you would like to delete \(selectedGame.title)?"
            deleteAlert.icon = selectedGame.image
        }
        
        else if viewController.platformTableView.selectedRow > -1 {
            platform = true
            selectedPlatform = viewController.platformsArrayController.platforms()[viewController.platformTableView.selectedRow]
            deleteAlert.messageText = "Delete \(selectedPlatform.name)?"
            deleteAlert.informativeText = "Are you sure you would like to delete \(selectedPlatform.name)?"
            deleteAlert.icon = selectedPlatform.image
        }
        
        else if viewController.wishlistTableView.selectedRow > -1 {
            wishlist = true
            selectedItem = viewController.wishlistArrayController.items()[viewController.wishlistTableView.selectedRow]
            deleteAlert.messageText = "Delete \(selectedItem.tag)?"
            deleteAlert.informativeText = "Are you sure you would like to delete \(selectedItem.tag)?"
            deleteAlert.icon = selectedItem.image
        }
        
        if game || platform || wishlist {
            
            deleteAlert.beginSheetModal(for: mainWindow, completionHandler: { (modalResponse) -> Void in
                if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
                    if game { viewController.gamesArrayController.removeGame() }
                    else if platform { viewController.platformsArrayController.removePlatform() }
                    else if wishlist { viewController.wishlistArrayController.removeItem() }
                }})
        }
    }
    
    public func deleteAll() {
        
        let deleteAlert = NSAlert()
        deleteAlert.addButton(withTitle: "Delete")
        deleteAlert.addButton(withTitle: "Cancel")
        deleteAlert.alertStyle = NSAlert.Style.warning
        deleteAlert.messageText = "Delete entire eGames Library?"
        deleteAlert.informativeText = "This will remove all games, platforms, and wishlist items. Are you sure?"
        
        
        deleteAlert.beginSheetModal(for: mainWindow, completionHandler: { (modalResponse) -> Void in
            if modalResponse == NSApplication.ModalResponse.alertFirstButtonReturn {
                
                viewController.gamesArrayController.deleteAll()
                viewController.platformsArrayController.deleteAll()
                viewController.wishlistArrayController.deleteAll()
                
                try? fm.removeItem(atPath: files)
                try? fm.removeItem(atPath: images)
                createDirectories()
            }})
        
        
    }
}
