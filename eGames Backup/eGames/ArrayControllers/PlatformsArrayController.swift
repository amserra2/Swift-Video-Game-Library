//
//  PlatformsArrayController.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/4/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Cocoa

class PlatformsArrayController: NSArrayController {
    
    private var platformset : Set<Platform> = []
    
    public var allPlatforms : CategoryOptions = CategoryOptions("Platform", "All Platforms", "All Platforms")
    public var developerCategory : Categories = Categories("Developer", [])
    public var generationCategory : Categories = Categories("Generation", [])
    public var typeCategory : Categories = Categories("Type", [])
    
    public var currentSelection : CategoryOptions = CategoryOptions()
    
    public func load() {
        do {
            let content : String = try String(contentsOf: platformsFile)
            let platforms : [Substring] = content.split(separator: "\n")
            
            for pl in platforms {
                let p = pl.split(separator: "|")
                
                let platform = Platform(uuid: UUID(uuidString: String(p[6]))!)
                
                platform.name = String(p[0])
                platform.released = stringToDate(String(p[1]))
                platform.developer = String(p[2])
                platform.manufacturer = String(p[3])
                platform.generation = String(p[4])
                platform.type = String(p[5])
                platform.loadPicture()
                platformset.insert(platform)
                
            }
            
            sourceListUpdate()
            currentSelection = allPlatforms
            selection(currentSelection)
            
        }
        catch {
            try? String().write(to: platformsFile, atomically: true, encoding: String.Encoding.utf8)
        }
    }
    
    public func save() {
        try? toString().write(to: platformsFile, atomically: true, encoding: String.Encoding.utf8)
    }
    
    public func search(_ search : String) {
        
        let subs = search.lowercased().split(separator: " ")
        var arr : Array<Platform> = []
        
        for platform in platformset {
            for string in subs {
                if platform.searchString().contains(string) {
                    arr.append(platform)
                    break
                }
            }
        }
        
        setContent(arr)
        currentSelection = allPlatforms
    }
    
    public func platforms() -> Array<Platform> {
        return self.arrangedObjects as! [Platform]
    }
    
    public func setContent(_ content : Array<Platform>) {
        self.content = content
    }
    
    public func sourceListUpdate() {
        sourceListDevelopers()
        sourceListGenerations()
        sourceListTypes()
    }
    
    public func selection(_ selection : CategoryOptions) {
        
        currentSelection = selection
        
        switch selection.property {
        case "All Platforms":
            setContent(Array(platformset))
        case "Developer":
            setContent(developers(selection.selection))
        case "Generation":
            setContent(generations(selection.selection))
        case "Type":
            setContent(types(selection.selection))
        default:
            break
        }
        
    }
    
    public func developersData() -> Array<String> {
        var arr : Set<String> = []
        for platform in platformset { arr.insert(platform.developer) }
        return Array(arr).sorted()
    }
    
    public func manufacturersData() -> Array<String> {
        var arr : Set<String> = []
        for platform in platformset { arr.insert(platform.manufacturer) }
        return Array(arr).sorted()
    }
    
    public func generationsData() -> Array<String> {
        var arr : Set<String> = []
        for platform in platformset { arr.insert(platform.generation) }
        return Array(arr).sorted()
    }
    
    public func developers(_ selection : String) -> Array<Platform> {
        var arr : Array<Platform> = []
        for platform in platformset { if platform.developer == selection { arr.append(platform) } }
        return arr
    }
    
    public func generations(_ selection : String) -> Array<Platform> {
        var arr : Array<Platform> = []
        for platform in platformset { if platform.generation == selection { arr.append(platform) } }
        return arr
    }
    
    public func types(_ selection : String) -> Array<Platform> {
        var arr : Array<Platform> = []
        for platform in platformset { if platform.type == selection { arr.append(platform) } }
        return arr
    }
    
    public func convert(_ array : Array<String>, _ category : String, _ property: String) -> Array<CategoryOptions> {
        var arr : Array<CategoryOptions> = []
        
        for platform in array { arr.append(CategoryOptions(category, property, platform)) }
        return arr
    }
    
    public func sourceListDevelopers() {
        var values : Array<String> = (platformset.map({ (platform: Platform) -> String in platform.developer})).sorted()
        values.removeDuplicates()
        developerCategory.options = convert(values, "Platform", "Developer")
    }
    
    public func sourceListGenerations() {
        var values : Array<String> = (platformset.map({ (platform: Platform) -> String in platform.generation})).sorted()
        values.removeDuplicates()
        generationCategory.options = convert(values, "Platform", "Generation")
    }
    
    public func sourceListTypes() {
        var values : Array<String> = (platformset.map({ (platform: Platform) -> String in platform.type})).sorted()
        values.removeDuplicates()
        typeCategory.options = convert(values, "Platform", "Type")
    }
    
    public func toString() -> String {
        var content : String = String()
        for platform in platformset {
            content += "\(platform.toString())\n"
        }
        return content
    }
    
    public func downloadString() -> String {
        var content : String = String()
        let padding = longest()
        for platform in Array(platformset).sorted(by: { $0.name < $1.name }) {
            content += "\(platform.downloadString(padding))\n"
        }
        return content
    }
    
    public func addPlatform(_ platform : Platform) {
        platformset.insert(platform)
        necessaryUpdate()
    }
    
    public func count() -> Int {
        return platformset.count
    }
    
    public func removePlatform() {
        platformset.remove(selectedPlatform)
        try? fm.removeItem(at: url.appendingPathComponent("Images/Platforms/\(selectedPlatform.identifier)").appendingPathExtension("png"))
        necessaryUpdate()
    }
    
    public func necessaryUpdate() {
        self.sourceListUpdate()
        sourceListViewController.sourceList.reloadData()
        selection(currentSelection)
        viewController.deselectAll()
        windowController.searchBar.clear()
    }
    
    public func longest() -> Int {
        let max = platformset.max(by: {$1.name.count > $0.name.count})
        return max?.name.count ?? 0
    }

}
