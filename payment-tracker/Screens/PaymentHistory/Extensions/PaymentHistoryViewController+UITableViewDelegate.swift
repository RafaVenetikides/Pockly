//
//  PaymentHistoryViewController+UITableViewDelegate.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 02/12/25.
//

import UIKit

extension PaymentHistoryViewController: UITableViewDelegate {
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            guard let self else { return }
            let record = self.items[indexPath.row]
            do {
                try self.repository.delete(id: record.id)
                self.removeItem(at: indexPath)
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
        return 70
    }
}
