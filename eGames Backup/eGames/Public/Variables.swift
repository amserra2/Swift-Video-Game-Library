//
//  Variables.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/2/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Foundation
import Cocoa

public let fm : FileManager = FileManager.default
public let df = dateFormatter()
public let url = try! fm.url(for:.documentDirectory, in:.userDomainMask, appropriateFor:nil, create:true)
public let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
public let storyBoard = NSStoryboard(name: "Main", bundle: nil) as NSStoryboard

public let appDelegate = NSApplication.shared.delegate as! AppDelegate

public let wishlistFile = url.appendingPathComponent("Files/wishlist").appendingPathExtension("txt")
public let gamesFile = url.appendingPathComponent("Files/videogames").appendingPathExtension("txt")
public let platformsFile = url.appendingPathComponent("Files/platforms").appendingPathExtension("txt")
public let downloadFile = url.appendingPathComponent("Files/download").appendingPathExtension("txt")

public let splitViewController : NSSplitViewController = loadSplitViewController()
public let viewController : ViewController = loadViewController()
public let sourceListViewController : SourceListViewController = loadSourceList()
public let windowController : WindowController = loadWindowController()

public let gameViewController : GameViewController = loadGameViewController()
public let platformViewConroller : PlatformViewController = loadPlatformViewController()
public let wishlistItemViewController : WishlistItemViewController = loadWishlistItemViewController()

public let statsViewController : StatsViewController = loadStatsViewController()
public let downloadViewController : DownloadViewController = loadDownloadViewController()

public let blankGame = Game(uuid: UUID(uuidString: "AD630589-D13E-42C4-B154-D162317AC04A")!)
public let blankPlatform = Platform(uuid: UUID(uuidString: "AD630589-D13E-42C4-B154-D162317AC04B")!)
public let blankWishlistItem = WishlistItem()

public var selectedGame : Game = blankGame
public var selectedPlatform : Platform = blankPlatform
public var selectedItem : WishlistItem = blankWishlistItem


