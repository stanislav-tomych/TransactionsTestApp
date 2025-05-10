//
//  TransactionTableViewCell.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 06.01.2025.
//

import UIKit

final class TransactionTableViewCell: UITableViewCell {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .headline)
        label.numberOfLines = 1
        return label
    }()

    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .subheadline)
        label.textAlignment = .right
        return label
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .gray
        return label
    }()

    private let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 5
        return stack
    }()

    private let horizontalStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 5
        stack.distribution = .fill
        return stack
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(stackView)

        horizontalStack.addArrangedSubview(titleLabel)
        horizontalStack.addArrangedSubview(amountLabel)

        stackView.addArrangedSubview(horizontalStack)
        stackView.addArrangedSubview(dateLabel)

        stackView.translatesAutoresizingMaskIntoConstraints = false

        selectionStyle = .none
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }

    func configure(with transaction: Transaction, timeFormatter: DateFormatter) {
        titleLabel.text = transaction.type == .adjunction ? transaction.type.toString() : transaction.category.toString()
        amountLabel.text = "\(transaction.amount) BTC"
        amountLabel.textColor = transaction.type == .adjunction ? .black : .red
        dateLabel.text = timeFormatter.string(from: transaction.date)
    }
}
