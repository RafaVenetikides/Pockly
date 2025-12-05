//
//  PaymentHistoryViewController+UITableViewDataSource.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 02/12/25.
//

import UIKit

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
