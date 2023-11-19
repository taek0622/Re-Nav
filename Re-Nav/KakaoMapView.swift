//
//  KakaoMapView.swift
//  Re-Nav
//
//  Created by 김민택 on 11/20/23.
//

import SwiftUI

import KakaoMapsSDK

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

    class KakaoMapCoordinator: NSObject, MapControllerDelegate, KakaoMapEventDelegate {
        var controller: KMController?
        var first: Bool
        var _mapTapEventHandler: DisposableEventHandler?
        var _terrainTapEventHandler: DisposableEventHandler?
        var _terrainLongTapEventHandler: DisposableEventHandler?

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
                let mapView = controller?.getView("mapview") as! KakaoMap

                createLabelLayer()
                createPoiStyle()
                createPois()

                _mapTapEventHandler = mapView.addMapTappedEventHandler(target: self, handler: KakaoMapCoordinator.mapDidTapped)
                _terrainTapEventHandler = mapView.addTerrainTappedEventHandler(target: self, handler: KakaoMapCoordinator.terrainTapped)
                _terrainLongTapEventHandler = mapView.addTerrainLongPressedEventHandler(target: self, handler: KakaoMapCoordinator.terrainLongTapped)
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

        func createLabelLayer() {
            let view = controller?.getView("mapview") as! KakaoMap
            let manager = view.getLabelManager()
            let layerOption = LabelLayerOptions(layerID: "PoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0)
            let _ = manager.addLabelLayer(option: layerOption)
        }

        func createPoiStyle() {
            let view = controller?.getView("mapview") as! KakaoMap
            let manager = view.getLabelManager()

//            let noti1 = PoiBadge(badgeID: "badge1", image: UIImage(named: "Mark"), offset: CGPoint(x: 0.9, y: 0.1), zOrder: 0)
            let iconStyle1 = PoiIconStyle(symbol: UIImage(named: "Mark"), anchorPoint: CGPoint(x: 0.5, y: 1.0), badges: [])

            let poiStyle = PoiStyle(styleID: "PerLevelStyle", styles: [
                PerLevelPoiStyle(iconStyle: iconStyle1, level: 5)
            ])

            manager.addPoiStyle(poiStyle)
        }

        func createPois() {
            let view = controller?.getView("mapview") as! KakaoMap
            let manager = view.getLabelManager()
            let layer = manager.getLabelLayer(layerID: "PoiLayer")
            let poiOption = PoiOptions(styleID: "PerLevelStyle")
            poiOption.rank = 0
            poiOption.clickable = true

            let poi = layer?.addPoi(option: poiOption, at: MapPoint(longitude: 127.108678, latitude: 37.402001))
//            let badge = PoiBadge(badgeID: "noti", image: UIImage(named: "Mark"), offset: CGPoint(x: 0, y: 0), zOrder: 1)
//            poi?.addBadge(badge)
            poi?.show()
//            poi?.showBadge(badgeID: "noti")
//            print("call2")
        }

        func mapDidTapped(_ param: ViewInteractionEventParam) {
            let mapView = param.view as! KakaoMap
            let position = mapView.getPosition(param.point)

            print("Tapped: \(position.wgsCoord.longitude), \(position.wgsCoord.latitude)")
        }

        func terrainTapped(_ param: TerrainInteractionEventParam) {
            let mapView: KakaoMap = controller?.getView("mapview") as! KakaoMap
            let manager = mapView.getLabelManager()
            let layer = manager.getLabelLayer(layerID: "PoiLayer")
            let option = PoiOptions(styleID: "PerLevelStyle")
            option.clickable = true

            let position = param.position.wgsCoord
            print("Terrain Tapped: \(position.longitude), \(position.latitude)")

            let poi = layer?.addPoi(option: option, at: MapPoint(longitude: position.longitude, latitude: position.latitude))
            poi?.show()
        }

        func terrainLongTapped(_ param: TerrainInteractionEventParam) {
            let position = param.position.wgsCoord
            print("Terrain Long Tapped: \(position.longitude), \(position.latitude)")
        }
    }
}
