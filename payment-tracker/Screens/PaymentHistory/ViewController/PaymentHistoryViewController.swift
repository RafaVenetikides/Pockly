//
//  ViewController.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 07/10/25.
//

import UIKit
import WidgetKit

class PaymentHistoryViewController: UIViewController {

    private var paymentView = PaymentHistoryView()
    internal let repository: PaymentRepository

    private(set) var items: [PaymentRecord] = []

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
        
        paymentView.tableView.paymentHistory.delegate = self
        paymentView.tableView.paymentHistory.dataSource = self

        updateTotalInAppGroup()

        if #available(iOS 26.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(systemName: "plus"),
                style: .prominent,
                target: self,
                action: #selector(addPayment)
            )
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                title: "",
                image: UIImage(systemName: "plus"),
                target: self,
                action: #selector(addPayment)
            )
        }
    }

    @objc
    private func addPayment() {
        let alert = UIAlertController(
            title: "Novo pagamento",
            message: "Adicione um novo pagamento",
            preferredStyle: .alert
        )
        alert.addTextField { $0.placeholder = "Nome (ex: Supermercado)" }
        alert.addTextField {
            $0.placeholder = "Valor"
            $0.keyboardType = .decimalPad
        }
        alert.addTextField {
            $0.placeholder = "Data (dd/MM/yyyy) - opcional"
            $0.text = "01/12/2025"
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

                    let card = "Carteira"

                    let raw = alert.textFields?[1].text?.replacingOccurrences(
                        of: ",",
                        with: "."
                    ).trimmingCharacters(in: .whitespacesAndNewlines)

                    let dateString = alert.textFields?[2].text?
                                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""

                    guard !name.isEmpty, !card.isEmpty, let raw,
                        let value = Double(raw)
                    else { return }

                    let formatter = DateFormatter()
                            formatter.dateFormat = "dd/MM/yyyy"
                            formatter.locale = Locale(identifier: "pt_BR")

                    let date = formatter.date(from: dateString) ?? Date()

                    let payment = Payment(
                        name: name,
                        cardName: card,
                        value: value,
                        date: date
                    )

                    do {
                        let record = try self.repository.add(payment)
                        self.items.insert(record, at: 0)
                        self.items.sort { $0.payment.date > $1.payment.date }
                        self.paymentView.tableView.paymentHistory.reloadData()
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

    internal func updateTotalInAppGroup() {
        let currentWeekTotal = weeklyTotal()
        let previousWeekTotal = weeklyTotal(weekOffset: -1)

        if let (startDate, endDate) = weekRange() {
            let calendar = Calendar.current
            let endDate = calendar.date(byAdding: .day, value: -1, to: endDate) ?? endDate

            paymentView.updateHeader(
                currentWeekTotal: currentWeekTotal,
                previousWeekTotal: previousWeekTotal,
                startDate: startDate,
                endDate: endDate
            )
        } else {
            paymentView.updateHeader(
                currentWeekTotal: currentWeekTotal,
                previousWeekTotal: previousWeekTotal,
                startDate: Date(),
                endDate: Date()
            )
        }

        if let groupDefaults = UserDefaults(
            suiteName: "group.dev.venetikides.paymenttracker"
        ) {
            groupDefaults.set(currentWeekTotal, forKey: "totalAmount")
        }
        WidgetCenter.shared.reloadAllTimelines()
    }

    private func weeklyTotal(weekOffset: Int = 0) -> Double {
        guard let (startOfWeek, endOfWeek) = weekRange(weekOffset: weekOffset) else {
            return 0
        }

        let total = items.filter { paymentRecord in
            let date = paymentRecord.payment.date
            return date >= startOfWeek && date < endOfWeek
        }
            .reduce(0.0) { $0 + $1.payment.value }

        return total
    }

    func removeItem(at indexPath: IndexPath) {
        items.remove(at: indexPath.row)
    }

    private func weekRange(weekOffset: Int = 0) -> (start: Date, endExclusive: Date)? {
        let calendar = Calendar.current
        let now = Date()

        guard let baseDate = calendar.date(byAdding: .weekOfYear, value: weekOffset, to: now),
              let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: baseDate)),
              let endOfWeek = calendar.date(byAdding: .day, value: 7, to: startOfWeek) else {
            return nil
        }

        return (startOfWeek, endOfWeek)
    }
}
