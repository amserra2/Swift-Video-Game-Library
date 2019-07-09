//
//  Platform.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/2/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Cocoa

public class Platform: NSObject {
    //PlayStation|September 09, 1995
//    Sony Computer Entertainment|Sony
//    Fifth|100|Console|
    
    @objc var name: String = String()
    @objc var released: Date = Date()
    @objc var developer: String = String()
    @objc var manufacturer : String = String()
    @objc var generation : String = String()
    @objc var type : String = String()

    final let identifier : UUID
    @objc var image : NSImage = NSImage()
    
    init(uuid : UUID) {
        self.identifier = uuid
        self.image.setName(identifier.uuidString)
    }
    
    public func loadPicture() {
        self.image = NSImage(contentsOf: url.appendingPathComponent("Images/Platforms/\(identifier)").appendingPathExtension("png"))!
        self.image.size = NSSize(width: 300, height: 150)
    }
    
    public func toString() -> String {
        return "\(name)|\(dateToString(released))|\(developer)|\(manufacturer)|\(generation)|\(type)|\(identifier)"
    }
    
    public func searchString() -> String {
        return "\(name.lowercased().replacingOccurrences(of: " ", with: ""))\(developer.lowercased().replacingOccurrences(of: " ", with: ""))\(manufacturer.lowercased().replacingOccurrences(of: " ", with: ""))\(dateToString(released).split(separator: " ")[2])"
    }
    
    public func downloadString(_ padding : Int) -> String {
        let a = name.padding(toLength: padding, withPad: " ", startingAt: 0)
        return "\(a) (\(dateToString(released).split(separator: " ")[2])) by \(developer)"
    }

}
