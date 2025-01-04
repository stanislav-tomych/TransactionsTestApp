//
//  TransactionsViewController.swift
//  TransactionsTestTask
//
//

import UIKit

class TransactionsViewController: UIViewController {

    private let balanceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.text = "0.00 BTC"
        return label
    }()

    private let addBalanceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add BTC", for: .normal)
        return button
    }()

    private let addTransactionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Transaction", for: .normal)
        return button
    }()

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        view.addSubview(balanceLabel)
        view.addSubview(addBalanceButton)
        view.addSubview(addTransactionButton)
        view.addSubview(tableView)

        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupConstraints() {
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        addBalanceButton.translatesAutoresizingMaskIntoConstraints = false
        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            balanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            addBalanceButton.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: 10),
            addBalanceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            addTransactionButton.topAnchor.constraint(equalTo: addBalanceButton.bottomAnchor, constant: 20),
            addTransactionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: addTransactionButton.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupActions() {
        addBalanceButton.addTarget(self, action: #selector(addBalanceTapped), for: .touchUpInside)
        addTransactionButton.addTarget(self, action: #selector(addTransactionTapped), for: .touchUpInside)
    }

    @objc private func addBalanceTapped() {
    }

    @objc private func addTransactionTapped() {
    }
}

extension TransactionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        cell.textLabel?.text = "Transaction \(indexPath.row + 1)"
        cell.detailTextLabel?.text = "Details"
        return cell
    }
}

extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
