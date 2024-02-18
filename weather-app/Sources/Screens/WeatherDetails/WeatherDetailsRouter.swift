//
// © 2024 Test weather-app
//

import UIKit

final class WeatherDetailsRouter {
    private unowned let rootViewController: UIViewController

    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }

    func dismiss() {
        rootViewController.dismiss(animated: true)
    }
}
