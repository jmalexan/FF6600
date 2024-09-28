//
//  Item.swift
//  Hackery
//
//  Created by Jonathan Alexander on 9/14/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
