//
//  MapView.swift
//  Re-Nav
//
//  Created by 김민택 on 11/16/23.
//

import SwiftUI

import KakaoMapsSDK

struct MapView: View {
    @State private var draw: Bool = false
    @State private var isPinClicked: Bool = false
    @State private var searchText: String = ""
    let poiTapPub = NotificationCenter.default.publisher(for: NSNotification.Name("PoiTapNotification"))

    var body: some View {
        NavigationStack {
            ZStack {
                KakaoMapView(draw: $draw)
                    .onAppear(perform: {
                        self.draw = true
                    })
                    .onDisappear(perform: {
                        self.draw = false
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .navigationTitle("Nav")
            .searchable(text: $searchText)
        }
        .sheet(isPresented: $isPinClicked, content: {
            PinCreationView()
        })
        .onReceive(poiTapPub, perform: { _ in
            isPinClicked = true
        })
    }
}

#Preview {
    MapView()
}
