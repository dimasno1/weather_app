//
// © 2024 Test weather-app
//

import UIKit

final class SearchResultsViewModel {
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Model>

    private weak var _dataSource: DataSource!
    private let client: HTTPClient
    private let router: CitiesWeatherRouter

    private var cities: [City] = []

    init(
        client: HTTPClient,
        router: CitiesWeatherRouter
    ) {
        self.client = client
        self.router = router
    }

    func showResults(for searchWord: String) {
        let request = HTTPRequest.getCities(with: searchWord)

        client.perform(request) { [weak self] (_, _, result: Result<[City], Error>) in
            switch result {
            case let .success(cities):
                self?.updateSearch(with: cities, searchWord: searchWord)
            case .failure:
                print("")
            }
        }
    }

    private func updateSearch(
        with cities: [City],
        searchWord: String
    ) {
        self.cities = cities

        var snapshot = Snapshot()
        snapshot.appendSections([0])

        let models = cities.map {
            let cityName = $0.localizedName
            let fullString = "\(cityName), \($0.country.localizedName)"

            let attributed = NSMutableAttributedString(
                string: fullString,
                attributes: [.foregroundColor: UIColor.gray]
            )
            if let cityRange = cityName.range(of: searchWord) {
                let convertedRange = NSRange(cityRange, in: fullString)
                attributed.addAttribute(
                    .foregroundColor,
                    value: UIColor.black,
                    range: convertedRange
                )
            }

            return Model(id: $0.id, attributedText: attributed)
        }

        snapshot.appendItems(models)
        _dataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension SearchResultsViewModel: SearchResultsViewModelType {
    func setDataSource(_ dataSource: DataSource) {
        _dataSource = dataSource
    }
    
    func didSelectOption(at index: Int) {
        let city = cities[index]

        router.showWeatherDetails(for: city)
    }
}

extension HTTPRequest {
    static func getCities(with searchName: String) -> HTTPRequest {
        return .init(
            method: .get,
            path: "/locations/v1/cities/autocomplete",
            parameters: [
                .init(name: "apikey", value: Constant.apiKey),
                .init(name: "q", value: searchName),
                .init(name: "language", value: LanguageCode.pl.rawValue)
            ]
        )
    }
}
