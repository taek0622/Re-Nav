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
    @State private var searchText: String = ""

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
    }
}

struct KakaoMapView: UIViewRepresentable {
    @Binding var draw: Bool

    func makeUIView(context: Self.Context) -> KMViewContainer {
        let view: KMViewContainer = KMViewContainer()
        view.sizeToFit()
        context.coordinator.createController(view)
        context.coordinator.controller?.initEngine()

        return view
    }

    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
        if draw {
            context.coordinator.controller?.startEngine()
            context.coordinator.controller?.startRendering()
        } else {
            context.coordinator.controller?.stopRendering()
            context.coordinator.controller?.stopEngine()
        }
    }

    func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator()
    }

    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {}

    class KakaoMapCoordinator: NSObject, MapControllerDelegate {
        var controller: KMController?
        var first: Bool

        override init() {
            first = true
            super.init()
        }

        func createController(_ view: KMViewContainer) {
            controller = KMController(viewContainer: view)
            controller?.delegate = self
        }

        func addViews() {
            let defaultPosition: MapPoint = MapPoint(longitude: 127.108678, latitude: 37.402001)
            let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)

            if controller?.addView(mapviewInfo) == Result.OK {
                _ = controller?.getView("mapview") as! KakaoMap
            }
        }

        func containerDidResized(_ size: CGSize) {
            let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
            mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)

            if first {
                let cameraUpdate: CameraUpdate = CameraUpdate.make(target: MapPoint(longitude: 127.108678, latitude: 37.402001), zoomLevel: 10, mapView: mapView!)
                mapView?.moveCamera(cameraUpdate)
                first = false
            }
        }
    }
}

#Preview {
    MapView()
}
