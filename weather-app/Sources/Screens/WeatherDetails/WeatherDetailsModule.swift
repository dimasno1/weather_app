//
// © 2024 Test weather-app
//

import UIKit

enum WeatherDetailsModule {
    static func create(
        city: City,
        context: AppContext
    ) -> UIViewController {
        let viewController = WeatherDetailsViewController()
        let router = WeatherDetailsRouter(
            rootViewController: viewController
        )
        let viewModel = WeatherDetailsViewModel(
            city: city,
            httpClient: context.httpClient,
            database: context.database,
            router: router
        )
        viewController.viewModel = viewModel
        return viewController
    }
}
