//
//  ViewController.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/2/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Cocoa

public class ViewController: NSViewController, NSTableViewDelegate {

    @IBOutlet var gamesArrayController: GamesArrayController!
    @IBOutlet var platformsArrayController: PlatformsArrayController!
    @IBOutlet var wishlistArrayController: WishlistArrayController!
    
    @IBOutlet weak var tabView: NSTabView!
    @IBOutlet weak var gameTable: NSTabViewItem!
    @IBOutlet weak var platformTable: NSTabViewItem!
    @IBOutlet weak var wishlists: NSTabViewItem!
    
    
    @IBOutlet weak var gameTableView: NSTableView!
    @IBOutlet weak var platformTableView: NSTableView!
    @IBOutlet weak var wishlistTableView: NSTableView!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        loadArrayControllers()
        tableViewActions()
        delegate()
        deselectAll()
    }
    
    public func delegate() {
        gameTableView.delegate = self
        platformTableView.delegate = self
        wishlistTableView.delegate = self
    }
    
    public func isSelected() -> Bool {
        if gameTableView.selectedRow > -1 { return true }
        else if platformTableView.selectedRow > -1 { return true }
        else if wishlistTableView.selectedRow > -1 { return true }
        else { return false }
    }
    
    public func tableViewActions() {
        gameTableView.doubleAction = #selector(gameDoubleClicked)
        platformTableView.doubleAction = #selector(platformDoubleClicked)
        wishlistTableView.doubleAction = #selector(itemDoubleClicked)
    }

    @objc public func gameDoubleClicked(_ sender : Any) {
        
        let index : Int
        if sender as? AppDelegate != nil { index = gameTableView.selectedRow }
        else { index = gameTableView.clickedRow }
        
        if index > -1 {
            selectedGame = viewController.gamesArrayController.games()[index]
            gameViewController.viewGame()
            gameViewController.tabView.selectTabViewItem(gameViewController.gameView)
            
            self.presentAsModalWindow(gameViewController)
            gameViewController.view.window?.title = selectedGame.title
            gameViewController.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
        }
    
    }
    
    @objc public func platformDoubleClicked(_ sender : Any) {
        
        let index : Int
        if sender as? AppDelegate != nil { index = platformTableView.selectedRow }
        else { index = platformTableView.clickedRow }
        
        if index > -1 {
            selectedPlatform = viewController.platformsArrayController.platforms()[index]
            platformViewConroller.viewPlatform()
            platformViewConroller.tabView.selectTabViewItem(platformViewConroller.platformView)
            
            self.presentAsModalWindow(platformViewConroller)
            platformViewConroller.view.window?.title = selectedPlatform.name
            platformViewConroller.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
        }
    }
    
    @objc public func itemDoubleClicked(_ sender : Any) {
        
        let index : Int
        if sender as? AppDelegate != nil { index = wishlistTableView.selectedRow }
        else { index = wishlistTableView.clickedRow }

        
        if index > -1 {
            selectedItem = viewController.wishlistArrayController.items()[index]
            wishlistItemViewController.viewItem()
            wishlistItemViewController.tabView.selectTabViewItem(wishlistItemViewController.itemView)
            
            self.presentAsModalWindow(wishlistItemViewController)
            wishlistItemViewController.view.window?.title = selectedItem.tag
            wishlistItemViewController.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
        }
    }
    
    private func loadArrayControllers() {
        gamesArrayController.load()
        platformsArrayController.load()
        wishlistArrayController.load()
    }
    
    public func deselectAll() {
        gameTableView.deselectAll(self)
        platformTableView.deselectAll(self)
        wishlistTableView.deselectAll(self)
    }
    
    public func tableViewSelectionDidChange(_ notification: Notification) {
        let bool : Bool = isSelected()
        appDelegate.editItem.isEnabled = bool
        appDelegate.deleteItem.isEnabled = bool
        appDelegate.viewItem.isEnabled = bool
    }

}
