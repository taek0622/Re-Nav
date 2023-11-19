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
        var _poiTapEventHandler: DisposableEventHandler?

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
                _poiTapEventHandler = mapView.addPoisTappedEventHandler(target: self, handler: KakaoMapCoordinator.poiTapped)
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
            let savedPoiLayerOption = LabelLayerOptions(layerID: "SavedPoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0)
            let unsavedPoiLayerOption = LabelLayerOptions(layerID: "UnsavedPoiLayer", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 1)
            let _ = manager.addLabelLayer(option: savedPoiLayerOption)
            let _ = manager.addLabelLayer(option: unsavedPoiLayerOption)
        }

        func createPoiStyle() {
            let view = controller?.getView("mapview") as! KakaoMap
            let manager = view.getLabelManager()

            let savedPinIcon = PoiIconStyle(symbol: UIImage(named: "SavedPin"), anchorPoint: CGPoint(x: 0.5, y: 1.0))
            let unsavedPinIcon = PoiIconStyle(symbol: UIImage(named: "UnsavedPin"), anchorPoint: CGPoint(x: 0.5, y: 1.0))

            let savedPinStyle = PoiStyle(styleID: "SavedPinStyle", styles: [
                PerLevelPoiStyle(iconStyle: savedPinIcon, level: 5)
            ])
            let unsavedPinStyle = PoiStyle(styleID: "UnsavedPinStyle", styles: [
                PerLevelPoiStyle(iconStyle: unsavedPinIcon, level: 5)
            ])

            manager.addPoiStyle(savedPinStyle)
            manager.addPoiStyle(unsavedPinStyle)
        }

        func createPois() {
            let view = controller?.getView("mapview") as! KakaoMap
            let manager = view.getLabelManager()
            let savedPoiLayer = manager.getLabelLayer(layerID: "SavedPoiLayer")
            let poiOption = PoiOptions(styleID: "SavedPinStyle")
            poiOption.rank = 0
            poiOption.clickable = true

            let poi = savedPoiLayer?.addPoi(option: poiOption, at: MapPoint(longitude: 127.108678, latitude: 37.402001))
            poi?.show()
        }

        func mapDidTapped(_ param: ViewInteractionEventParam) {
            let mapView = param.view as! KakaoMap
            let position = mapView.getPosition(param.point)

            print("Map Tapped: \(position.wgsCoord.longitude), \(position.wgsCoord.latitude)")
        }

        func terrainTapped(_ param: TerrainInteractionEventParam) {
            let mapView: KakaoMap = controller?.getView("mapview") as! KakaoMap
            let manager = mapView.getLabelManager()
            let unsavedPoiLayer = manager.getLabelLayer(layerID: "UnsavedPoiLayer")
            let option = PoiOptions(styleID: "UnsavedPinStyle")
            option.clickable = true

            let position = param.position.wgsCoord
            print("Terrain Tapped: \(position.longitude), \(position.latitude)")

            let poi = unsavedPoiLayer?.addPoi(option: option, at: MapPoint(longitude: position.longitude, latitude: position.latitude))
            poi?.show()
        }

        func terrainLongTapped(_ param: TerrainInteractionEventParam) {
            let position = param.position.wgsCoord
            print("Terrain Long Tapped: \(position.longitude), \(position.latitude)")
        }

        func poiTapped(_ param: PoisInteractionEventParam) {
            let mapView: KakaoMap = controller?.getView("mapview") as! KakaoMap
            let manager = mapView.getLabelManager()
            let savedPoiLayer = manager.getLabelLayer(layerID: "SavedPoiLayer")
            let unsavedPoiLayer = manager.getLabelLayer(layerID: "UnsavedPoiLayer")

            if let savedPoi = savedPoiLayer?.getPoi(poiID: param.poiID) {
                print("savedPoi")
            }

            if let unsavedPoi = unsavedPoiLayer?.getPoi(poiID: param.poiID) {
                let position = unsavedPoi.position.wgsCoord
                print("POI Tapped: \(position.longitude), \(position.latitude)")
                NotificationCenter.default.post(name: NSNotification.Name("PoiTapNotification"), object: position)
            }
        }
    }
}
