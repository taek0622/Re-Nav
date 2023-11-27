//
//  ContentView.swift
//  Re-Nav
//
//  Created by 김민택 on 11/16/23.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var selectedTab = 1
    @State private var isShowList = false

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                MapView()
            }

            if selectedTab == 2 {
                PinListView()
                    .frame(height: UIScreen.main.bounds.height/10*3)
                    .transition(.move(edge: .bottom))
                        .animation(.easeInOut, value: isShowList)
            }

            if selectedTab == 3 {
                SettingView()
            }

            CustomTabView(selectedTab: $selectedTab)
        }
    }
}

struct CustomTabView: View {
    @Binding var selectedTab: Int

    var body: some View {
        HStack {
            VStack {
                Image(systemName: "map.fill")
                    .resizable()
                    .frame(width: 23, height: 23)
                Text("지도")
                    .font(.system(size: 10))
            }
            .frame(width: UIScreen.main.bounds.width/3)
            .background(.white)
            .foregroundStyle(selectedTab == 1 ? .blue : .gray)
            .onTapGesture {
                selectedTab = 1
            }

            VStack {
                Image(systemName: "list.bullet")
                    .resizable()
                    .frame(width: 23, height: 23)
                Text("목록")
                    .font(.system(size: 10))
            }
            .frame(width: UIScreen.main.bounds.width/3)
            .background(.white)
            .foregroundStyle(selectedTab == 2 ? .blue : .gray)
            .onTapGesture {
                withAnimation {
                    selectedTab = 2
                }
            }

            VStack {
                Image(systemName: "gearshape.fill")
                    .resizable()
                    .frame(width: 23, height: 23)
                Text("설정")
                    .font(.system(size: 10))
            }
            .frame(width: UIScreen.main.bounds.width/3)
            .background(.white)
            .foregroundStyle(selectedTab == 3 ? .blue : .gray)
            .onTapGesture {
                selectedTab = 3
            }
        }
        .background(.white)
    }
}

#Preview {
    ContentView()
}
