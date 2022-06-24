//
//  ShowSeedPhraseIntroductionViewController.swift
//  AlphaWallet
//
//  Created by Vladyslav Shepitko on 03.03.2021.
//

import UIKit

protocol ShowSeedPhraseIntroductionViewControllerDelegate: AnyObject {
    func didShowSeedPhrase(in viewController: ShowSeedPhraseIntroductionViewController)
    func didClose(in viewController: ShowSeedPhraseIntroductionViewController)
}

class ShowSeedPhraseIntroductionViewController: UIViewController {

    private var viewModel = ShowSeedPhraseIntroductionViewModel()
    private let subtitleLabel = UILabel()
    private let imageView = UIImageView()
    private let descriptionLabel1 = UILabel()
    private let buttonsBar = HorizontalButtonsBar(configuration: .primary(buttons: 1))
    private let roundedBackground = RoundedBackground()

    private var imageViewDimension: CGFloat {
        return ScreenChecker.size(big: 250, medium: 250, small: 250)
    }

    weak var delegate: ShowSeedPhraseIntroductionViewControllerDelegate?

    init() {
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

        let footerBar = ButtonsBarBackgroundView(buttonsBar: buttonsBar, separatorHeight: 0.0)

//        let container = UIView()
//        container.translatesAutoresizingMaskIntoConstraints = false
//        container.addSubview(stackView)
        
//        view.addSubview(container)
//        view.addSubview(footerBar)
        roundedBackground.addSubview(stackView)
        roundedBackground.addSubview(footerBar)

//        NSLayoutConstraint.activate([
//            imageView.heightAnchor.constraint(equalToConstant: imageViewDimension),
//
//            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 16),
//            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16),
//            stackView.topAnchor.constraint(equalTo: container.safeAreaLayoutGuide.topAnchor, constant: 16),
//
//            container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            container.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            container.bottomAnchor.constraint(equalTo: footerBar.topAnchor),
//
//            footerBar.anchorsConstraint(to: view)
//        ])
        
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
            footerBar.bottomAnchor.constraint(lessThanOrEqualTo: roundedBackground.bottomAnchor).set(priority: .required),
            footerBar.topAnchor.constraint(equalTo: buttonsBar.topAnchor),
            
        ] + roundedBackground.anchorsConstraint(to: view, edgeInsets: .init(top: 15, left: 15, bottom: 15 + bottomPadding, right: 15)))
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent || isBeingDismissed {
            delegate?.didClose(in: self)
            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        view.backgroundColor = Colors.appBackground

        subtitleLabel.numberOfLines = 0
        subtitleLabel.attributedText = viewModel.attributedSubtitle

        imageView.image = viewModel.imageViewImage

        descriptionLabel1.numberOfLines = 0
        descriptionLabel1.attributedText = viewModel.attributedDescription

        buttonsBar.configure()
        let showSeedPhraseButton = buttonsBar.buttons[0]
        showSeedPhraseButton.setTitle(viewModel.title, for: .normal)
        showSeedPhraseButton.addTarget(self, action: #selector(showSeedPhraseSelected), for: .touchUpInside)
    }

    @objc private func showSeedPhraseSelected() {
        delegate?.didShowSeedPhrase(in: self)
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
