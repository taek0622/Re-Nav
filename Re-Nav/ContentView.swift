//
//  ContentView.swift
//  Re-Nav
//
//  Created by 김민택 on 11/16/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem { Label("지도", systemImage: "map") }
            PinListView()
                .tabItem { Label("목록", systemImage: "list.bullet") }
            SettingView()
                .tabItem { Label("설정", systemImage: "gearshape") }
        }
    }
}

#Preview {
    ContentView()
}
