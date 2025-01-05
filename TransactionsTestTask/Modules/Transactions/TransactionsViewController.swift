//
//  TransactionsViewController.swift
//  TransactionsTestTask
//
//

import UIKit
import Combine

class TransactionsViewController: UIViewController {
    private let viewModel: TransactionsViewModel
    private var cancellables = Set<AnyCancellable>()

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

    init(viewModel: TransactionsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        setupBindings()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchTransactions()
    }
    
    private func setupUI() {
        title = Localization.Transactions.navigationTitle
        view.backgroundColor = .white
        view.addSubview(balanceLabel)
        view.addSubview(addBalanceButton)
        view.addSubview(addTransactionButton)
        view.addSubview(tableView)

        tableView.dataSource = self
    }

    private func setupConstraints() {
        balanceLabel.translatesAutoresizingMaskIntoConstraints = false
        addBalanceButton.translatesAutoresizingMaskIntoConstraints = false
        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            balanceLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.spacing),
            balanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            addBalanceButton.topAnchor.constraint(equalTo: balanceLabel.bottomAnchor, constant: Constants.spacing / 2),
            addBalanceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            addTransactionButton.topAnchor.constraint(equalTo: addBalanceButton.bottomAnchor, constant: Constants.spacing),
            addTransactionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            tableView.topAnchor.constraint(equalTo: addTransactionButton.bottomAnchor, constant: Constants.spacing),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupActions() {
        addBalanceButton.addTarget(self, action: #selector(addBalanceTapped), for: .touchUpInside)
        addTransactionButton.addTarget(self, action: #selector(addTransactionTapped), for: .touchUpInside)
    }

    private func setupBindings() {
        viewModel.$currentBalance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] balance in
                self?.balanceLabel.text = String(format: "%.2f BTC", balance)
            }
            .store(in: &cancellables)
        
        viewModel.$transactions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    @objc private func addBalanceTapped() {
        let alertController = UIAlertController(
            title: Localization.Transactions.fillBalanceTitle,
            message: nil,
            preferredStyle: .alert
        )
        
        alertController.addTextField { textField in
            textField.placeholder = Localization.Transactions.fillBalancePlaceholder
            textField.keyboardType = .decimalPad
        }
        
        let addAction = UIAlertAction(title: Localization.Common.ok, style: .default) { [weak self] _ in
            guard let textField = alertController.textFields?.first,
                  let amount = textField.text?.toDouble(),
                  amount > 0 else {
                return
            }
            self?.viewModel.addBalance(amount: amount)
        }
        
        let cancelAction = UIAlertAction(title: Localization.Common.cancel, style: .cancel, handler: nil)
        
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }

    @objc private func addTransactionTapped() {
        viewModel.handleAddTransactionButtonTapped()
    }
    
    private enum Constants {
        static let spacing: CGFloat = 20
    }
}

extension TransactionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        let transaction = viewModel.transactions[indexPath.row]
        cell.textLabel?.text = "\(transaction.amount) BTC"
        cell.textLabel?.textColor = transaction.type == .adjunction ? .black : .red
        cell.detailTextLabel?.text = transaction.category.toString()
        cell.selectionStyle = .none
        return cell
    }
}
