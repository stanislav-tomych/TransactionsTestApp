//
//  TransactionsViewController.swift
//  TransactionsTestTask
//
//

import UIKit
import Combine

final class TransactionsViewController: UIViewController {
    private let viewModel: TransactionsViewModel
    private var cancellables = Set<AnyCancellable>()
  
    private let bitcoinRateView = BitcoinRateView()
    private let balanceView = BalanceView()

    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    private lazy var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
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
        viewModel.fetchTransactions(refetchAll: true)
    }
    
    private func setupUI() {
        title = Localization.Transactions.navigationTitle
        view.backgroundColor = .white
        view.addSubview(bitcoinRateView)
        view.addSubview(balanceView)
        view.addSubview(tableView)

        tableView.register(TransactionTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(TransactionTableViewCell.self))
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupConstraints() {
        balanceView.translatesAutoresizingMaskIntoConstraints = false
        bitcoinRateView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            bitcoinRateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            bitcoinRateView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -Constants.spacing),
            bitcoinRateView.heightAnchor.constraint(equalToConstant: Constants.rateViewHeight),
            
            balanceView.topAnchor.constraint(equalTo: bitcoinRateView.bottomAnchor, constant: Constants.spacing),
            balanceView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.spacing),
            balanceView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.spacing),

            tableView.topAnchor.constraint(equalTo: balanceView.bottomAnchor, constant: Constants.spacing),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func setupActions() {
        balanceView.onAddBalanceTapped = { [weak self] in
            self?.showAddBalanceAlert()
        }

        balanceView.onAddTransactionTapped = { [weak self] in
            self?.viewModel.handleAddTransactionButtonTapped()
        }
    }

    private func setupBindings() {
        viewModel.$currentBalance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] balance in
                self?.balanceView.updateBalance(balance)
            }
            .store(in: &cancellables)
        
        viewModel.$transactionsSections
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.$bitcoinRate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rate in
                self?.bitcoinRateView.updateRate(rate)
            }
            .store(in: &cancellables)
    }

    private func showAddBalanceAlert() {
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
        static let spacing: CGFloat = 8
        static let rateViewHeight: CGFloat = 50
        static let sectionHeaderHeight: CGFloat = 50.0
        static let tableViewCellHeight: CGFloat = 70.0
    }
}

extension TransactionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.transactionsSections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transactionsSections[section].transactions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(TransactionTableViewCell.self), for: indexPath) as! TransactionTableViewCell
        let transaction = viewModel.transactionsSections[indexPath.section].transactions[indexPath.row]
        cell.configure(with: transaction, timeFormatter: timeFormatter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = TransactionsSectionHeader()
        headerView.configure(with: dateFormatter.string(from: viewModel.transactionsSections[section].date))
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Constants.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.tableViewCellHeight
    }
}

extension TransactionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let section = viewModel.transactionsSections[indexPath.section]
        if indexPath.row == section.transactions.count - 1 && indexPath.section == viewModel.transactionsSections.count - 1 {
            viewModel.fetchTransactions()
        }
    }
}
