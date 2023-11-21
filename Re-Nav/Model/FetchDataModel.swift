//
//  FetchDataModel.swift
//  Re-Nav
//
//  Created by 김민택 on 11/20/23.
//

import Foundation

final class AddressFetchDataModel: Codable {
    let meta: AddressMetaFetchData
    let documents: [AddressDocumentFetchData]

    init(meta: AddressMetaFetchData, documents: [AddressDocumentFetchData]) {
        self.meta = meta
        self.documents = documents
    }
}

final class AddressMetaFetchData: Codable {
    let total_count: Int

    init(total_count: Int) {
        self.total_count = total_count
    }
}

final class AddressDocumentFetchData: Codable {
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

final class SearchFetchDataModel: Codable {
    let meta: SearchMetaFetchData
    let documents: [SearchDocumentFetchData]

    init(meta: SearchMetaFetchData, documents: [SearchDocumentFetchData]) {
        self.meta = meta
        self.documents = documents
    }
}

final class SearchMetaFetchData: Codable {
    let total_count: Int
    let pageable_count: Int
    let is_end: Bool
    let same_name: SameNameFetchData

    init(total_count: Int, pageable_count: Int, is_end: Bool, same_name: SameNameFetchData) {
        self.total_count = total_count
        self.pageable_count = pageable_count
        self.is_end = is_end
        self.same_name = same_name
    }
}

final class SearchDocumentFetchData: Codable {
    let id: String
    let place_name: String
    let category_name: String
    let category_group_code: String
    let category_group_name: String
    let phone: String
    let address_name: String
    let x: String
    let y: String
    let place_url: String

    init(id: String, place_name: String, category_name: String, category_group_code: String, category_group_name: String, phone: String, address_name: String, x: String, y: String, place_url: String) {
        self.id = id
        self.place_name = place_name
        self.category_name = category_name
        self.category_group_code = category_group_code
        self.category_group_name = category_group_name
        self.phone = phone
        self.address_name = address_name
        self.x = x
        self.y = y
        self.place_url = place_url
    }
}

final class SameNameFetchData: Codable {
    let region: [String]
    let keyword: String
    let selected_region: String

    init(region: [String], keyword: String, selected_region: String) {
        self.region = region
        self.keyword = keyword
        self.selected_region = selected_region
    }
}
