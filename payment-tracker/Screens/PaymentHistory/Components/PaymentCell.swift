//
//  PaymentCell.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 07/10/25.
//

import UIKit
import SnapKit

class PaymentCell: UITableViewCell {
    private(set) lazy var transactionName: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: .systemFont(ofSize: 17, weight: .bold))
        view.lineBreakMode = .byTruncatingTail
        view.textColor = .label
        view.numberOfLines = 0
        view.adjustsFontForContentSizeCategory = true

        return view
    }()

    private(set) lazy var paymentValue: UILabel = {
        let view = UILabel()
        view.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 18, weight: .bold))
        view.textColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontForContentSizeCategory = true

        return view
    }()
    
    private(set) lazy var dateLabel: UILabel = {
        let view = UILabel()
        view.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 14))
        view.textColor = .label
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontForContentSizeCategory = true

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
        addSubview(transactionName)
        addSubview(paymentValue)
        addSubview(dateLabel)
    }
    
    private func setupConstraints() {
        transactionName.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(12)
            make.top.equalToSuperview().offset(12)
            make.trailing.lessThanOrEqualTo(paymentValue.snp.leading)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(transactionName.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(12)
            make.bottom.equalToSuperview()
        }

        paymentValue.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-12)
        }
    }
    
    func setup(with payment: Payment) {
        transactionName.text = payment.name
        paymentValue.text = "R$" + String(format: "%.2f", payment.value)
        dateLabel.text = payment.date.formatted()
    }
}
