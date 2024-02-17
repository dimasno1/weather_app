//
// © 2024 Test weather-app
//

import UIKit
import SnapKit

extension UIView {
    func layout(in superview: UIView, constraints: (ConstraintMaker) -> Void) {
        self.removeFromSuperview()

        superview.addSubview(self)
        self.snp.makeConstraints(constraints)
    }

    func fill(in superview: UIView, insets: UIEdgeInsets = .zero) {
        self.layout(in: superview) { make in
            make.edges.equalToSuperview().inset(insets)
        }
    }
}
