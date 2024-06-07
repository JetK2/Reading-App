//
//  Item.swift
//  ReadingAppMobie
//
//  Created by Jetha Kaur on 07/06/2024.
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
