//
//  Address.swift
//  Re-Nav
//
//  Created by 김민택 on 11/19/23.
//

import Foundation
import SwiftData

@Model
final class Address {
    var fullAddress: String
    var depth1: String
    var depth2: String
    var depth3: String
    var mainNo: String
    var subNo: String

    init(fullAddress: String, depth1: String, depth2: String, depth3: String, mainNo: String, subNo: String) {
        self.fullAddress = fullAddress
        self.depth1 = depth1
        self.depth2 = depth2
        self.depth3 = depth3
        self.mainNo = mainNo
        self.subNo = subNo
    }
}

@Model
final class RoadAddress {
    var fullAddress: String
    var depth1: String
    var depth2: String
    var depth3: String
    var road: String
    var mainNo: String
    var subNo: String
    var buildingName: String
    var postalCode: String

    init(fullAddress: String, depth1: String, depth2: String, depth3: String, road: String, mainNo: String, subNo: String, buildingName: String, postalCode: String) {
        self.fullAddress = fullAddress
        self.depth1 = depth1
        self.depth2 = depth2
        self.depth3 = depth3
        self.road = road
        self.mainNo = mainNo
        self.subNo = subNo
        self.buildingName = buildingName
        self.postalCode = postalCode
    }
}
