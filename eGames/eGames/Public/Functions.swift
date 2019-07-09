//
//  Functions.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/2/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Foundation
import Cocoa

public func createDirectories() {
    
    do{
        try fm.createDirectory(atPath: files, withIntermediateDirectories: true, attributes: nil)
        try fm.createDirectory(atPath: images, withIntermediateDirectories: true, attributes: nil)
        try fm.createDirectory(atPath: gameImages, withIntermediateDirectories: true, attributes: nil)
        try fm.createDirectory(atPath: platformImages, withIntermediateDirectories: true, attributes: nil)
    } catch {
        exit(0)
    }
}

public func dateFormatter() -> DateFormatter {
    let newDateFormatter = DateFormatter()
    newDateFormatter.locale = Locale(identifier: "en_US")
    newDateFormatter.setLocalizedDateFormatFromTemplate("MMMMdyyyy")
    return newDateFormatter
}

public func dateToString(_ sender: Date) -> String {
    return df.string(from: sender)
}

public func stringToDate(_ sender: String) -> Date {
    return df.date(from: sender)!
}

public func loadViewController() -> ViewController {
    return splitViewController.children[1] as! ViewController
}

public func loadSourceList() -> SourceListViewController {
    return splitViewController.children[0] as! SourceListViewController
}

public func loadSplitViewController() -> NSSplitViewController {
    return windowController.contentViewController as! NSSplitViewController
}

public func loadWindowController() -> WindowController {
    return storyBoard.instantiateController(withIdentifier: "WindowController") as!  WindowController
}

public func loadGameViewController() -> GameViewController {
    return storyBoard.instantiateController(withIdentifier: "GameViewController") as!  GameViewController
}

public func loadPlatformViewController() -> PlatformViewController {
    return storyBoard.instantiateController(withIdentifier: "PlatformViewController") as!  PlatformViewController
}

public func loadWishlistItemViewController() -> WishlistItemViewController {
    return storyBoard.instantiateController(withIdentifier: "WishlistItemViewController") as! WishlistItemViewController
}

public func loadStatsViewController() -> StatsViewController {
    return storyBoard.instantiateController(withIdentifier: "StatsViewController") as!  StatsViewController
}

public func loadDownloadViewController() -> DownloadViewController {
    return storyBoard.instantiateController(withIdentifier: "DownloadViewController") as!  DownloadViewController
}

public func loadViews() {
    wishlistItemViewController.loadView()
    gameViewController.loadView()
    platformViewConroller.loadView()
    statsViewController.loadView()
    downloadViewController.loadView()
    windowController.loadWindow()
}

public func save() {
    viewController.gamesArrayController.save()
    viewController.platformsArrayController.save()
    viewController.wishlistArrayController.save()
}

public func dialogOKCancel(question: String, text: String) {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

public func downloadEmpty() {
    let alert = NSAlert()
    alert.messageText = "Download text file not created."
    alert.informativeText = "The selected item(s) are empty. Please add to your library."
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

public func gameCreatedConfirmation(_ game : Game) {
    let alert = NSAlert()
    alert.messageText = "New game successfully created!"
    alert.informativeText = "\(game.title) has been successfully added to your library."
    alert.icon = game.image
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

public func platformCreatedConfirmation(_ platform : Platform) {
    let alert = NSAlert()
    alert.messageText = "New platform successfully created!"
    alert.informativeText = "\(platform.name) has been successfully added to your library."
    alert.icon = platform.image
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

public func wishlistItemCreatedConfirmation(_ item : WishlistItem) {
    let alert = NSAlert()
    alert.messageText = "New Wishlist \(item.type) successfully created!"
    alert.informativeText = "\(item.tag) has been successfully added to your \(item.type) Wishlist."
    alert.icon = item.image
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

public func gameEditConfirmation() {
    let alert = NSAlert()
    alert.messageText = "Game successfully edited!"
    alert.informativeText = "\(selectedGame.title) has been successfully edited."
    alert.icon = selectedGame.image
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

public func platformEditConfirmation() {
    let alert = NSAlert()
    alert.messageText = "Platform successfully edited!"
    alert.informativeText = "\(selectedPlatform.name) has been successfully edited."
    alert.icon = selectedPlatform.image
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

public func itemEditConfirmation() {
    let alert = NSAlert()
    alert.messageText = "Wishlist Item successfully edited!"
    alert.informativeText = "\(selectedItem.tag) has been successfully edited."
    alert.icon = selectedItem.image
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

public func gameNotAdded() {
    let alert = NSAlert()
    alert.messageText = "Game already exsits."
    alert.informativeText = "\(selectedGame.title) is already in your library."
    alert.icon = selectedGame.image
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

public func platformNotAdded() {
    let alert = NSAlert()
    alert.messageText = "Platform already exsits."
    alert.informativeText = "\(selectedPlatform.name) is already in your library."
    alert.icon = selectedPlatform.image
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
}

public func itemNotAdded() {
    let alert = NSAlert()
    alert.messageText = "Wishlist Item already exsits."
    alert.informativeText = "\(selectedItem.tag) is already in your library."
    alert.icon = selectedItem.image
    alert.alertStyle = .warning
    alert.addButton(withTitle: "OK")
    alert.runModal()
}
