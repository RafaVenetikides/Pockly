//
//  PaymentHistoryTableView.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 07/10/25.
//

import UIKit
import SnapKit

class PaymentHistoryTableView: UIView {
    private(set) lazy var paymentHistory: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.separatorStyle = .none
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(paymentHistory)
    }
    
    private func setupConstraints() {
        paymentHistory.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
    }
    
    private func setupCollectionView() {
        paymentHistory.register(PaymentCell.self, forCellReuseIdentifier: "PaymentCell")
    }
}
