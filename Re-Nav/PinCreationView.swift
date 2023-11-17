//
//  PinCreationView.swift
//  Re-Nav
//
//  Created by 김민택 on 11/17/23.
//

import SwiftUI

struct PinCreationView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {}, label: {
                    Text("확인")
                        .foregroundStyle(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: UIScreen.main.bounds.width-32, height: 50)
                                .foregroundStyle(.red)
                        }
                })
            }
            .navigationTitle("핀 추가")
            .navigationBarTitleDisplayMode(.inline)
            .padding(16)
        }
    }
}

#Preview {
    PinCreationView()
}
