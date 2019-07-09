//
//  GamesArrayController.swift
//  test
//
//  Created by Asia Michelle Serrano on 7/2/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Cocoa

public final class GamesArrayController: NSArrayController {
    
    private var gameset : Set<Game> = []
    
    public var allGames : CategoryOptions = CategoryOptions("Game", "All Games", "All Games")
    public var titleCategory : Categories = Categories("Title", [])
    public var platformCategory : Categories = Categories("Platform", [])
    public var genreCategory : Categories = Categories("Genre", [])
    public var publisherCategory : Categories = Categories("Publisher", [])
    public var formatCategory : Categories = Categories("Format", [])
    public var modeCategory : Categories = Categories("Mode", [])
    
    public var currentSelection : CategoryOptions = CategoryOptions()
    
    public func load() {
        do {
            let content : String = try String(contentsOf: gamesFile)
            let games : [Substring] = content.split(separator: "\n")
            
            for g in games {
                let p = g.split(separator: "|")
                
                let game = Game(uuid: UUID(uuidString: String(p[8]))!)
                
                game.title = String(p[0])
                game.released = stringToDate(String(p[1]))
                game.platform = String(p[5])
                game.format = String(p[7])
                game.setMode(String(p[6]))
                game.publisher = String(p[2])
                game.developer = String(p[3])
                game.genre = String(p[4])
                game.loadPicture()
                gameset.insert(game)
                
            }
            
            sourceListUpdate()
            currentSelection = allGames
            selection(currentSelection)
            
        }
        catch {
            try? String().write(to: gamesFile, atomically: true, encoding: String.Encoding.utf8)
        }
    }
    
    public func save() {
        try? toString().write(to: gamesFile, atomically: true, encoding: String.Encoding.utf8)
    }
    
    public func search(_ search : String) {
        
        let subs = search.lowercased().split(separator: " ")
        var arr : Array<Game> = []
        
        for game in gameset {
            for string in subs {
                if game.searchString().contains(string) {
                    arr.append(game)
                    break
                }
            }
        }
        
        setContent(arr)
        currentSelection = allGames
    }
    
    public func sourceListUpdate() {
        sourceListTitles()
        sourceListPlatforms()
        sourceListGenres()
        sourceListPublishers()
        sourceListFormats()
        sourceListModes()
    }
    
    public func setContent(_ content : Array<Game>) {
        self.content = content
    }
    
    public func selection(_ selection : CategoryOptions) {
        
        currentSelection = selection
        
        switch selection.property {
        case "All Games":
            setContent(Array(gameset).sorted(by: { $0.title < $1.title }))
        case "Title":
            setContent(titles(selection.selection))
        case "Platform":
            setContent(platforms(selection.selection))
        case "Genre":
            setContent(genres(selection.selection))
        case "Publisher":
            setContent(publishers(selection.selection))
        case "Format":
            setContent(formats(selection.selection))
        case "Mode":
            setContent(modes(selection.selection))
        default:
            break
        }
        
    }
    
    public func games() -> Array<Game> {
        return self.arrangedObjects as! [Game]
    }
    
    public func publishersData() -> Array<String> {
        var arr : Set<String> = []
        for game in gameset { arr.insert(game.publisher) }
        return Array(arr).sorted()
    }
    
    public func developersData() -> Array<String> {
        var arr : Set<String> = []
        for game in gameset { arr.insert(game.developer) }
        return Array(arr).sorted()
    }
    
    public func platformsData() -> Array<String> {
        var arr : Set<String> = []
        for game in gameset { arr.insert(game.platform) }
        return Array(arr).sorted()
    }
    
    public func genresData() -> Array<String> {
        var arr : Set<String> = []
        for game in gameset { arr.insert(game.genre) }
        return Array(arr).sorted()
    }
    
    public func titles(_ selection : String) -> Array<Game> {
        var arr : Array<Game> = []
        for game in gameset { if game.title.prefix(1).uppercased() == selection { arr.append(game) } }
        return arr
    }
    
    public func platforms(_ selection : String) -> Array<Game> {
        var arr : Array<Game> = []
        for game in gameset { if game.platform == selection { arr.append(game) } }
        return arr
    }
    
    public func genres(_ selection : String) -> Array<Game> {
        var arr : Array<Game> = []
        for game in gameset { if game.genre == selection { arr.append(game) } }
        return arr
    }
    
    public func publishers(_ selection : String) -> Array<Game> {
        var arr : Array<Game> = []
        for game in gameset { if game.publisher == selection { arr.append(game) } }
        return arr
    }
    
    public func formats(_ selection : String) -> Array<Game> {
        var arr : Array<Game> = []
        for game in gameset { if game.format == selection { arr.append(game) } }
        return arr
    }
    
    public func modes(_ selection : String) -> Array<Game> {
        var arr : Array<Game> = []
        for game in gameset { if game.modeCheck(selection) { arr.append(game) } }
        return arr
    }
    
    public func convert(_ array : Array<String>, _ category : String, _ property: String) -> Array<CategoryOptions> {
        var arr : Array<CategoryOptions> = []
        
        for game in array { arr.append(CategoryOptions(category, property, game)) }
        return arr
    }
    
    public func sourceListTitles() {
        var values : Array<String> = (gameset.map({ (game: Game) -> String in game.title.prefix(1).uppercased() })).sorted()
        values.removeDuplicates()
        titleCategory.options = convert(values, "Game", "Title")
    }
    
    public func sourceListPlatforms() {
        var values : Array<String> = (gameset.map({ (game: Game) -> String in game.platform })).sorted()
        values.removeDuplicates()
        platformCategory.options = convert(values, "Game", "Platform")
    }
    
    public func sourceListGenres() {
        var values : Array<String> = (gameset.map({ (game: Game) -> String in game.genre })).sorted()
        values.removeDuplicates()
        genreCategory.options = convert(values, "Game", "Genre")
    }
    
    public func sourceListPublishers() {
        var values : Array<String> = (gameset.map({ (game: Game) -> String in game.publisher })).sorted()
        values.removeDuplicates()
        publisherCategory.options = convert(values, "Game", "Publisher")
    }
    
    public func sourceListFormats() {
        var values : Array<String> = (gameset.map({ (game: Game) -> String in game.format })).sorted()
        values.removeDuplicates()
        formatCategory.options = convert(values, "Game", "Format")
    }
    
    public func sourceListModes() {
        var values : Array<String> = (gameset.map({ (game: Game) -> String in game.getMode() })).sorted()
        values.removeDuplicates()
        if values.contains("Both") { modeCategory.options = convert(["Single-Player", "Multiplayer"], "Game", "Mode") }
        else { modeCategory.options = convert(values, "Game", "Mode") }
    }
    
    public func count() -> Int {
        return gameset.count
    }
    
    public func toString() -> String {
        var content : String = String()
        for game in gameset {
            content += "\(game.toString())\n"
        }
        return content
    }
    
    public func addGame(_ game : Game) {
        gameset.insert(game)
        necessaryUpdate()
    }
    
    public func removeGame() {
        gameset.remove(selectedGame)
        try? fm.removeItem(at: url.appendingPathComponent("Images/Games/\(selectedGame.identifier)").appendingPathExtension("png"))
        necessaryUpdate()
    }
    
    public func downloadString() -> String {
        var content : String = String()
        let padding = longest()
        for game in Array(gameset).sorted(by: { $0.title < $1.title }) {
            content += "\(game.downloadString(padding))\n"
        }
        return content
    }
    
    public func necessaryUpdate() {
        self.sourceListUpdate()
        sourceListViewController.sourceList.reloadData()
        selection(currentSelection)
        viewController.deselectAll()
        windowController.searchBar.clear()
    }
    
    public func longest() -> Int {
        let max = gameset.max(by: {$1.title.count > $0.title.count})
        return max?.title.count ?? 0
    }

}
