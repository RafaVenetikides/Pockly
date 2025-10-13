//
//  ViewController.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 07/10/25.
//

import UIKit
import WidgetKit
import os

class PaymentHistoryViewController: UIViewController {

    private var paymentView = PaymentHistoryView()
    private let repository: PaymentRepository

    private var items: [PaymentRecord] = []

    init(repository: PaymentRepository) {
        self.repository = repository
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        super.loadView()
        self.view = paymentView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false

        do {
            items = try repository.fetchAll()
        } catch {
            print("Erro ao carregar pagamentos: \(error)")
        }

        updateTotalInAppGroup()

        paymentView.paymentHistory.delegate = self
        paymentView.paymentHistory.dataSource = self

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus"),
            style: .prominent,
            target: self,
            action: #selector(addPayment)
        )
    }

    @objc
    private func addPayment() {
        let alert = UIAlertController(
            title: "Novo pagamento",
            message: "Adicione um novo pagamento",
            preferredStyle: .alert
        )
        alert.addTextField { $0.placeholder = "Nome (ex: Supermercado)" }
        alert.addTextField { $0.placeholder = "Cartão (ex: Nubank)" }
        alert.addTextField {
            $0.placeholder = "Valor"
            $0.keyboardType = .decimalPad
        }

        alert.addAction(
            UIAlertAction(
                title: "Add",
                style: .default,
                handler: { [weak self] _ in
                    guard let self else { return }
                    let name =
                        alert.textFields?[0].text?.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ) ?? ""
                    let card =
                        alert.textFields?[1].text?.trimmingCharacters(
                            in: .whitespacesAndNewlines
                        ) ?? ""
                    let raw = alert.textFields?[2].text?.replacingOccurrences(
                        of: ",",
                        with: "."
                    ).trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !name.isEmpty, !card.isEmpty, let raw,
                        let value = Double(raw)
                    else { return }

                    let payment = Payment(
                        name: name,
                        cardName: card,
                        value: value,
                        date: Date()
                    )

                    do {
                        let record = try self.repository.add(payment)
                        self.items.insert(record, at: 0)
                        self.paymentView.paymentHistory.reloadData()
                        self.updateTotalInAppGroup()
                    } catch {
                        print("Erro ao salvar: \(error)")
                    }
                }
            )
        )

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    private func updateTotalInAppGroup() {
        let calendar = Calendar.current
        let now = Date()

        guard
            let startOfWeek = calendar.date(
                from: calendar.dateComponents(
                    [.yearForWeekOfYear, .weekOfYear],
                    from: now
                )
            ),
            let endOfWeek = calendar.date(bySetting: .day, value: 7, of: now)
        else {
            return
        }

        let total = items.filter { paymentRecord in
            let date = paymentRecord.payment.date
            return date >= startOfWeek && date < endOfWeek
        }
        .reduce(0.0) { $0 + $1.payment.value }

        if let groupDefaults = UserDefaults(
            suiteName: "group.dev.venetikides.paymenttracker"
        ) {
            groupDefaults.set(total, forKey: "totalAmount")
        }
        WidgetCenter.shared.reloadAllTimelines()
    }

}

extension PaymentHistoryViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) {
            [weak self] _, _, completion in
            guard let self else { return }
            let record = self.items[indexPath.row]
            do {
                try self.repository.delete(id: record.id)
                self.items.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                self.updateTotalInAppGroup()
                completion(true)
            } catch {
                print("Error deleting data from CoreData: \(error)")
                completion(false)
            }
        }
        deleteAction.image = UIImage(systemName: "trash.fill")
        deleteAction.backgroundColor = .red
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 80
    }
}

extension PaymentHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "PaymentCell",
                for: indexPath
            ) as? PaymentCell
        else {
            return UITableViewCell()
        }
        let payment = items[indexPath.row].payment
        cell.setup(with: payment)
        return cell
    }

}
