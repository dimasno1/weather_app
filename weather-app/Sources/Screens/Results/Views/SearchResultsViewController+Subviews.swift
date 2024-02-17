//
// © 2024 Test weather-app
//

import UIKit

extension SearchResultsViewController {
    final class WeatherCell: UITableViewCell {
        static var reuseID: String {
            .init(describing: self)
        }

        private let titleLabel = UILabel()

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)

            setup()
        }

        required init?(coder: NSCoder) {
            super.init(coder: coder)

            setup()
        }

        func configure(with text: NSAttributedString) {
            titleLabel.attributedText = text
        }

        private func setup() {
            titleLabel.textColor = .black
            titleLabel.font = .systemFont(ofSize: 15)
            titleLabel.fill(in: contentView, insets: .init(top: 0, left: 24, bottom: 0, right: 24))
            titleLabel.textAlignment = .left
        }
    }
}
