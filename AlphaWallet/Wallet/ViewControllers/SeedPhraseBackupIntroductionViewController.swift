// Copyright © 2019 Stormbird PTE. LTD.

import UIKit

protocol SeedPhraseBackupIntroductionViewControllerDelegate: AnyObject {
    func didTapBackupWallet(inViewController viewController: SeedPhraseBackupIntroductionViewController)
    func didClose(for account: AlphaWallet.Address, inViewController viewController: SeedPhraseBackupIntroductionViewController)
}

class SeedPhraseBackupIntroductionViewController: UIViewController {
    private var viewModel = SeedPhraseBackupIntroductionViewModel()
    private let account: AlphaWallet.Address
    private let roundedBackground = RoundedBackground()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    // NOTE: internal level, for test cases
    let descriptionLabel1 = UILabel()
    let buttonsBar = HorizontalButtonsBar(configuration: .primary(buttons: 1))

    private var imageViewDimension: CGFloat {
        return ScreenChecker.size(big: 250, medium: 250, small: 220)
    }

    weak var delegate: SeedPhraseBackupIntroductionViewControllerDelegate?

    init(account: AlphaWallet.Address) {
        self.account = account
        super.init(nibName: nil, bundle: nil)

        hidesBottomBarWhenPushed = true

        roundedBackground.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(roundedBackground)

        imageView.contentMode = .scaleAspectFit

        let stackView = [
            UIView.spacer(height: ScreenChecker.size(big: 32, medium: 22, small: 18)),
            imageView,
            UIView.spacer(height: ScreenChecker.size(big: 24, medium: 20, small: 18)),
            subtitleLabel,
            UIView.spacer(height: ScreenChecker.size(big: 17, medium: 15, small: 10)),
            descriptionLabel1,
            ].asStackView(axis: .vertical)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        roundedBackground.addSubview(stackView)

        let footerBar = UIView()
        footerBar.translatesAutoresizingMaskIntoConstraints = false
        footerBar.backgroundColor = .clear
        roundedBackground.addSubview(footerBar)

        buttonsBar.cornerRadius = 4
        footerBar.addSubview(buttonsBar)

        let window = UIApplication.shared.windows.first
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: imageViewDimension),

            stackView.leadingAnchor.constraint(equalTo: roundedBackground.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: roundedBackground.trailingAnchor, constant: -5),
            stackView.topAnchor.constraint(equalTo: roundedBackground.topAnchor),
            stackView.bottomAnchor.constraint(lessThanOrEqualTo: footerBar.topAnchor),

            buttonsBar.leadingAnchor.constraint(equalTo: footerBar.leadingAnchor),
            buttonsBar.trailingAnchor.constraint(equalTo: footerBar.trailingAnchor),
            buttonsBar.bottomAnchor.constraint(equalTo: footerBar.bottomAnchor),
            buttonsBar.heightAnchor.constraint(equalToConstant: HorizontalButtonsBar.buttonsHeight),

            footerBar.leadingAnchor.constraint(equalTo: roundedBackground.leadingAnchor, constant: 10),
            footerBar.trailingAnchor.constraint(equalTo: roundedBackground.trailingAnchor, constant: -10),
            footerBar.bottomAnchor.constraint(equalTo: roundedBackground.bottomAnchor).set(priority: .defaultHigh),
            footerBar.bottomAnchor.constraint(lessThanOrEqualTo: roundedBackground.bottomAnchor, constant: -15).set(priority: .required),
            footerBar.topAnchor.constraint(equalTo: buttonsBar.topAnchor),
            
        ] + roundedBackground.anchorsConstraint(to: view, edgeInsets: .init(top: 15, left: 15, bottom: 15 + bottomPadding, right: 15)))
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBarTopSeparatorLine()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        showNavigationBarTopSeparatorLine()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent || isBeingDismissed {
            delegate?.didClose(for: account, inViewController: self)
            return
        }
    }

    func configure() {
        view.backgroundColor = Colors.appBackground

        subtitleLabel.numberOfLines = 0
        subtitleLabel.attributedText = viewModel.attributedSubtitle

        imageView.image = viewModel.imageViewImage

        descriptionLabel1.numberOfLines = 0
        descriptionLabel1.attributedText = viewModel.attributedDescription

        buttonsBar.configure()
        let exportButton = buttonsBar.buttons[0]
        exportButton.setTitle(viewModel.title, for: .normal)
        exportButton.addTarget(self, action: #selector(tappedExportButton), for: .touchUpInside)
    }

    @objc private func tappedExportButton() {
        delegate?.didTapBackupWallet(inViewController: self)
    }
    
    override func viewWillLayoutSubviews() {
        super.view.layoutSubviews()
        
        let background = roundedBackground
        background.layer.cornerRadius = 16
        background.layer.masksToBounds = false
        background.layer.shadowColor = UIColor.gray.cgColor
        background.layer.shadowPath = UIBezierPath(roundedRect: background.bounds, cornerRadius: background.layer.cornerRadius).cgPath
        background.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        background.layer.shadowOpacity = 0.5
        background.layer.shadowRadius = 4.0
    }
}
