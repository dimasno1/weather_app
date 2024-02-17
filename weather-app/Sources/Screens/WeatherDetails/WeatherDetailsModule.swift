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
        let viewModel = WeatherDetailsViewModel(
            city: city,
            httpClient: context.httpClient
        )
        viewController.viewModel = viewModel
        return viewController
    }
}
