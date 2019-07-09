//
//  Extensions.swift
//  eGames
//
//  Created by Asia Michelle Serrano on 7/3/19.
//  Copyright © 2019 Asia Michelle Serrano. All rights reserved.
//

import Foundation
import Cocoa

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        return filter { addedDict.updateValue(true, forKey: $0) == nil }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

extension NSSearchField {
    public func clear() {
        self.stringValue = String()
    }
}
