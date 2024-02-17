//
// © 2024 Test weather-app
//

import Foundation

final class AppContext {
    let httpClient: HTTPClient

    init(
        httpClient: HTTPClient = .init(
            endpoint: URL(string: Constant.accuWeatherEndpointString)!,
            urlSession: .shared
        )
    ) {
        self.httpClient = httpClient
    }
}

enum Constant {
    static let accuWeatherEndpointString = "https://dataservice.accuweather.com"
    static let apiKey = "3vSmcixB4lboKeVZfEN3XYMUDfuzQZwz"
}
