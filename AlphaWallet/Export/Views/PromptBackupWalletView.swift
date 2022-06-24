// Copyright © 2019 Stormbird PTE. LTD.

import Foundation
import UIKit

protocol PromptBackupWalletViewDelegate: AnyObject {
    func viewControllerToShowBackupLaterAlert(forView view: PromptBackupWalletView) -> UIViewController?
    func didChooseBackupLater(inView view: PromptBackupWalletView)
    func didChooseBackup(inView view: PromptBackupWalletView)
}

class PromptBackupWalletView: UIView {
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let backupButton = UIButton(type: .system)
    private let remindMeLaterButton = UIButton(type: .system)
    private let viewModel: PromptBackupWalletViewModel
    private let imgView: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.image = UIImage(named: "wallet-backup")
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()

    weak var delegate: PromptBackupWalletViewDelegate?

    init(viewModel: PromptBackupWalletViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)

        backupButton.addTarget(self, action: #selector(backup), for: .touchUpInside)
        backupButton.setContentHuggingPriority(.required, for: .horizontal)

        remindMeLaterButton.addTarget(self, action: #selector(remindMeLater), for: .touchUpInside)
        remindMeLaterButton.setContentHuggingPriority(.required, for: .horizontal)

        let row0 = [titleLabel, remindMeLaterButton].asStackView(axis: .horizontal)
        let stackView1 = [
            row0,
            //UIView.spacer(height: 10),
            descriptionLabel,
            UIView.spacer(height: 4),
            backupButton,
        ].asStackView(axis: .vertical, alignment: .leading)
        //stackView1.translatesAutoresizingMaskIntoConstraints = false
        
        imgView.frame.size.width = min(self.frame.width * 0.24, 90)
        
        let stackView = [
            imgView,
            stackView1
        ].asStackView(axis: .horizontal, distribution: .fillProportionally, spacing: 8, alignment: .center)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)

        NSLayoutConstraint.activate([
            row0.widthAnchor.constraint(equalTo: stackView1.widthAnchor),

            descriptionLabel.widthAnchor.constraint(equalTo: backupButton.widthAnchor, constant: 5),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure() {
        backgroundColor = .white //viewModel.backgroundColor
        cornerRadius = viewModel.cornerRadius

        titleLabel.numberOfLines = 2
        titleLabel.font = viewModel.titleFont
        titleLabel.textColor = R.color.azure() //viewModel.titleColor
        titleLabel.text = viewModel.title
        //For small screens
        //titleLabel.adjustsFontSizeToFitWidth = true

        remindMeLaterButton.setImage(viewModel.moreButtonImage, for: .normal)
        remindMeLaterButton.tintColor = R.color.azure() //viewModel.moreButtonColor

        descriptionLabel.font = viewModel.descriptionFont
        descriptionLabel.textColor = R.color.azure() //viewModel.descriptionColor
        descriptionLabel.text = viewModel.description
        descriptionLabel.numberOfLines = 0

        backupButton.tintColor = R.color.azure() //viewModel.backupButtonTitleColor
        backupButton.titleLabel?.font = viewModel.backupButtonTitleFont
        backupButton.setBackgroundColor(R.color.azure()!, forState: .normal)//viewModel.backupButtonBackgroundColor, forState: .normal)
        backupButton.setTitleColor(viewModel.backupButtonTitleColor, for: .normal)
        backupButton.setTitle(viewModel.backupButtonTitle, for: .normal)
        //backupButton.setImage(viewModel.backupButtonImage, for: .normal)
        backupButton.contentEdgeInsets = viewModel.backupButtonContentEdgeInsets
        swapButtonTextAndImage(backupButton)
    }

    @objc private func backup() {
        delegate?.didChooseBackup(inView: self)
    }

    @objc private func remindMeLater() {
        delegate?.viewControllerToShowBackupLaterAlert(forView: self)?.confirm(message: R.string.localizable.backupPromptBackupRemindLater()) { result in
            switch result {
            case .success:
                self.delegate?.didChooseBackupLater(inView: self)
            case .failure:
                break
            }
        }
    }

    private func swapButtonTextAndImage(_ button: UIButton) {
        button.titleLabel?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.imageView?.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
        button.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
    }
}
