//
//  BalanceView.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 06.01.2025.
//

import UIKit

final class BalanceView: UIView {
    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "0.00 BTC"
        return label
    }()

    private let addBalanceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .systemBlue
        return button
    }()

    private let addTransactionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localization.Transactions.addTransaction, for: .normal)
        return button
    }()

    var onAddBalanceTapped: (() -> Void)?
    var onAddTransactionTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupActions()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        addSubview(balanceLabel)
        addSubview(addBalanceButton)
        addSubview(addTransactionButton)

        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        addBalanceButton.translatesAutoresizingMaskIntoConstraints = false
        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: topAnchor),
            balanceLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            addBalanceButton.centerYAnchor.constraint(equalTo: balanceLabel.centerYAnchor),
            addBalanceButton.leadingAnchor.constraint(equalTo: balanceLabel.trailingAnchor, constant: 8),

            addTransactionButton.topAnchor.constraint(equalTo: addBalanceButton.bottomAnchor, constant: 16),
            addTransactionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            addTransactionButton.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupActions() {
        addBalanceButton.addTarget(self, action: #selector(addBalanceButtonTapped), for: .touchUpInside)
        addTransactionButton.addTarget(self, action: #selector(addTransactionButtonTapped), for: .touchUpInside)
    }

    @objc private func addBalanceButtonTapped() {
        onAddBalanceTapped?()
    }

    @objc private func addTransactionButtonTapped() {
        onAddTransactionTapped?()
    }

    func updateBalance(_ balance: Double) {
        UIView.transition(with: balanceLabel, duration: Constants.animationLength, options: .transitionCrossDissolve, animations: {
            self.balanceLabel.text = String(format: "%.4f BTC", balance)
        }, completion: nil)
    }
    
    private enum Constants {
        static let animationLength = 0.3
    }
}
