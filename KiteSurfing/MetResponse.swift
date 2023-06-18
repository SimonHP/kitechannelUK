//
//  MetResponse.swift
//  KiteSurfing
//
//  Created by Ram Suthar on 17/01/21.
//


import Foundation

// MARK: - MetResponse
struct MetResponse: Codable {
    let type: String?
    let features: [Feature]?
}

// MARK: - Feature
struct Feature: Codable {
    let type: String?
    let properties: Properties?
    let geometry: Geometry?
    let id: String?
}

// MARK: - Geometry
struct Geometry: Codable {
    let type: String?
    let coordinates: [Double]?
}

// MARK: - Properties
struct Properties: Codable {
//    let boundedBy, msGeometry, msGeometryOSGB: JSONNull?
    let id: String?
    let sensor, date, value: String?
    let type: String?
    let dir, temp, gust, pressure: String?
    let hw, hwTimestamp, lw, lwTimestamp: String?
    
    enum CodingKeys: String, CodingKey {
        case id, sensor, date, value, type, dir, temp, gust, pressure, hw, lw
        case hwTimestamp = "hw_timestamp"
        case lwTimestamp = "lw_timestamp"
    }
}
