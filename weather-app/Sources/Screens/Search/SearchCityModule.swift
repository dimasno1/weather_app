//
// © 2024 Test weather-app
//

import UIKit

enum SearchCityModule {
    static func create(context: AppContext) -> UIViewController {
        let controller = SearchCityViewController()
        let navigation = UINavigationController(
            rootViewController: controller
        )
        let router = CitiesWeatherRouter(
            rootViewController: controller,
            context: context
        )
        let viewModel = SearchCityViewModel(
            client: context.httpClient,
            router: router
        )
        controller.viewModel = viewModel

        return navigation
    }
}
