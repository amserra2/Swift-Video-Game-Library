//
//  Game.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/2/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Cocoa

public class Game: NSObject {

    @objc var title: String = String()
    @objc var released: Date = Date()
    @objc var platform: String = String()
    @objc var format : String = String()
    @objc var publisher : String = String()
    @objc var developer : String = String()
    @objc var genre : String = String()
    
    
    private var mode : String = String()
    @objc var modeImage : NSImage = NSImage()
    
    final let identifier : UUID
    @objc var image : NSImage = NSImage()
    
    init(uuid : UUID) {
        self.identifier = uuid
        self.image.setName(identifier.uuidString)
    }
    
    public func loadPicture() {
        self.image = NSImage(contentsOf: url.appendingPathComponent("Images/Games/\(identifier)").appendingPathExtension("png"))!
        self.image.size = NSSize(width: 180, height: 255)
    }
    
    public func setMode(_ sender : String) {
        self.mode = sender
        self.modeImage = NSImage(named: mode)!
    }
    
    public func getMode() -> String {
        return self.mode
    }
    
    public func toString() -> String {
        return "\(title)|\(dateToString(released))|\(publisher)|\(developer)|\(genre)|\(platform)|\(mode)|\(format)|\(identifier)"
    }
    
    public func modeCheck(_ selection : String) -> Bool {
        if self.mode == "Both" { return true }
        else { return self.mode == selection }
    }
    
    public func searchString() -> String {
        return "\(title.lowercased().replacingOccurrences(of: " ", with: ""))\(publisher.lowercased().replacingOccurrences(of: " ", with: ""))\(platform.lowercased().replacingOccurrences(of: " ", with: ""))\(developer.lowercased().replacingOccurrences(of: " ", with: ""))\(genre.lowercased().replacingOccurrences(of: " ", with: ""))\(dateToString(released).split(separator: " ")[2])"
    }
    
    public func downloadString(_ padding : Int) -> String {
        let a = title.padding(toLength: padding, withPad: " ", startingAt: 0)
        return "\(a) (\(dateToString(released).split(separator: " ")[2])) for \(platform)"
    }
    
}
