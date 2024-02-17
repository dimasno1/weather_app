//
// © 2024 Test weather-app
//

import UIKit
import Combine

protocol WeatherDetailsViewModelType {
    var cityName: AnyPublisher<String, Never> { get }
    var temperatureString: AnyPublisher<String, Never> { get }
    var temperatureColor: AnyPublisher<UIColor, Never> { get }
    var description: AnyPublisher<String, Never> { get }
    var rangeDescription: AnyPublisher<String, Never> { get }
    var backgroundColor: AnyPublisher<UIColor, Never> { get }
    var icon: AnyPublisher<UIImage?, Never> { get }

    var actionsHidden: AnyPublisher<Bool, Never> { get }

    func didTapAdd()
    func didTapCancel()

    func viewDidLoad()
}

final class WeatherDetailsViewController: UIViewController {
    var viewModel: WeatherDetailsViewModelType!

    private var cancellables: Set<AnyCancellable> = []

    private let dayNightBackgroundView = UIView()
    private let nameLabel = UILabel()
    private let temperatureLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let rangeLabel = UILabel()
    private let iconImageView = UIImageView()

    private lazy var labelsStack = {
        let stack = UIStackView(
            arrangedSubviews: [
                nameLabel,
                temperatureLabel,
                descriptionLabel,
                rangeLabel
            ]
        )
        stack.axis = .vertical
        stack.alignment = .center
        stack.spacing = 10
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
        bindViewModel()

        viewModel.viewDidLoad()
    }
}

private extension WeatherDetailsViewController {
    func bindViewModel() {
        viewModel.cityName
            .map { $0 }
            .assign(to: \.text, on: nameLabel)
            .store(in: &cancellables)

        viewModel.temperatureString
            .map { $0 }
            .assign(to: \.text, on: temperatureLabel)
            .store(in: &cancellables)

        viewModel.temperatureColor
            .map { $0 }
            .assign(to: \.textColor, on: temperatureLabel)
            .store(in: &cancellables)

        viewModel.description
            .map { $0 }
            .assign(to: \.text, on: descriptionLabel)
            .store(in: &cancellables)

        viewModel.rangeDescription
            .map { $0 }
            .assign(to: \.text, on: rangeLabel)
            .store(in: &cancellables)

        viewModel.icon
            .assign(to: \.image, on: iconImageView)
            .store(in: &cancellables)

        viewModel.backgroundColor
            .map { $0 }
            .assign(to: \.backgroundColor, on: dayNightBackgroundView)
            .store(in: &cancellables)
    }

    func setupSubviews() {
        view.backgroundColor = .white
        dayNightBackgroundView.fill(in: view)

        nameLabel.font = .boldSystemFont(ofSize: 30)
        nameLabel.textColor = .white
        temperatureLabel.font = .systemFont(ofSize: 65)
        temperatureLabel .textColor = .white
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel .textColor = .white
        rangeLabel.font = .systemFont(ofSize: 16)
        rangeLabel.textColor = .white

        iconImageView.contentMode = .scaleAspectFit
        iconImageView.layout(in: view) { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(100)
            make.width.height.equalTo(100)
        }
        labelsStack.layout(in: view) { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}
