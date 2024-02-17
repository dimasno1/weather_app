//
// © 2024 Test weather-app
//

import UIKit
import Combine

final class WeatherDetailsViewModel {
    private let city: City
    private let httpClient: HTTPClient

    private let weatherSubject = CurrentValueSubject<WeatherConditions?, Never>(nil)

    init(
        city: City,
        httpClient: HTTPClient
    ) {
        self.city = city
        self.httpClient = httpClient
    }

    private func updateWeather() {
        httpClient.perform(
            .getConditions(for: city.id)
        ) { [weak self] (_, code, result: Result<[WeatherConditions], Error>) in
            switch result {
            case let .success(conditions):
                self?.weatherSubject.send(conditions[0])
            case .failure:
                print("")
            }
        }
    }
}

extension WeatherDetailsViewModel: WeatherDetailsViewModelType {
    var cityName: AnyPublisher<String, Never> {
        Just(city.localizedName).eraseToAnyPublisher()
    }
    
    var temperatureString: AnyPublisher<String, Never> {
        weatherSubject.receive(on: DispatchQueue.main).map { conditions in
            guard let conditions else {
                return "--"
            }
            return "\(conditions.temperature.metric.value)°"
        }.eraseToAnyPublisher()
    }
    
    var temperatureColor: AnyPublisher<UIColor, Never> {
        weatherSubject.receive(on: DispatchQueue.main).map { conditions in
            guard let conditions else {
                return .clear
            }
            switch conditions.temperature.metric.value {
            case ..<10:
                return.blue
            case 10 ... 20:
                return .black
            case 21... :
                return .red
            default: return .clear
            }
        }.eraseToAnyPublisher()
    }

    var backgroundColor: AnyPublisher<UIColor, Never> {
        weatherSubject.receive(on: DispatchQueue.main).map { conditions in
            guard let conditions else {
                return .clear
            }

            return conditions.isDay
                ? UIColor(red: 97/255, green: 205/255, blue: 237/255, alpha: 1.0)
                : UIColor(red: 21/255, green: 91/255, blue: 112/255, alpha: 1.0)
        }.eraseToAnyPublisher()
    }

    var description: AnyPublisher<String, Never> {
        weatherSubject.receive(on: DispatchQueue.main).map { conditions in
            guard let conditions else {
                return ""
            }
            return conditions.text
        }.eraseToAnyPublisher()
    }
    
    var rangeDescription: AnyPublisher<String, Never> {
        Just("not available yet").eraseToAnyPublisher()
    }
    
    var actionsHidden: AnyPublisher<Bool, Never> {
        Just(true).eraseToAnyPublisher()
    }

    var icon: AnyPublisher<UIImage?, Never> {
        weatherSubject.receive(on: DispatchQueue.main).map { conditions in
            guard let conditions else {
                return nil
            }
            return conditions.iconCode.flatMap { UIImage(named: "\($0)-s.png") }
        }.eraseToAnyPublisher()
    }

    func didTapAdd() {
    }
    
    func didTapCancel() {
    }

    func viewDidLoad() {
        updateWeather()
    }
}

extension HTTPRequest {
    static func getConditions(for cityID: String) -> HTTPRequest {
        return .init(
            method: .get,
            path: "/currentconditions/v1/\(cityID)",
            parameters: [
                .init(name: "apikey", value: Constant.apiKey)
            ]
        )
    }
}
