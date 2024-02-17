//
// © 2024 Test weather-app
//

import Foundation

struct WeatherConditions {
    let updateTime: Date
    let text: String
    let iconCode: Int?
    let isDay: Bool
    let temperature: Temperature
}

extension WeatherConditions: Decodable {
    enum CodingKeys: String, CodingKey {
        case updateTime = "LocalObservationDateTime"
        case text = "WeatherText"
        case iconCode = "WeatherIcon"
        case isDay = "IsDayTime"
        case temperature = "Temperature"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let dateString = try container.decode(String.self, forKey: .updateTime)
        let dateFormatter = ISO8601DateFormatter()
        let date = dateFormatter.date(from: dateString)!

        updateTime = date
        self.text = try container.decode(String.self, forKey: .text)
        self.iconCode = try container.decode(Int.self, forKey: .iconCode)
        self.isDay = try container.decode(Bool.self, forKey: .isDay)
        self.temperature = try container.decode(Temperature.self, forKey: .temperature)
    }
}

extension WeatherConditions {
    struct Temperature: Decodable {
        let metric: TemperatureValue
        let imperial: TemperatureValue

        enum CodingKeys: String, CodingKey {
            case metric = "Metric"
            case imperial = "Imperial"
        }
    }

    struct TemperatureValue: Decodable {
        let value: Double
        let unit: String

        enum CodingKeys: String, CodingKey {
            case value = "Value"
            case unit = "Unit"
        }
    }
}
