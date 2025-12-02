//
//  PaymentHistoryHeaderView.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 01/12/25.
//

import UIKit
import SnapKit

final class PaymentHistoryHeaderView: UIView {
    private(set) lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.text = "Gastos da semana:"
        view.font = .systemFont(ofSize: 17, weight: .semibold)
        view.textColor = .white

        return view
    }()

    private(set) lazy var totalSpentLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 42, weight: .bold))
        view.textAlignment = .center
        view.textColor = .white
        view.text = "R$ 145,38"
        view.adjustsFontForContentSizeCategory = true

        return view
    }()

    private(set) lazy var comparisonLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 17, weight: .medium)
        view.textAlignment = .center
        view.text = "􀄨15% de semana passada"
        view.textColor = .green

        return view
    }()

    private(set) lazy var datesLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 22, weight: .medium)
        view.textColor = .white
        view.text = "01 Dec - 07 Dec"
        view.textAlignment = .center

        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(titleLabel)
        addSubview(totalSpentLabel)
        addSubview(comparisonLabel)
        addSubview(datesLabel)
    }

    private func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(22)
        }
        
        totalSpentLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.height.equalTo(36)
            make.horizontalEdges.equalToSuperview()
        }
        
        comparisonLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(totalSpentLabel.snp.bottom).offset(10)
            make.height.equalTo(29)
            make.horizontalEdges.equalToSuperview()
        }
        
        datesLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(comparisonLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(16)
        }
    }
}
