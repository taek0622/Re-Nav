//
//  PinCreationView.swift
//  Re-Nav
//
//  Created by 김민택 on 11/17/23.
//

import SwiftUI

struct PinCreationView: View {
    @State private var name = ""
    @State private var address = ""
    @State private var detail = ""
    @State private var starRate = 1

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    HStack {
                        Text("테마")
                            .fontWeight(.bold)
                        Spacer()
                        Button(action: {}, label: {
                            Text("음식")
                        })
                        .buttonStyle(.borderedProminent)
                        .tint(.gray)
                        .buttonBorderShape(.roundedRectangle(radius: 16))
                        .foregroundStyle(.black)
                    }
                    .padding(.vertical, 8)

                    HStack {
                        Text("상호")
                            .fontWeight(.bold)
                            .padding(.trailing)

                        VStack {
                            TextField("상호명을 입력하세요", text: $name)
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.vertical, 8)

                    HStack {
                        Text("주소")
                            .fontWeight(.bold)
                            .padding(.trailing)

                        VStack {
                            TextField("주소를 입력하세요", text: $address)
                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding(.vertical, 8)

                    HStack {
                        Text("사진")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.top, 8)

                    ScrollView(.horizontal) {
                        HStack {
                            Button(action: {}, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 8)
                                        .frame(width: 100, height: 100)
                                        .foregroundStyle(.gray)
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundStyle(.red)
                                }
                            })
                        }
                    }
                    .padding(.bottom, 8)

                    HStack {
                        Text("설명")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.top, 8)

                    TextField("설명을 입력하세요", text: $detail, axis: .vertical)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(5, reservesSpace: true)
                        .padding(.bottom, 8)

                    HStack {
                        Text("평점")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .padding(.top, 8)

                    HStack {
                        RatingView(rate: $starRate)
                    }
                    .padding(.bottom, 8)
                }

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

struct RatingView: View {
    @Binding var rate: Int
    var maxRate = 5
    var inActiveSymbol: Image?
    var activeSymbol = Image(systemName: "star.fill")
    var inActiveColor = Color.gray
    var activeColor = Color.yellow
    var size = (UIScreen.main.bounds.width-70) / 5

    var body: some View {
        HStack {
            ForEach(1...maxRate, id: \.self) { idx in
                symbol(for: idx)
                    .resizable()
                    .frame(width: size, height: size)
                    .foregroundStyle(idx > rate ? inActiveColor : activeColor)
                    .onTapGesture {
                        rate = idx
                    }
            }
        }
    }

    private func symbol(for number: Int) -> Image {
        if number > rate {
            return inActiveSymbol ?? activeSymbol
        }

        return activeSymbol
    }
}

#Preview {
    PinCreationView()
}
