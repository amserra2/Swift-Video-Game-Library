//
//  DownloadViewController.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/7/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Cocoa

public class DownloadViewController: NSViewController {
    
    @IBOutlet weak var allButton: NSButton!
    @IBOutlet weak var gamesButton: NSButton!
    @IBOutlet weak var platformsButton: NSButton!
    @IBOutlet weak var gamesWishlistButton: NSButton!
    @IBOutlet weak var platformsWishlistButton: NSButton!
    
    @IBOutlet weak var segmentedControl: NSSegmentedControl!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }
    
    public func clear() {
        allButton.state = .off
        gamesButton.state = .off
        platformsButton.state = .off
        gamesWishlistButton.state = .off
        platformsWishlistButton.state = .off
    }
    
    @IBAction func all(_ sender: Any) {
        if allButton.state == .on {
            gamesButton.state = .on
            platformsButton.state = .on
            gamesWishlistButton.state = .on
            platformsWishlistButton.state = .on
        }
    }
    
    @IBAction func done(_ sender: Any) {
        
        if or(.on) {
            let components = Calendar.current.dateComponents(in: Calendar.current.timeZone, from: Date())
            let date = String(format: "%02d/%02d/%04d", components.month!, components.day!, components.year!)
            let time = String(format: "%02d:%02d:%02d", components.hour!, components.minute!, components.second!)
            var string : String = "eGames Library\nas of \(date) \(time) \((components.hour! < 12) ? "AM" : "PM")\n\n"
            
            if gamesButton.state == .on {
                string += "---Games---\n"
                if segmentedControl.selectedSegment == 0 {
                    string += viewController.gamesArrayController.formatted()
                }
                else { string += viewController.gamesArrayController.unformatted() }
                string += "\n"
            }
            if platformsButton.state == .on {
                string += "---Platforms---\n"
                if segmentedControl.selectedSegment == 0 {
                    string += viewController.platformsArrayController.formatted()
                }
                else { string += viewController.platformsArrayController.unformatted() }
                string += "\n"
            }
            if gamesWishlistButton.state == .on {
                string += "---Wishlist Games---\n"
                if segmentedControl.selectedSegment == 0 {
                    string += viewController.wishlistArrayController.formattedG()
                }
                else { string += viewController.wishlistArrayController.unformattedG() }
                string += "\n"
            }
            if platformsWishlistButton.state == .on {
                string += "---Wishlist Platforms---\n"
                if segmentedControl.selectedSegment == 0 {
                    string += viewController.wishlistArrayController.formattedP()
                }
                else { string += viewController.wishlistArrayController.unformattedP() }
                string += "\n"
            }
            
            self.dismiss(self)
            try? string.write(to: downloadFile, atomically: true, encoding: String.Encoding.utf8)
            NSWorkspace.shared.openFile(downloadFile.absoluteString)
        }
    }
    
    @IBAction func check(_ sender: NSButton) {
        if or(.off) { allButton.state = .off }
        else if and(.on) { allButton.state = .on }
    }
    
    private func or(_ state : NSControl.StateValue) -> Bool {
        if gamesButton.state == state || platformsButton.state == state || gamesWishlistButton.state == state || platformsWishlistButton.state == state { return true }
        return false
    }
    
    private func and(_ state : NSControl.StateValue) -> Bool {
        if gamesButton.state == state && platformsButton.state == state && gamesWishlistButton.state == state && platformsWishlistButton.state == state { return true }
        return false
    }
    
}
