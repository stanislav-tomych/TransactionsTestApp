//
//  RateView.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 05.01.2025.
//

import UIKit

class BitcoinRateView: UIView {
    private let bitcoinRateLabel: UILabel = {
        let label = UILabel()
        label.text = Localization.Transactions.bitcoinViewTitle
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    private let rateValueLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 18, weight: .regular)
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
        addSubview(bitcoinRateLabel)
        addSubview(rateValueLabel)

        bitcoinRateLabel.textAlignment = .right
        rateValueLabel.textAlignment = .right

        bitcoinRateLabel.translatesAutoresizingMaskIntoConstraints = false
        rateValueLabel.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bitcoinRateLabel.topAnchor.constraint(equalTo: topAnchor),
            bitcoinRateLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            bitcoinRateLabel.trailingAnchor.constraint(equalTo: trailingAnchor),

            rateValueLabel.topAnchor.constraint(equalTo: bitcoinRateLabel.bottomAnchor),
            rateValueLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            rateValueLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            rateValueLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }

    func updateRate(_ rate: String) {
        UIView.transition(with: rateValueLabel,
                          duration: Constants.animationLength,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
            guard let self else { return }
            rateValueLabel.text = rate
        }, completion: nil)
    }
    
    private enum Constants {
        static let animationLength = 0.3
    }
}
