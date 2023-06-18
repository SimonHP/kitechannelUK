//
//  Model.swift
//  KiteSurfing
//
//  Created by Ram Suthar on 22/12/20.
//

import Foundation

struct Model {
    let dateTime: String
    let windSpeed: String
    let gustSpeed: String
    let windDirection: String
    let temperature: String
    let nextHW: String
    let nextLW: String
}

enum Observatory: String {
    case Arun = "Arun"
    case Brighton = "Brighton"
    case Sandown = "Sandown Pier"
    case Chapel = "Chapel Point"
    case Deal = "Deal Pier"
    case Felixstow = "Felixstowe"
    case Folkstone = "Folkstone"
    case Happisburgh = "Happisburgh"
    case Herne = "Herne Bay"
    case Looe = "Looe Bay"
    case Lymington = "Lymington"
    case Penzance = "Penzance"
    case Perranporth = "Perranporth"
    case Portland = "Portland Harbour"
    case Teignmouth = "Teignmouth Pier"
    case West = "West Bay Harbour"
    case Weymouth = "Weymouth"
    case Worthing = "Worthing Pier"
    case Southwold = "Southwold"
    case Swanage = "Swanage Pier"
    case Penarth = "Penarth"
    
    static var values: [String] {
        return [
            Observatory.Arun.rawValue,
            Observatory.Brighton.rawValue,
            Observatory.Sandown.rawValue,
            Observatory.Chapel.rawValue,
            Observatory.Deal.rawValue,
            Observatory.Felixstow.rawValue,
            Observatory.Folkstone.rawValue,
            Observatory.Happisburgh.rawValue,
            Observatory.Herne.rawValue,
            Observatory.Looe.rawValue,
            Observatory.Lymington.rawValue,
            Observatory.Penzance.rawValue,
            Observatory.Perranporth.rawValue,
            Observatory.Portland.rawValue,
            Observatory.Teignmouth.rawValue,
            Observatory.West.rawValue,
            Observatory.Weymouth.rawValue,
            Observatory.Worthing.rawValue,
            Observatory.Southwold.rawValue,
            Observatory.Swanage.rawValue,
            Observatory.Penarth.rawValue
        ]
    }
}

