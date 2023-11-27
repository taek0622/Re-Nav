//
//  PinListView.swift
//  Re-Nav
//
//  Created by 김민택 on 11/16/23.
//

import SwiftData
import SwiftUI

struct PinListView: View {
//    @State private var isShowSheet = false
    @Environment(\.modelContext) private var modelContext

    @State private var fetchDescriptor = FetchDescriptor<Pin>(sortBy: [SortDescriptor<Pin>(\Pin.createAt)])
    @State private var pins = [Pin]()

    var body: some View {
        NavigationStack {
            List(pins, id: \.id) {
                Button($0.name) {
                    
                }
            }
            .foregroundStyle(.black)
            .navigationTitle("핀 리스트")
            .navigationBarTitleDisplayMode(.inline)
        }
        .cornerRadius(16, corners: [.topLeft, .topRight])
        .onAppear {
            guard let locations = try? modelContext.fetch(fetchDescriptor) else { return }
            pins = locations
        }
    }
}

#Preview {
    PinListView()
}
