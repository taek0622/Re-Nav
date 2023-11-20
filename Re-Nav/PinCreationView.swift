//
//  PinCreationView.swift
//  Re-Nav
//
//  Created by 김민택 on 11/17/23.
//

import SwiftData
import SwiftUI

struct PinCreationView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Query(sort: [SortDescriptor<Theme>(\Theme.createAt)], animation: .default) var allThemes: [Theme]

    @State private var choosenTheme: Theme?
    @State private var newTheme = ""
    @State private var name = ""
    @State private var roadAddress = ""
    @State private var address = ""
    @State private var detail = ""
    @State private var starRate = 1
    @State private var isAddNewTheme = false
    @Binding var longitude: Double
    @Binding var latitude: Double

    @State private var pinAddress: Address?
    @State private var pinRoadAddress: RoadAddress?

    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    VStack {
                        HStack {
                            Text("테마")
                                .fontWeight(.bold)
                            Spacer()
                            Menu(choosenTheme?.name ?? "선택") {
                                ForEach(allThemes) { theme in
                                    Button(theme.name, action: { choosenTheme = theme })
                                }
                                Button("+ 새로운 테마 추가", action: { isAddNewTheme = true })
                            }
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

                        if roadAddress != "" {
                            HStack {
                                Text("도로명 주소")
                                    .fontWeight(.bold)
                                    .padding(.trailing)
                                Spacer()
                                Text(roadAddress)
                            }
                            .padding(.vertical, 8)
                        }

                        if address != "" {
                            HStack {
                                Text("지번 주소")
                                    .fontWeight(.bold)
                                    .padding(.trailing)
                                Spacer()
                                Text(address)
                            }
                            .padding(.vertical, 8)
                        }

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
                        .padding(.bottom, 16)
                    }
                    .padding(.horizontal, 16)
                }

                Button(action: {
                    let pin = Pin(name: name, longitude: longitude, latitude: latitude, address: pinAddress, roadAddress: pinRoadAddress, theme: choosenTheme!, detail: detail, photos: [], rate: starRate, createAt: Date.now, updateAt: Date.now)
                    context.insert(pin)
                    try? context.save()
                    dismiss()
                }, label: {
                    Text("확인")
                        .foregroundStyle(.white)
                        .background {
                            RoundedRectangle(cornerRadius: 16)
                                .frame(width: UIScreen.main.bounds.width-32, height: 50)
                                .foregroundStyle(choosenTheme != nil && name != "" && (pinAddress != nil || pinRoadAddress != nil) ? .red : .gray)
                        }
                })
                .disabled(choosenTheme != nil && name != "" && (pinAddress != nil || pinRoadAddress != nil) ? false : true)
            }
            .navigationTitle("핀 추가")
            .navigationBarTitleDisplayMode(.inline)
        }
        .alert("새로운 테마 추가하기", isPresented: $isAddNewTheme, actions: {
            TextField("추가할 테마 이름을 입력해주세요", text: $newTheme)

            Button {
                let theme = Theme(name: newTheme, pins: [], createAt: Date.now)
                context.insert(theme)
                try? context.save()
            } label: {
                Text("확인")
            }
            Button("취소", role: .cancel, action: {})
        })
        .onAppear {
            fetchAddressData(longitude, latitude)
        }
    }

    private func fetchAddressData(_ longitude: Double, _ latitude: Double) {
        guard var urlComponents = URLComponents(string: "https://dapi.kakao.com/v2/local/geo/coord2address.json") else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "x", value: String(longitude)),
            URLQueryItem(name: "y", value: String(latitude))
        ]

        guard let requestURL = urlComponents.url else { return }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.addValue(Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_API_KEY") as! String, forHTTPHeaderField: "Authorization")

        let defaultSession = URLSession(configuration: .default)

        defaultSession.dataTask(with: request) { data, _, error in
            if let data  {
                do {
                    let decodedData = try JSONDecoder().decode(AddressFetchDataModel.self, from: data)

                    if decodedData.meta.total_count == 0 {
                        return
                    }

                    if let newAddress = decodedData.documents[0].address {
                        pinAddress = Address(fullAddress: newAddress.address_name, depth1: newAddress.region_1depth_name, depth2: newAddress.region_2depth_name, depth3: newAddress.region_3depth_name, mainNo: newAddress.main_address_no, subNo: newAddress.sub_address_no)

                        address = newAddress.address_name
                    }

                    if let newRoadAdress = decodedData.documents[0].road_address {
                        pinRoadAddress = RoadAddress(fullAddress: newRoadAdress.address_name, depth1: newRoadAdress.region_1depth_name, depth2: newRoadAdress.region_2depth_name, depth3: newRoadAdress.region_3depth_name, road: newRoadAdress.road_name, mainNo: newRoadAdress.main_building_no, subNo: newRoadAdress.sub_building_no, buildingName: newRoadAdress.building_name, postalCode: newRoadAdress.zone_no)

                        roadAddress = newRoadAdress.address_name
                    }

                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            } else if let error {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }.resume()
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
