//
//  EventCell.swift
//  Eventos
//
//  Created by André Felipe de Sousa Almeida - AAD on 06/04/22.
//

import Foundation
import UIKit

class EventCell: UITableViewCell {

    static let reuseId = "EventCell"
    static let rowHeight: CGFloat = 150

    private lazy var peopleCountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.adjustsFontForContentSizeCategory = true
        label.text = "Inscritos: 0"
        return label
    }()

    private lazy var underlineView: UIView = {
        let underlineView = UIView(frame: .zero)
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.backgroundColor = .systemPink
        return underlineView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .title2)
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = .zero
        label.text = "Título do Evento"
        return label
    }()

    private lazy var priceLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .right
        label.adjustsFontForContentSizeCategory = true
        label.text = "Preço"
        return label
    }()

    private lazy var priceAmmountLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textAlignment = .right
        label.text = "R$ 50,00"
        return label
    }()

    private lazy var stackLabel: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = .zero
        stack.addArrangedSubview(priceLabel)
        stack.addArrangedSubview(priceAmmountLabel)
        return stack
    }()

    private lazy var chavronImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "chevron.right")?.withTintColor(.systemPink,
                                                                              renderingMode: .alwaysOriginal)
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EventCell {
    private func layout() {
        contentView.addSubview(peopleCountLabel)
        NSLayoutConstraint.activate([
            peopleCountLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            peopleCountLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2)
        ])

        contentView.addSubview(underlineView)
        NSLayoutConstraint.activate([
            underlineView.topAnchor.constraint(equalToSystemSpacingBelow: peopleCountLabel.bottomAnchor, multiplier: 1),
            underlineView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            underlineView.widthAnchor.constraint(equalToConstant: 60),
            underlineView.heightAnchor.constraint(equalToConstant: 4)
        ])

        contentView.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalToSystemSpacingBelow: underlineView.bottomAnchor, multiplier: 2),
            titleLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            titleLabel.widthAnchor.constraint(equalToConstant: 250)
        ])

        contentView.addSubview(stackLabel)
        NSLayoutConstraint.activate([
            stackLabel.topAnchor.constraint(equalToSystemSpacingBelow: underlineView.bottomAnchor, multiplier: 0),
            stackLabel.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 4),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackLabel.trailingAnchor, multiplier: 4)
        ])

        contentView.addSubview(chavronImageView)
        NSLayoutConstraint.activate([
            chavronImageView.topAnchor.constraint(equalToSystemSpacingBelow: underlineView.bottomAnchor, multiplier: 0),
            trailingAnchor.constraint(equalToSystemSpacingAfter: chavronImageView.trailingAnchor, multiplier: 1)
        ])
    }
}

extension EventCell {
    func configure(with event: Event) {
        peopleCountLabel.text = "Inscritos: \(event.people.count)"
        titleLabel.text = event.title
        priceAmmountLabel.text = event.price.currencyFormat
    }
}
