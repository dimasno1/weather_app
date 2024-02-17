//
// © 2024 Test weather-app
//

import UIKit
import Combine
import SnapKit

protocol SearchCityViewModelType {
    typealias DataSource = SearchCityViewController.DataSource

    var title: AnyPublisher<String, Never> { get }
    var searchController: AnyPublisher<UISearchController, Never> { get }

    func didTapCancel()
    func didTapSearch()
    func didUpdateText(with text: String)

    func viewDidLoad()
    func setDataSource(_ dataSource: DataSource)
}

extension SearchCityViewController {
    struct Model: Hashable {
        let id: UUID
        let color: UIColor
        let title: String
        let subtitle: String
        let weatherDesription: String
        let temperatureRangeString: String
        let temperatureString: String
    }
}

final class SearchCityViewController: UIViewController {
    typealias DataSource = UICollectionViewDiffableDataSource<Int, Model>

    var viewModel: SearchCityViewModelType!

    private let collectionView = {
        let flowLayout = UICollectionViewCompositionalLayout.citiesList

        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: flowLayout
        )
        return collectionView
    }()

    private lazy var dataSource = DataSource(
        collectionView: collectionView
    ) { [weak self] collectionView, indexPath, model in
        self?.createCell(for: indexPath, model: model)
    }

    private var cancellables: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        bindViewModel()

        viewModel.viewDidLoad()
    }

    private func createCell(
        for indexPath: IndexPath, model: Model
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CityWeatherCell.reuseID,
            for: indexPath
        ) as! CityWeatherCell

        cell.configure(with: model)
        return cell
    }
}

private extension SearchCityViewController {
    func setupSubviews() {
        view.backgroundColor = .white
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true

        collectionView.layout(in: view) { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(16.0)
            make.top.equalTo(view.safeAreaLayoutGuide)
        }
        collectionView.register(
            CityWeatherCell.self,
            forCellWithReuseIdentifier: CityWeatherCell.reuseID
        )
    }

    func bindViewModel() {
        cancellables = []

        viewModel.title
            .map { $0 }
            .assign(to: \.title, on: self)
            .store(in: &cancellables)

        viewModel.searchController.sink { [weak self] controller in
            self?.navigationItem.searchController = controller
            controller.searchBar.delegate = self
        }.store(in: &cancellables)

        viewModel.setDataSource(dataSource)
    }
}

extension SearchCityViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didTapSearch()
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.didTapCancel()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.didUpdateText(with: searchText)
    }
}

private extension UICollectionViewCompositionalLayout {
    static var citiesList: UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(88.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8.0

        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 32.0

        let layout = UICollectionViewCompositionalLayout(
            section: section,
            configuration: config
        )
        return layout
    }
}
