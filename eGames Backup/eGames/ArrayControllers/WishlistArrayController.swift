//
//  WishlistArrayController.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/4/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Cocoa

class WishlistArrayController: NSArrayController {

    private var gameset : Set<WishlistItem> = []
    private var platformset : Set<WishlistItem> = []
        
    public var gameWishlist : CategoryOptions = CategoryOptions("Wishlist", "Wishlist", "Games")
    public var platformWishlist : CategoryOptions = CategoryOptions("Wishlist", "Wishlist","Platforms")
    
    public var currentContent : String = String()
        
    public func load() {
        do {
            let content : String = try String(contentsOf: wishlistFile)
            let wishlistItems : [Substring] = content.split(separator: "\n")
            
            for item in wishlistItems {
                let p = item.split(separator: "|")
                
                let wishlistItem = WishlistItem()
                
                wishlistItem.tag = String(p[0])
                wishlistItem.releaseYear = Int(p[1])!
                wishlistItem.dateAdded = stringToDate(String(p[2]))
                wishlistItem.estimatedPrice = Double(p[3])!
                wishlistItem.type = String(p[4])
                
                switch wishlistItem.type {
                case "Game":
                    wishlistItem.image = NSImage(named: "Game")!
                    gameset.insert(wishlistItem)
                case "Platform":
                    wishlistItem.image = NSImage(named: "Platform")!
                    platformset.insert(wishlistItem)
                default:
                    continue
                }
            }
            
        }
        catch {
            save()
        }
    }
    
    public func search(_ search : String) {
        
        let subs = search.lowercased().split(separator: " ")
        var arr : Array<WishlistItem> = []
        
        for item in platformset.union(gameset) {
            for string in subs {
                if item.searchString().contains(string) {
                    arr.append(item)
                    break
                }
            }
        }
        
        self.content = arr
    }
    
    public func searchClear() {
        if currentContent == "Games" { self.content = gameset }
        else { self.content = platformset }
    }
    
    public func save() {
        try? toString().write(to: wishlistFile, atomically: true, encoding: String.Encoding.utf8)
    }
    
    public func items() -> Array<WishlistItem> {
        return self.arrangedObjects as! [WishlistItem]
    }
    
    public func selection(_ content : CategoryOptions) {
        if content.selection == "Games" { self.content = gameset }
        else { self.content = platformset }
        currentContent = content.selection
    }
    
    public func toString() -> String {
        var content : String = String()
        for item in platformset.union(gameset) {
            content += "\(item.toString())\n"
        }
        return content
    }
    
    public func downloadStringG() -> String {
        var content : String = String()
        let padding = longestG()
        for item in Array(gameset).sorted(by: { $0.tag < $1.tag }) {
            content += "\(item.downloadString(padding))\n"
        }
        return content
    }
    
    public func downloadStringP() -> String {
        var content : String = String()
        let padding = longestP()
        for item in Array(platformset).sorted(by: { $0.tag < $1.tag }) {
            content += "\(item.downloadString(padding))\n"
        }
        return content
    }
    
    public func swapItem() {
        if selectedItem.type == "Game" {
            gameset.remove(selectedItem)
            platformset.insert(selectedItem)
            selectedItem.type = "Platform"
            selectedItem.image = NSImage(named: "Platform")!
        }
        else {
            platformset.remove(selectedItem)
            gameset.insert(selectedItem)
            selectedItem.type = "Game"
            selectedItem.image = NSImage(named: "Game")!
        }
    }
    
    public func addItem(_ item : WishlistItem) {
        switch item.type {
        case "Game":
            gameset.insert(item)
        case "Platform":
            platformset.insert(item)
        default:
            break
        }
        
        necessaryUpdate(item.type)
        viewController.deselectAll()
    }
    
    public func removeItem() {
        switch selectedItem.type {
        case "Game":
            gameset.remove(selectedItem)
        case "Platform":
            platformset.remove(selectedItem)
        default:
            break
        }
        
        necessaryUpdate(selectedItem.type)
        viewController.deselectAll()
    }
    
    public func count() -> [Int] {
        return [gameset.count, platformset.count]
    }
    
    public func necessaryUpdate(_ type : String) {
        if type == "Game" { selection(gameWishlist) }
        else { selection(platformWishlist) }
        windowController.searchBar.clear()
    }
    
    public func longestG() -> Int {
        let max = gameset.max(by: {$1.tag.count > $0.tag.count})
        return max?.tag.count ?? 0
    }
    
    public func longestP() -> Int {
        let max = platformset.max(by: {$1.tag.count > $0.tag.count})
        return max?.tag.count ?? 0
    }
}
