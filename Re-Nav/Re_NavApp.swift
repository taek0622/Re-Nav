//
//  Re_NavApp.swift
//  Re-Nav
//
//  Created by 김민택 on 11/16/23.
//

import SwiftData
import SwiftUI

@main
struct Re_NavApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Pin.self, Theme.self, Address.self])
    }
}
