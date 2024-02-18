//
// © 2024 Test weather-app
//

import UIKit
import Combine
import CoreData

final class SearchCityViewModel {
    struct CityConditions {
        let city: City
        var conditions: WeatherConditions
    }
    struct IdentifiableValue<T> {
        let id: String
        var value: T
    }

    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, SearchCityViewController.Model>

    private weak var _dataSource: DataSource!

    private let dateFormatter = DateFormatter()
    private let client: HTTPClient
    private let database: Database
    private let router: CitiesWeatherRouter
    private let searchResultsViewModel: SearchResultsViewModel

    private var weatherItems: [IdentifiableValue<CityConditions>] = []
    private var databaseCancellable: AnyCancellable?

    private lazy var _searchController = UISearchController(
        searchResultsController: searchResultsViewController
    )

    private lazy var searchResultsViewController = {
        let controller = SearchResultsViewController()
        controller.viewModel = self.searchResultsViewModel

        return controller
    }()

    init(
        client: HTTPClient,
        database: Database,
        router: CitiesWeatherRouter
    ) {
        self.client = client
        self.router = router
        self.database = database

        self.searchResultsViewModel = .init(
            client: client,
            router: router
        )

        dateFormatter.locale = Locale(identifier: LanguageCode.pl.rawValue)
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
    }

    private func updateWeather(for cities: [City]) {
        weatherItems = cities.map { city in
            return .init(
                id: city.id,
                value: .init(city: city, conditions: .empty)
            )
        }
        DispatchQueue.main.async { [weak self] in
            self?.updateSnapshot()
        }

        let ids = weatherItems.map { $0.id }
        ids.enumerated().forEach { [weak self] index, cityID in
            self?.client.perform(
                .getConditions(for: cityID)
            ) { [weak self] (_, _, result: Result<[WeatherConditions], Error>) in
                switch result {
                case let .success(conditions):
                    self?.weatherItems[index].value.conditions = conditions[0]

                    DispatchQueue.main.async { [weak self] in
                        self?.updateSnapshot()
                    }

                case let .failure(error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    @MainActor
    private func updateSnapshot() {
        let models = weatherItems.map { item in
            Model(
                id: item.id, 
                color: item.value.conditions.dayBackgroundColor,
                title: item.value.city.localizedName,
                subtitle: dateFormatter.string(from: item.value.conditions.updateTime),
                weatherDesription: item.value.conditions.text,
                temperatureRangeString: "forecast not available yet",
                temperatureString: "\(item.value.conditions.temperature.metric.value)°"
            )
        }

        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(models)

        _dataSource.apply(snapshot, animatingDifferences: false)
    }

    private func observeDBUpdates() {
        databaseCancellable = database.saveNotificationPublisher.sink { [weak self] notification in
            guard
                let userInfo = notification.userInfo,
                let inserted = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>,
                inserted.isEmpty == false
            else {
                return
            }
            self?.refreshWeather()
        }
    }

    private func refreshWeather() {
        let cities = database.getCities()
        updateWeather(for: cities)
    }
}

extension SearchCityViewModel: SearchCityViewModelType {
    func setDataSource(_ dataSource: DataSource) {
        self._dataSource = dataSource
    }
    
    var title: AnyPublisher<String, Never> {
        Just("Search for city").eraseToAnyPublisher()
    }
    
    var searchController: AnyPublisher<UISearchController, Never> {
        Just(_searchController).eraseToAnyPublisher()
    }

    func didTapCancel() {
        print("cancel")
    }

    func didTapSearch() {
        print("search")
    }

    func didTapOnSavedCity(at index: Int) {
        let city = weatherItems[index].value.city
        router.showWeatherDetails(for: city)
    }

    func didUpdateText(with text: String) {
        searchResultsViewModel.showResults(for: text)
    }

    func viewDidLoad() {
        observeDBUpdates()
        refreshWeather()
    }
}

extension WeatherConditions {
    static let empty = WeatherConditions(
        updateTime: Date(),
        text: "",
        iconCode: nil,
        isDay: true,
        temperature: .init(
            metric: .init(value: 0, unit: ""),
            imperial: .init(value: 0, unit: "")
        )
    )
}
