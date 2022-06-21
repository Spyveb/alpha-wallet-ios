//
//  WalletSummaryView.swift
//  AlphaWallet
//
//  Created by Vladyslav Shepitko on 02.08.2021.
//

import UIKit
import Combine

class WalletSummaryView: UIView, ReusableTableHeaderViewType {
    private let apprecation24HoursLabel = UILabel()
    private let balanceLabel = UILabel()
    private var cancelable = Set<AnyCancellable>()

    init(edgeInsets: UIEdgeInsets = .init(top: 20, left: 20, bottom: 20, right: 0), spacing: CGFloat = 0) {
        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        apprecation24HoursLabel.lineBreakMode = .byTruncatingMiddle
        balanceLabel.textAlignment = .left
        apprecation24HoursLabel.textAlignment = .left

        let leftStackView = [
            balanceLabel,
            apprecation24HoursLabel,
        ].asStackView(axis: .vertical, spacing: spacing, alignment: .leading)

        let stackView = [[UILabel()].asStackView(), leftStackView, [UILabel()].asStackView()].asStackView(axis: .vertical, spacing: 20, alignment: .fill)
        stackView.translatesAutoresizingMaskIntoConstraints = false

        apprecation24HoursLabel.setContentHuggingPriority(.required, for: .horizontal)
        balanceLabel.setContentHuggingPriority(.required, for: .horizontal)

        stackView.setContentHuggingPriority(.required, for: .horizontal)

        addSubview(stackView)

        NSLayoutConstraint.activate([
            balanceLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            apprecation24HoursLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30),
            stackView.anchorsConstraintLessThanOrEqualTo(to: self, edgeInsets: edgeInsets),
            stackView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            stackView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0),
        ])
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
//
//            let window = UIApplication.shared.windows.first
//            let topPadding = window?.safeAreaInsets.top ?? 0
//
//            var frame = stackView.frame
//            frame.origin.y = -44 - topPadding
//            frame.size.height = frame.height + 44 + topPadding
//            self?.imgView.frame = frame
//        }
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    func configure(viewModel: WalletSummaryViewModel) {
        backgroundColor = .clear// viewModel.backgroundColor
        cancelable.cancellAll()

        viewModel.balanceAttributedString
            .sink { [weak balanceLabel] value in
                balanceLabel?.attributedText = value
            }.store(in: &cancelable)

        viewModel.apprecation24HoursAttributedString
            .sink { [weak apprecation24HoursLabel] value in
                apprecation24HoursLabel?.attributedText = value
            }.store(in: &cancelable)
    }
}

extension Set where Element: AnyCancellable {
    mutating func cancellAll() {
        for each in self {
            each.cancel()
        }

        removeAll()
    }
}
