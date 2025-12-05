//
//  PaymentHistoryView.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 01/12/25.
//

import UIKit
import SnapKit

final class PaymentHistoryView: UIView {
    
    private var header = PaymentHistoryHeaderView()
    
    private let divider: UIView = {
        let divider = UIView()
        divider.backgroundColor = .systemGray2
        
        return divider
    }()
    
    private(set) lazy var tableView = PaymentHistoryTableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .systemBackground

        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(header)
        addSubview(divider)
        addSubview(tableView)
    }
    
    private func setupConstraints() {
        header.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        divider.snp.makeConstraints { make in
            make.height.equalTo(1)
            make.bottom.equalTo(tableView.snp.top).offset(-5)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        tableView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(header.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }

    func updateHeader(currentWeekTotal: Double, previousWeekTotal: Double, startDate: Date, endDate: Date) {
        header.update(
            currentWeekTotal: currentWeekTotal,
            previousWeekTotal: previousWeekTotal,
            startDate: startDate,
            endDate: endDate
        )
    }
}
