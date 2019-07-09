//
//  SourceList.swift
//  test
//
//  Created by Asia Michelle Serrano on 7/2/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Cocoa

class SourceList: NSOutlineView, NSOutlineViewDataSource, NSOutlineViewDelegate {
    
    var sourceList = [Any]()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        loadSourceList()
        self.dataSource = self
        self.delegate = self
        self.action = #selector(clicked)
    }
    
    @objc private func clicked() {
        
        let item = self.item(atRow: self.clickedRow)
        
        if item is CategoryOptions {
            switch (item as! CategoryOptions).category {
            case "Game":
                windowController.changeSearchFieldItem("Games")
                viewController.tabView.selectTabViewItem(viewController.gameTable)
                viewController.gamesArrayController.selection(item as! CategoryOptions)
            case "Platform":
                windowController.changeSearchFieldItem("Platforms")
                viewController.tabView.selectTabViewItem(viewController.platformTable)
                viewController.platformsArrayController.selection(item as! CategoryOptions)
            case "Wishlist":
                windowController.changeSearchFieldItem("Wishlists")
                viewController.tabView.selectTabViewItem(viewController.wishlists)
                viewController.wishlistArrayController.selection(item as! CategoryOptions)
            default:
                break
            }
            
            windowController.searchBar.clear()
            viewController.deselectAll()
        }
    }
    
    public func loadSourceList() {
        sourceList.removeAll()
        
        sourceList.append(Headers("GAMES"))
        sourceList.append(viewController.gamesArrayController.allGames)
        sourceList.append(viewController.gamesArrayController.titleCategory)
        sourceList.append(viewController.gamesArrayController.platformCategory)
        sourceList.append(viewController.gamesArrayController.genreCategory)
        sourceList.append(viewController.gamesArrayController.publisherCategory)
        sourceList.append(viewController.gamesArrayController.formatCategory)
        sourceList.append(viewController.gamesArrayController.modeCategory)
        
        sourceList.append(Headers("PLATFORMS"))
        sourceList.append(viewController.platformsArrayController.allPlatforms)
        sourceList.append(viewController.platformsArrayController.developerCategory)
        sourceList.append(viewController.platformsArrayController.generationCategory)
        sourceList.append(viewController.platformsArrayController.typeCategory)

        sourceList.append(Headers("WISHLISTS"))
        sourceList.append(viewController.wishlistArrayController.gameWishlist)
        sourceList.append(viewController.wishlistArrayController.platformWishlist)
        
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        switch item {
        case is Categories:
            return (item as! Categories).options[index]
        default:
            return sourceList[index]
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isGroupItem item: Any) -> Bool {
        
        switch item {
        case is Headers:
            return true
        default:
            return false
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        
        switch item {
        case is Categories:
            return (item as! Categories).options.count != 0
        default:
            return false
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, shouldSelectItem item: Any) -> Bool {
        
        switch item {
        case is CategoryOptions:
            return true
        default:
            return false
        }        
    }
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        switch item {
        case is Categories:
            return (item as! Categories).options.count
        default:
            return sourceList.count
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        
        let tableCell : NSTableCellView
        
        if item is Headers {
            tableCell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "HeaderCell"), owner: self) as! NSTableCellView
            tableCell.textField!.stringValue = (item as! Headers).category
        }
            
        else {
            tableCell = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "DataCell"), owner: self) as! NSTableCellView
            switch item {
            case is Categories:
                let string = (item as! Categories).category
                tableCell.textField!.stringValue = string
                switch string {
                case "Platform":
                    tableCell.imageView?.image = NSImage(named: "NSPlatform")
                case "Genre":
                    tableCell.imageView?.image = NSImage(named: "NSGenre")
                case "Title":
                    tableCell.imageView?.image = NSImage(named: "NSTitle")
                case "Publisher":
                    tableCell.imageView?.image = NSImage(named: "NSPublisher")
                case "Format":
                    tableCell.imageView?.image = NSImage(named: "NSFormat")
                case "Mode":
                    tableCell.imageView?.image = NSImage(named: "NSMode")
                case "Generation":
                    tableCell.imageView?.image = NSImage(named: "NSGeneration")
                case "Developer":
                    tableCell.imageView?.image = NSImage(named: "NSDeveloper")
                case "Type":
                    tableCell.imageView?.image = NSImage(named: "NSType")
                default:
                    break
                }
            default:
                let string = (item as! CategoryOptions).selection
                tableCell.textField!.stringValue = string
                switch string {
                case "Games", "Platforms":
                    tableCell.imageView?.image = NSImage(named: "NSWishlist")
                case "All Games", "All Platforms":
                    tableCell.imageView?.image = NSImage(named: "NSMaster")
                default:
                    tableCell.imageView?.image = NSImage(named: "NSMenuMixedStateTemplate")
                }
            }
        }
        
        tableCell.imageView?.translatesAutoresizingMaskIntoConstraints = false;
        return tableCell
    }
    
}
