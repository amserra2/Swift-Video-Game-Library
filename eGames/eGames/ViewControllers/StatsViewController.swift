//
//  StatsViewController.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/7/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Cocoa

public class StatsViewController: NSViewController {
    
    @IBOutlet weak var games: NSTextField!
    @IBOutlet weak var platforms: NSTextField!
    @IBOutlet weak var wishlistGames: NSTextField!
    @IBOutlet weak var wishlistPlatforms: NSTextField!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func update() {
        games.stringValue = String(viewController.gamesArrayController.count())
        platforms.stringValue = String(viewController.platformsArrayController.count())
        wishlistGames.stringValue = String(viewController.wishlistArrayController.count()[0])
        wishlistPlatforms.stringValue = String(viewController.wishlistArrayController.count()[1])
    }
    
}
