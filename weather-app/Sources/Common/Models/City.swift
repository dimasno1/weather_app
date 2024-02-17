//
// © 2024 Test weather-app
//

import Foundation

struct City: Identifiable {
    let id: String
    let rank: Int
    let localizedName: String
    let country: Area
    let area: Area
}

struct Area: Identifiable {
    let id: String
    let localizedName: String
}

extension City: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "Key"
        case rank = "Rank"
        case localizedName = "LocalizedName"
        case country = "Country"
        case area = "AdministrativeArea"
    }
}

extension Area: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case localizedName = "LocalizedName"
    }
}
