// Copyright © 2018 Stormbird PTE. LTD.

import UIKit
import Combine

class AccountViewCell: UITableViewCell {
    private let addressLabel = UILabel()
    private let apprecation24hourLabel = UILabel()
    private let balanceLabel = UILabel()
    private let blockieImageView = BlockieImageView(size: .init(width: 60, height: 60))
    lazy private var selectedIndicator: UIView = {
        let indicator = UIView()
        indicator.layer.cornerRadius = Style.SelectionIndicator.width / 2.0
        indicator.borderWidth = 0.0
        indicator.backgroundColor = Style.SelectionIndicator.color
        NSLayoutConstraint.activate([
            indicator.widthAnchor.constraint(equalToConstant: Style.SelectionIndicator.width),
            indicator.heightAnchor.constraint(equalToConstant: Style.SelectionIndicator.height)
        ])
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        return indicator
    }()
    private let imgView: UIImageView = {
        let imgView = UIImageView(frame: .zero)
        imgView.image = UIImage(named: "account_cell_bg")
        imgView.contentMode = .scaleAspectFill
        return imgView
    }()

    private var cancelable = Set<AnyCancellable>()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        separatorInset = .zero
        selectionStyle = .none
        isUserInteractionEnabled = true
        addressLabel.lineBreakMode = .byTruncatingMiddle
        addressLabel.frame.size.width = 120
        blockieImageView.frame.origin.x = 53
//        setupHexagonImageView(blockieImageView)

        let stackView = [
            [UILabel(), addressLabel].asStackView(spacing: 80, alignment: .trailing),
            [blockieImageView].asStackView(spacing: 10),
            [balanceLabel, UILabel(), apprecation24hourLabel].asStackView(spacing: 10),
            
        ].asStackView(axis: .vertical, spacing: 20, alignment: .leading)

//        let stackView = [blockieImageView, leftStackView, .spacerWidth(10)].asStackView(spacing: 12, alignment: .top)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .clear
        
        let frame = CGRect(x: 0, y: 0, width: 164, height: 186)
        imgView.frame = frame
        stackView.frame.size.height = 186
        contentView.addSubview(imgView)
        contentView.addSubview(stackView)
        contentView.addSubview(selectedIndicator)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -25),
            selectedIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectedIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Style.SelectionIndicator.leadingOffset)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        return nil
    }

    func configure(viewModel: AccountViewModel) {
        cancelable.cancellAll()

        backgroundColor = viewModel.backgroundColor
        accessoryView = Style.AccessoryView.chevron
        selectedIndicator.isHidden = !viewModel.isSelected

        viewModel.addressesAttrinutedString
            .sink { [weak addressLabel] value in
                addressLabel?.attributedText = value
            }.store(in: &cancelable)

        viewModel.blockieImage
            .sink { [weak blockieImageView] image in
                blockieImageView?.setBlockieImage(image: image)
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
    
    func setupHexagonImageView(_ imageView: BlockieImageView) {
        let lineWidth: CGFloat = 0
        let path = roundedPolygonPath(rect: imageView.bounds, lineWidth: lineWidth, sides: 6, cornerRadius: 10, rotationOffset: CGFloat(Double.pi / 2.0))

        let mask = CAShapeLayer()
        mask.path = path.cgPath
        mask.lineWidth = lineWidth
        mask.strokeColor = UIColor.clear.cgColor
        mask.fillColor = UIColor.clear.cgColor
        imageView.layer.mask = mask

        let border = CAShapeLayer()
        border.path = path.cgPath
        border.lineWidth = lineWidth
        border.strokeColor = UIColor.clear.cgColor
        border.fillColor = UIColor.clear.cgColor
        imageView.layer.addSublayer(border)
    }
    
    @objc func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0)
    -> UIBezierPath {
        let path = UIBezierPath()
        let theta: CGFloat = CGFloat(2.0 * Double.pi) / CGFloat(sides) // How much to turn at every corner
        let _: CGFloat = cornerRadius * tan(theta / 2.0)     // Offset from which to start rounding corners
        let width = min(rect.size.width, rect.size.height)        // Width of the square
        
        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
        
        // Radius of the circle that encircles the polygon
        // Notice that the radius is adjusted for the corners, that way the largest outer
        // dimension of the resulting shape is always exactly the width - linewidth
        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
        
        // Start drawing at a point, which by default is at the right hand edge
        // but can be offset
        var angle = CGFloat(rotationOffset)
        
        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
        path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))
        
        for _ in 0 ..< sides {
            angle += theta
            
            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
            let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
            
            path.addLine(to: start)
            path.addQuadCurve(to: end, controlPoint: tip)
        }
        
        path.close()
        
        // Move the path to the correct origins
        let bounds = path.bounds
        let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0,
                                          y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
        path.apply(transform)
        
        return path
    }
}

//extension UIView {
//
//    /// Set the view layer as an hexagon
//    func setupHexagonView() {
//        let lineWidth: CGFloat = 5
//        let path = self.roundedPolygonPath(rect: self.bounds, lineWidth: lineWidth, sides: 6, cornerRadius: 10, rotationOffset: CGFloat(.pi / 2.0))
//
//        let mask = CAShapeLayer()
//        mask.path = path.cgPath
//        mask.lineWidth = lineWidth
//        mask.strokeColor = UIColor.clear.cgColor
//        mask.fillColor = UIColor.white.cgColor
//        self.layer.mask = mask
//
//        let border = CAShapeLayer()
//        border.path = path.cgPath
//        border.lineWidth = lineWidth
//        border.strokeColor = UIColor.white.cgColor
//        border.fillColor = UIColor.clear.cgColor
//        self.layer.addSublayer(border)
//    }
//
//    /// Makes a bezier path which can be used for a rounded polygon
//    /// layer
//    ///
//    /// - Parameters:
//    ///   - rect: uiview rect bounds
//    ///   - lineWidth: width border line
//    ///   - sides: number of polygon's sides
//    ///   - cornerRadius: radius for corners
//    ///   - rotationOffset: offset of rotation of the view
//    /// - Returns: the newly created bezier path for layer mask
//    public func roundedPolygonPath(rect: CGRect, lineWidth: CGFloat, sides: NSInteger, cornerRadius: CGFloat, rotationOffset: CGFloat = 0) -> UIBezierPath {
//        let path = UIBezierPath()
//        let theta: CGFloat = CGFloat(2.0 * .pi) / CGFloat(sides) // How much to turn at every corner
//        let width = min(rect.size.width, rect.size.height)        // Width of the square
//
//        let center = CGPoint(x: rect.origin.x + width / 2.0, y: rect.origin.y + width / 2.0)
//
//        // Radius of the circle that encircles the polygon
//        // Notice that the radius is adjusted for the corners, that way the largest outer
//        // dimension of the resulting shape is always exactly the width - linewidth
//        let radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0
//
//        // Start drawing at a point, which by default is at the right hand edge
//        // but can be offset
//        var angle = CGFloat(rotationOffset)
//
//        let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
//        path.move(to: CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta)))
//
//        for _ in 0..<sides {
//            angle += theta
//
//            let corner = CGPoint(x: center.x + (radius - cornerRadius) * cos(angle), y: center.y + (radius - cornerRadius) * sin(angle))
//            let tip = CGPoint(x: center.x + radius * cos(angle), y: center.y + radius * sin(angle))
//            let start = CGPoint(x: corner.x + cornerRadius * cos(angle - theta), y: corner.y + cornerRadius * sin(angle - theta))
//            let end = CGPoint(x: corner.x + cornerRadius * cos(angle + theta), y: corner.y + cornerRadius * sin(angle + theta))
//
//            path.addLine(to: start)
//            path.addQuadCurve(to: end, controlPoint: tip)
//        }
//
//        path.close()
//
//        // Move the path to the correct origins
//        let bounds = path.bounds
//        let transform = CGAffineTransform(translationX: -bounds.origin.x + rect.origin.x + lineWidth / 2.0, y: -bounds.origin.y + rect.origin.y + lineWidth / 2.0)
//        path.apply(transform)
//
//        return path
//    }
//}
