//
//  AddTransactionViewController.swift
//  TransactionsTestTask
//
//  Created by Stas Tomych on 04.01.2025.
//

import UIKit
import Combine

class AddTransactionViewController: UIViewController {
    private let viewModel: AddTransactionViewModel

    var selectedCategory: TransactionCategory = .groceries
    private var cancellables = Set<AnyCancellable>()
    
    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Localization.AddTransactions.enterAmount
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()

    private let categoryPicker: UIPickerView = UIPickerView()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(Localization.AddTransactions.addButtonTitle, for: .normal)
        return button
    }()

    init(viewModel: AddTransactionViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
        setupBindings()
    }

    private func setupUI() {
        title = Localization.AddTransactions.navigationTitle
        view.backgroundColor = .white
        view.addSubview(amountTextField)
        view.addSubview(categoryPicker)
        view.addSubview(addButton)

        amountTextField.translatesAutoresizingMaskIntoConstraints = false
        categoryPicker.translatesAutoresizingMaskIntoConstraints = false
        addButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            amountTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: Constants.spacing),
            amountTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.spacing),
            amountTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.spacing),

            categoryPicker.topAnchor.constraint(equalTo: amountTextField.bottomAnchor, constant: Constants.spacing),
            categoryPicker.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.spacing),
            categoryPicker.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.spacing),

            addButton.topAnchor.constraint(equalTo: categoryPicker.bottomAnchor, constant: Constants.spacing),
            addButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        amountTextField.becomeFirstResponder()
    }

    private func setupActions() {
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        addButton.addTarget(self, action: #selector(addTransactionTapped), for: .touchUpInside)
    }

    private func setupBindings() {
        amountTextField.textPublisher
            .assign(to: \.amountText, on: viewModel)
            .store(in: &cancellables)

        viewModel.isAddButtonEnabled
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEnabled, on: addButton)
            .store(in: &cancellables)
    }
    
    @objc private func addTransactionTapped() {
        guard let amount = amountTextField.text?.toDouble(), amount > 0 else { return }
        viewModel.addTransaction(amount: amount, selectedCategory: selectedCategory)
    }
    
    private enum Constants {
        static let spacing: CGFloat = 20
    }
}

extension AddTransactionViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TransactionCategory.allCases.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(TransactionCategory.allCases[row].toString())"
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = TransactionCategory.allCases[row]
    }
}
