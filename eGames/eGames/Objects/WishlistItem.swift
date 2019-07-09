//
//  WishlistItem.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/4/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Cocoa

public class WishlistItem: NSObject {
    @objc var tag : String = String()
    @objc var releaseYear : Int = Int()
    @objc var dateAdded: Date = Date()
    @objc var estimatedPrice: Double = Double()
    @objc var image : NSImage = NSImage()
    @objc var type : String = String()
    
    public func toString() -> String {
        return "\(tag)|\(releaseYear)|\(dateToString(dateAdded))|\(estimatedPrice)|\(type)"
    }
    
    public func searchString() -> String {
        return "\(releaseYear)\(tag.lowercased().replacingOccurrences(of: " ", with: ""))"
    }
    
    public func formatted(_ padding : Int) -> String {
        let a = tag.padding(toLength: padding, withPad: " ", startingAt: 0)
        return "\(a) (\(releaseYear))"
    }
    
    public func unformatted() -> String {
        return "\(tag) (\(releaseYear))"
    }
}
