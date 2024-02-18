//
// © 2024 Test weather-app
//

import Foundation

final class AppContext {
    let httpClient: HTTPClient
    let database: Database

    init(
        httpClient: HTTPClient = .init(
            endpoint: URL(string: Constant.accuWeatherEndpointString)!,
            urlSession: .shared
        ),
        database: Database = .init()
    ) {
        self.httpClient = httpClient
        self.database = database
    }
}
