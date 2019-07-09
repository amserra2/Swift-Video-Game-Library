//
//  AppDelegate.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/2/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Cocoa

@NSApplicationMain
public class AppDelegate: NSObject, NSApplicationDelegate {
    
    @IBOutlet weak var viewItem: NSMenuItem!
    @IBOutlet weak var deleteItem: NSMenuItem!
    @IBOutlet public weak var editItem: NSMenuItem!
    
    
    @IBAction func view(_ sender: Any) {
        switch viewController.tabView.selectedTabViewItem {
        case viewController.gameTable:
            viewController.gameDoubleClicked(self)
        case viewController.platformTable:
            viewController.platformDoubleClicked(self)
        case viewController.wishlists:
            viewController.itemDoubleClicked(self)
        default:
            break
        }
    }
    
    @IBAction func stats(_ sender: Any) {
        statsViewController.update()
        viewController.presentAsModalWindow(statsViewController)
        statsViewController.view.window?.title = "Statistics"
        statsViewController.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
    }
    
    
    @IBAction func add(_ sender: Any) {
        windowController.add(self)
    }
    
    @IBAction func edit(_ sender: Any) {
        windowController.edit(self)
    }
    
    @IBAction func delete(_ sender: Any) {
        windowController.delete(self)
    }
    
    @IBAction func save(_ sender: Any) {
        eGames.save()
    }
    
    public func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
    
    public func applicationDidFinishLaunching(_ aNotification: Notification) {
        createDirectories()
        loadViews()
    }

    public func applicationWillTerminate(_ aNotification: Notification) {
        save(self)
    }
    
    @IBAction public func download(_ sender : Any) {
        downloadViewController.clear()
        viewController.presentAsModalWindow(downloadViewController)
        downloadViewController.view.window?.title = "Download"
        downloadViewController.view.window?.styleMask.remove(NSWindow.StyleMask.resizable)
    }
    
}
