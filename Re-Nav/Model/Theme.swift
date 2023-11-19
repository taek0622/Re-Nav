//
//  Theme.swift
//  Re-Nav
//
//  Created by 김민택 on 11/19/23.
//

import Foundation
import SwiftData

@Model
final class Theme {
    @Attribute(.unique) var name: String
    @Relationship(deleteRule: .cascade) var pins: [Pin]
    var createAt: Date

    init(name: String, pins: [Pin], createAt: Date) {
        self.name = name
        self.pins = pins
        self.createAt = createAt
    }
}
