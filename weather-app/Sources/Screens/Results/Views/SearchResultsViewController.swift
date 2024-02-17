//
// © 2024 Test weather-app
//

import UIKit
import Combine
import SnapKit

protocol SearchResultsViewModelType {
    typealias Model = SearchResultsViewController.Model
    typealias DataSource = SearchResultsViewController.DataSource

    func didSelectOption(at index: Int)

    func setDataSource(_ dataSource: DataSource)
}

extension SearchResultsViewController {
    struct Model: Hashable {
        let id: String
        let attributedText: NSAttributedString
    }
}

final class SearchResultsViewController: UIViewController {
    typealias DataSource = UITableViewDiffableDataSource<Int, Model>

    var viewModel: SearchResultsViewModelType!

    private var cancellables: Set<AnyCancellable> = []
    private let tableView = UITableView(
        frame: .zero,
        style: .plain
    )

    private lazy var dataSource = DataSource(
        tableView: tableView
    ) { [weak self] tableView, indexPath, model in
        self?.createCell(for: indexPath, model: model)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        bindViewModel()
    }

    private func createCell(
        for indexPath: IndexPath, model: Model
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: WeatherCell.reuseID,
            for: indexPath
        ) as! WeatherCell

        cell.configure(with: model.attributedText)
        return cell
    }
}

private extension SearchResultsViewController {
    func setupSubviews() {
        view.backgroundColor = .white

        tableView.register(
            WeatherCell.self,
            forCellReuseIdentifier: WeatherCell.reuseID
        )
        tableView.layout(in: view) { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.rowHeight = 56.0
    }

    func bindViewModel() {
        viewModel.setDataSource(dataSource)
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        viewModel.didSelectOption(at: indexPath.row)
    }
}
