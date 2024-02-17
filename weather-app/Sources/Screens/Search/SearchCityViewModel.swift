//
// © 2024 Test weather-app
//

import UIKit
import Combine

final class SearchCityViewModel {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, SearchCityViewController.Model>

    private weak var _dataSource: DataSource!

    private let client: HTTPClient
    private let router: CitiesWeatherRouter
    private let searchResultsViewModel: SearchResultsViewModel

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
        router: CitiesWeatherRouter
    ) {
        self.client = client
        self.router = router

        self.searchResultsViewModel = .init(
            client: client,
            router: router
        )
    }

    private func updateWeather(_ cities: [City]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(
            [
                .init(
                    id: .init(),
                    color: .systemPink,
                    title: "Title",
                    subtitle: "Subtitle",
                    weatherDesription: "Description",
                    temperatureRangeString: "Min: 0; Max: 20",
                    temperatureString: "15℃"
                )
            ]
        )
        _dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension SearchCityViewModel: SearchCityViewModelType {
    func setDataSource(_ dataSource: DataSource) {
        self._dataSource = dataSource
    }
    
    var title: AnyPublisher<String, Never> {
        Just("Search").eraseToAnyPublisher()
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

    func didUpdateText(with text: String) {
        searchResultsViewModel.showResults(for: text)
    }

    func viewDidLoad() {
        updateWeather([])
    }
}
