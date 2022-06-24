// Copyright © 2018 Stormbird PTE. LTD.

import UIKit
import Combine

class AccountViewCell: UITableViewCell {
    private let addressLabel = UILabel()
    private let apprecation24hourLabel = UILabel()
    private let balanceLabel = UILabel()
    private let blockieImageView = BlockieImageView(size: .init(width: 58, height: 68))
    private let imgToken = UIImageView()
    private let background = RoundedBackground()
//    lazy private var selectedIndicator: UIView = {
//        let indicator = UIView()
//        indicator.layer.cornerRadius = Style.SelectionIndicator.width / 2.0
//        indicator.borderWidth = 0.0
//        indicator.backgroundColor = Style.SelectionIndicator.color
//        NSLayoutConstraint.activate([
//            indicator.widthAnchor.constraint(equalToConstant: Style.SelectionIndicator.width),
//            indicator.heightAnchor.constraint(equalToConstant: Style.SelectionIndicator.height)
//        ])
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        indicator.isHidden = true
//        return indicator
//    }()
    lazy private var selectedIndicator: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.image = UIImage(systemName: "checkmark.circle.fill")
        imgView.tintColor = R.color.azure()
        return imgView
    }()
    private let imgView: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.image = UIImage(named: "account_cell_bg")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()

    private var cancelable = Set<AnyCancellable>()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let screenSize = UIScreen.main.bounds.size
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorInset = .zero
        selectionStyle = .none
        isUserInteractionEnabled = true
        //background.frame = CGRect(x: 15, y: 5, width: screenSize.width - 30, height: 186)
        background.frame.size.width = screenSize.width - 30
        background.frame.size.height = 186
        addSubview(background)
        background.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.lineBreakMode = .byTruncatingMiddle
        addressLabel.frame.size.width = 120
        blockieImageView.frame = CGRect(x: 38, y: 60, width: 58, height: 68)
        imgToken.frame = CGRect(x: 38, y: 60, width: 58, height: 68)
        
        balanceLabel.textAlignment = .left
        apprecation24hourLabel.textAlignment = .right
//        setupHexagonImageView(blockieImageView)
        
        let row3 = UIView()
        //row3.translatesAutoresizingMaskIntoConstraints = false
        row3.addSubview(balanceLabel)
        row3.addSubview(apprecation24hourLabel)
        row3.backgroundColor = .clear
        row3.frame = CGRect(x: 42, y: 150, width: screenSize.width - 42 - 25, height: 22)
        balanceLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 22)
        apprecation24hourLabel.frame = CGRect(x: row3.frame.width - 140, y: 0, width: 130, height: 22)
        
        let stackView = [
            [UIView.spacerWidth(screenSize.width - 32 - 25 - 100), addressLabel].asStackView(),
            //blockieImageView,
            //[balanceLabel, UIView.spacerWidth(10, backgroundColor: .clear, alpha: 0, flexible: true), apprecation24hourLabel].asStackView(),
            //row3
        ].asStackView(axis: .vertical, alignment: .leading)

//        let stackView = [blockieImageView, leftStackView, .spacerWidth(10)].asStackView(spacing: 12, alignment: .top)
        
        //stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.frame = CGRect(x: 32, y: 20, width: screenSize.width - 32 - 25, height: 25)
        stackView.backgroundColor = .clear
        
        let frame = CGRect(x: 0, y: 0, width: 164, height: 186)
        imgView.frame = frame
        //stackView.frame.size.height = 196
        self.frame.size.height = 196
        selectedIndicator.frame = CGRect(x: screenSize.width - 75, y: (196/2) - 12, width: 24, height: 24)
        //background.addSubview(blockieImageView)
        background.addSubview(imgToken)
        background.addSubview(imgView)
        addSubview(stackView)
        addSubview(selectedIndicator)
        addSubview(row3)

        NSLayoutConstraint.activate([

//            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
//            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
//            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
//            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
//            selectedIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
//            selectedIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 35),
            background.anchorsConstraint(to: self, edgeInsets: .init(top: 5, left: 15, bottom: 5, right: 15)),
            background.heightAnchor.constraint(equalToConstant: 186)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        background.layer.cornerRadius = 8
        background.layer.masksToBounds = false
        background.layer.shadowColor = UIColor.gray.cgColor
        background.layer.shadowPath = UIBezierPath(roundedRect: background.bounds, cornerRadius: background.layer.cornerRadius).cgPath
        background.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        background.layer.shadowOpacity = 0.4
        background.layer.shadowRadius = 3.0
    }

    func configure(viewModel: AccountViewModel) {
        cancelable.cancellAll()

        backgroundColor = viewModel.backgroundColor
        let imageView = UIImageView(image: R.image.moreVertical())
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalToConstant: 24.0),
            imageView.heightAnchor.constraint(equalToConstant: 24.0)
        ])
        accessoryView = imageView //Style.AccessoryView.chevron
        selectedIndicator.isHidden = !viewModel.isSelected

        viewModel.addressesAttrinutedString
            .sink { [weak addressLabel] value in
                addressLabel?.attributedText = value
            }.store(in: &cancelable)

        viewModel.blockieImage
            .sink { [weak imgToken, weak blockieImageView] image in
                blockieImageView?.setBlockieImage(image: image)
                //blockieImageView?.frame = CGRect(x: 38, y: 56, width: 58, height: 68)
                imgToken?.image = blockieImageView?.imageView.imageView.image
            }.store(in: &cancelable)

        viewModel.balance
            .sink { [weak balanceLabel] value in
                balanceLabel?.attributedText = value
            }.store(in: &cancelable)

        viewModel.apprecation24hour
            .sink { [weak apprecation24hourLabel] value in
                apprecation24hourLabel?.attributedText = value
            }.store(in: &cancelable)
    }
}
