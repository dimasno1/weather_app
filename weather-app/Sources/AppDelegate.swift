//
// © 2024 Test weather-app
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    let appContext = AppContext()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        let controller = SearchCityModule.create(
            context: appContext
        )
        window.rootViewController = controller
        window.makeKeyAndVisible()

        return true
    }
}
