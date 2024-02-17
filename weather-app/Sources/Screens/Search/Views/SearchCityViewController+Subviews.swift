//
// © 2024 Test weather-app
//

import UIKit

extension SearchCityViewController {
    final class CityWeatherCell: UICollectionViewCell {
        static var reuseID: String {
            .init(describing: self)
        }

        private let titleLabel = UILabel()
        private let subtitleLabel = UILabel()
        private let descriptionLabel = UILabel()
        private let rangeLabel = UILabel()
        private let temperatureLabel = UILabel()

        private lazy var contentStack = {
            let stackView = UIStackView(
                arrangedSubviews: [
                    leftStack,
                    rightStack
                ]
            )
            stackView.spacing = 8.0
            return stackView
        }()

        private lazy var leftStack = {
            let flexible = UIView()
            flexible.setContentHuggingPriority(.defaultLow, for: .vertical)
            flexible.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

            let stackView = UIStackView(
                arrangedSubviews: [
                    titleLabel,
                    subtitleLabel,
                    flexible,
                    descriptionLabel
                ]
            )
            stackView.axis = .vertical
            return stackView
        }()

        private lazy var rightStack = {
            let flexible = UIView()
            flexible.setContentHuggingPriority(.defaultLow, for: .vertical)
            flexible.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

            let stackView = UIStackView(
                arrangedSubviews: [
                    temperatureLabel,
                    flexible,
                    rangeLabel
                ]
            )
            stackView.axis = .vertical
            return stackView
        }()

        override init(frame: CGRect) {
            super.init(frame: frame)

            setup()
        }
        
        @available(*, unavailable)
        required init?(coder: NSCoder) {
            fatalError()
        }

        func configure(with model: Model) {
            titleLabel.text = model.title
            subtitleLabel.text = model.subtitle
            descriptionLabel.text = model.weatherDesription
            rangeLabel.text = model.temperatureRangeString
            temperatureLabel.text = model.temperatureString

            contentView.backgroundColor = model.color
        }

        private func setup() {
            contentStack.fill(
                in: contentView,
                insets: .init(top: 12, left: 12, bottom: 12, right: 12)
            )
            contentView.layer.cornerRadius = 16.0
            contentView.layer.cornerCurve = .continuous

            titleLabel.font = .boldSystemFont(ofSize: 18)
            subtitleLabel.font = .systemFont(ofSize: 12)
            subtitleLabel.textColor = .gray

            descriptionLabel.font = .systemFont(ofSize: 12)
            descriptionLabel.textColor = .gray

            temperatureLabel.font = .systemFont(ofSize: 27)
            temperatureLabel.textAlignment = .right

            rangeLabel.textAlignment = .right
            rangeLabel.font = .systemFont(ofSize: 12)
            rangeLabel.textColor = .white
        }
    }
}
