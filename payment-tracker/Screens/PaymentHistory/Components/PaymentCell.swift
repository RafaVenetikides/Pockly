//
//  PaymentCell.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 07/10/25.
//

import UIKit
import SnapKit

class PaymentCell: UITableViewCell {
    private(set) lazy var paymentValue: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18, weight: .bold)
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 14)
        view.textColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        selectionStyle = .none
        
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(paymentValue)
        addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        paymentValue.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(paymentValue.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(12)
        }
    }
    
    func setup(with payment: Payment) {
        paymentValue.text = "R$" + String(format: "%.2f", payment.value)
        dateLabel.text = payment.date.formatted()
    }
}
