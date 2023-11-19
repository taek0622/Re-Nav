//
//  Pin.swift
//  Re-Nav
//
//  Created by 김민택 on 11/19/23.
//

import Foundation
import SwiftData

@Model
final class Pin {
    var name: String
    @Relationship(deleteRule: .cascade) var address: Address
    @Relationship(deleteRule: .cascade) var roadAddress: RoadAddress
    @Relationship(deleteRule: .nullify) var theme: Theme
    var detail: String
    var photos: [Data]
    var rate: Int
    var createAt: Date
    var updateAt: Date

    init(name: String, address: Address, roadAddress: RoadAddress, theme: Theme, detail: String, photos: [Data], rate: Int, createAt: Date, updateAt: Date) {
        self.name = name
        self.address = address
        self.roadAddress = roadAddress
        self.theme = theme
        self.detail = detail
        self.photos = photos
        self.rate = rate
        self.createAt = createAt
        self.updateAt = updateAt
    }
}
