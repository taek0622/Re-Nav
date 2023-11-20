//
//  FetchDataModel.swift
//  Re-Nav
//
//  Created by 김민택 on 11/20/23.
//

import Foundation

final class AddressFetchDataModel: Codable {
    let meta: MetaFetchData
    let documents: [DocumentFetchData]

    init(meta: MetaFetchData, documents: [DocumentFetchData]) {
        self.meta = meta
        self.documents = documents
    }
}

final class MetaFetchData: Codable {
    let total_count: Int

    init(total_count: Int) {
        self.total_count = total_count
    }
}

final class DocumentFetchData: Codable {
    let road_address: RoadAddressFetchData?
    let address: AddressFetchData?

    init(road_address: RoadAddressFetchData, address: AddressFetchData) {
        self.road_address = road_address
        self.address = address
    }
}

final class AddressFetchData: Codable {
    let address_name: String
    let region_1depth_name: String
    let region_2depth_name: String
    let region_3depth_name: String
    let mountain_yn: String
    let main_address_no: String
    let sub_address_no: String
    let zip_code: String

    init(address_name: String?, region_1depth_name: String?, region_2depth_name: String?, region_3depth_name: String?, mountain_yn: String?, main_address_no: String?, sub_address_no: String?, zip_code: String?) {
        self.address_name = address_name ?? ""
        self.region_1depth_name = region_1depth_name ?? ""
        self.region_2depth_name = region_2depth_name ?? ""
        self.region_3depth_name = region_3depth_name ?? ""
        self.mountain_yn = mountain_yn ?? ""
        self.main_address_no = main_address_no ?? ""
        self.sub_address_no = sub_address_no ?? ""
        self.zip_code = zip_code ?? ""
    }
}

final class RoadAddressFetchData: Codable {
    let address_name: String
    let region_1depth_name: String
    let region_2depth_name: String
    let region_3depth_name: String
    let road_name: String
    let underground_yn: String
    let main_building_no: String
    let sub_building_no: String
    let building_name: String
    let zone_no: String

    init(address_name: String?, region_1depth_name: String?, region_2depth_name: String?, region_3depth_name: String?, road_name: String?, underground_yn: String?, main_building_no: String?, sub_building_no: String?, building_name: String?, zone_no: String?) {
        self.address_name = address_name ?? ""
        self.region_1depth_name = region_1depth_name ?? ""
        self.region_2depth_name = region_2depth_name ?? ""
        self.region_3depth_name = region_3depth_name ?? ""
        self.road_name = road_name ?? ""
        self.underground_yn = underground_yn ?? ""
        self.main_building_no = main_building_no ?? ""
        self.sub_building_no = sub_building_no ?? ""
        self.building_name = building_name ?? ""
        self.zone_no = zone_no ?? ""
    }
}
