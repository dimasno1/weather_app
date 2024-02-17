//
// © 2024 Test weather-app
//

import UIKit

final class CitiesWeatherRouter {
    private unowned let rootViewController: UIViewController
    private let context: AppContext

    init(
        rootViewController: UIViewController,
        context: AppContext
    ) {
        self.rootViewController = rootViewController
        self.context = context
    }

    func showWeatherDetails(for city: City) {
        let controller = WeatherDetailsModule.create(
            city: city,
            context: context
        )
        rootViewController.present(controller, animated: true)
    }
}
