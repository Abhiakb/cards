//
//  Item.swift
//  cards
//
//  Created by Akhil Gubbala on 18/09/25.
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
