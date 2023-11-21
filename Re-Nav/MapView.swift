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
    @State private var position = GeoCoordinate(longitude: 127.108678, latitude: 37.402001)
    @State private var searchResult = [SearchDocumentFetchData]()
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
            PinCreationView(longitude: $position.longitude, latitude: $position.latitude)
        })
        .onReceive(poiTapPub, perform: { pub in
            position = pub.object as! GeoCoordinate
            isPinClicked = true
        })
        .onSubmit(of: .search) {
            fetchSearchData(searchText)
        }
    }

    private func fetchSearchData(_ searchText: String) {
        guard var urlComponents = URLComponents(string: "https://dapi.kakao.com/v2/local/search/keyword.json") else { return }
        urlComponents.queryItems = [
            URLQueryItem(name: "query", value: searchText)
        ]

        guard let requestURL = urlComponents.url else { return }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.addValue(Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_API_KEY") as! String, forHTTPHeaderField: "Authorization")

        let defaultSession = URLSession(configuration: .default)

        defaultSession.dataTask(with: request) { data, _, error in
            if let data  {
                do {
                    let decodedData = try JSONDecoder().decode(SearchFetchDataModel.self, from: data)
                    searchResult = decodedData.documents
                } catch {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            } else if let error {
                print("Error fetching data: \(error.localizedDescription)")
            }
        }.resume()
    }
}

#Preview {
    MapView()
}
