//
//  ScrollableSegmentedControlCell.swift
//  AlphaWallet
//
//  Created by Jerome Chan on 27/12/21.
//

import UIKit

protocol ScrollableSegmentedControlCellDelegate: AnyObject {

    func didSelect(cell: ScrollableSegmentedControlCell, event: UIControl.Event)

}

struct ScrollableSegmentedControlCellConfiguration {

    let backgroundColor: UIColor
    let highlightedTextColor: UIColor
    let nonHighlightedTextColor: UIColor
    let highlightedFont: UIFont
    let nonHighlightedFont: UIFont
    let cellPadding: CGFloat
    let textBottomPadding: CGFloat

}

class ScrollableSegmentedControlCell: UIView {

    // MARK: - Properties
    // MARK: Private

    private let configuration: ScrollableSegmentedControlCellConfiguration
    private var cellHeightConstraint: NSLayoutConstraint?
    private var cellWidthConstraint: NSLayoutConstraint?
    private var title: String

    // MARK: Public

    var highlighted: Bool {
        didSet {
            setHighlighted(highlighted)
        }
    }
    var cellPadding: CGFloat
    var height: CGFloat {
        didSet {
            cellHeightConstraint?.constant = height
        }
    }
    var width: CGFloat {
        didSet {
            cellWidthConstraint?.constant = width
        }
    }
    var intrinsicWidth: CGFloat {
        let width = label.intrinsicContentSize.width + (2 * cellPadding)
        return width > 100 ? width : 100
    }
    var textColor: UIColor {
        get {
            label.textColor
        }
        set(newValue) {
            label.textColor = newValue
        }
    }

    // MARK: - UI Elements

    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        return label
    }()
    
    private lazy var backView: UIView = {
        let view = UIView()
        return view
    }()

    // MARK: - Delegates

    weak var delegate: ScrollableSegmentedControlCellDelegate?

    // MARK: - Constructors

    init(frame: CGRect, title: String, configuration: ScrollableSegmentedControlCellConfiguration) {
        self.height = frame.height
        self.width = frame.width
        self.cellPadding = configuration.cellPadding
        self.title = title
        self.highlighted = false
        self.configuration = configuration
        super.init(frame: frame)
        configureView(configuration: configuration)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        backView.layer.cornerRadius = 5
        backView.layer.masksToBounds = false
        backView.layer.shadowColor = UIColor.gray.cgColor
        backView.layer.shadowPath = UIBezierPath(roundedRect: backView.bounds, cornerRadius: backView.layer.cornerRadius).cgPath
        backView.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        backView.layer.shadowOpacity = 0.3
        backView.layer.shadowRadius = 2.0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - User interaction

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didSelect(cell: self, event: .touchUpInside)
    }

    // MARK: - Configuration

    private func configureView(configuration: ScrollableSegmentedControlCellConfiguration) {
        configureLabel(configuration: configuration)
        let heightConstraint = heightAnchor.constraint(equalToConstant: height)
        let widthConstraint = widthAnchor.constraint(equalToConstant: width)
        NSLayoutConstraint.activate([
            heightConstraint,
            widthConstraint,
        ])
        cellHeightConstraint = heightConstraint
        cellWidthConstraint = widthConstraint
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        //backgroundColor = configuration.backgroundColor
        backgroundColor = .clear
    }

    private func configureLabel(configuration: ScrollableSegmentedControlCellConfiguration) {
        label.text = title
        label.font = configuration.nonHighlightedFont
        label.textColor = configuration.highlightedTextColor
        addSubview(backView)
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -configuration.textBottomPadding)
        ])
        width = label.intrinsicContentSize.width + (2 * cellPadding)
        width = width > 100 ? width : 100
        height = label.intrinsicContentSize.height + (2 * cellPadding)
        
        var frame = backView.frame
        frame.size.width = width - 6
        frame.size.height = 44
        frame.origin.x = 3
        frame.origin.y = 3
        backView.frame = frame
    }

    // MARK: - Highlighted

    private func setHighlighted(_ state: Bool) {
        label.textColor = state ? configuration.highlightedTextColor : configuration.nonHighlightedTextColor
        label.font = state ? configuration.highlightedFont : configuration.nonHighlightedFont
        backView.backgroundColor = state ? configuration.backgroundColor : .white
    }

}
