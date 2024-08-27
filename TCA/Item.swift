//
//  Item.swift
//  TCA
//
//  Created by Keith Lander on 26/08/2024.
//

import Foundation
import SwiftData

@Model
final class Item: Identifiable, CustomReflectable {    
    var timestamp: String?
    
    var customMirror: Mirror {
        Mirror(self, children: [
            "timestamp": timestamp as Any,
        ])
    }
    
    init(timestamp: Date) {
        self.timestamp = timestamp.formatted(date: .numeric, time: .standard)
    }

}
