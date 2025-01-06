//
//  TransactionsSectionHeader.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 06.01.2025.
//

import UIKit

final class TransactionsSectionHeader: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemGray6
        addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.spacing),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.spacing),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    func configure(with title: String) {
        titleLabel.text = title
    }
    
    private enum Constants {
        static let spacing = 16.0
    }
}
