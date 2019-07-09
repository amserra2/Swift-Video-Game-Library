//
//  Classes.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/2/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Foundation

public class Headers {
    final let category: String
    
    init(_ type: String) {
        self.category = type
    }
}

public class Categories {
    final let category: String
    var options: [CategoryOptions]
    
    init(_ type: String, _ things: [CategoryOptions]) {
        self.category = type
        self.options = things
    }
    
}

public class CategoryOptions {
    final let category: String // either Game, Platform, or Wishlist (ex : game)
    final let property : String //property of said category (ex: title)
    final let selection : String // the actual selection (ex: G)
    
    init(_ cat: String, _ prop: String, _ sele: String) {
        self.category = cat
        self.property = prop
        self.selection = sele
    }
    
    init() {
        self.category = String()
        self.property = String()
        self.selection = String()
    }
}
