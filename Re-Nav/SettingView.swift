//
//  SettingView.swift
//  Re-Nav
//
//  Created by 김민택 on 11/16/23.
//

import SwiftUI

struct SettingView: View {
    var body: some View {
        NavigationStack {
            List {
                Button("오픈 API") {
                    
                }
                Button("버전 정보") {
                    
                }
                Button("초기화") {
                    
                }
            }
            .foregroundStyle(.black)
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SettingView()
}
