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
        view.adjustsFontForContentSizeCategory = true

        return view
    }()

    private(set) lazy var comparisonLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .systemFont(ofSize: 17, weight: .medium)
        view.textAlignment = .center
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

    func update(currentWeekTotal: Double, previousWeekTotal: Double, startDate: Date, endDate: Date) {
        updateTotalLabel(currentWeekTotal)
        updateComparisonLabel(
            current: currentWeekTotal,
            previous: previousWeekTotal
        )
        updateDatesLabel(startDate: startDate, endDate: endDate)
    }

    func updateTotalLabel(_ totalAmount: Double) {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")

        let formatted = formatter.string(from: NSNumber(value: totalAmount)) ?? "R$ 0,00"
        totalSpentLabel.text = formatted
    }

    func updateComparisonLabel(current: Double, previous: Double) {
        guard previous != 0 else {
            comparisonLabel.attributedText = nil
            comparisonLabel.textColor = .secondaryLabel
            comparisonLabel.text = "Sem referência da semana passada"
            return
        }

        let diff = current - previous
        let percentage = abs(diff) / previous * 100

        guard diff != 0 else {
            comparisonLabel.attributedText = nil
            comparisonLabel.textColor = .secondaryLabel
            comparisonLabel.text = "0.0% de semana passada"
            return
        }

        let symbolName: String
        let color: UIColor
        let text: String

        if diff < 0 {
            symbolName = "arrow.down"
            color = .systemGreen
        } else {
            symbolName = "arrow.up"
            color = .systemRed
        }

        text = String(format: "%.2f%% de semana passada", percentage)

        let attachment = NSTextAttachment()
        if let image = UIImage(systemName: symbolName)?.withTintColor(color, renderingMode: .alwaysOriginal) {
            attachment.image = image
        }

        let symbolString = NSAttributedString(attachment: attachment)
        let textString = NSAttributedString(
            string: text,
            attributes: [
                .foregroundColor: color,
                .font: comparisonLabel.font as Any
            ]
        )

        let result = NSMutableAttributedString()
        result.append(symbolString)
        result.append(textString)
        
        comparisonLabel.attributedText = result
        comparisonLabel.textColor = color
    }

    private func updateDatesLabel(startDate: Date, endDate: Date) {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "dd MMM"

        let startString = formatter.string(from: startDate)
        let endString = formatter.string(from: endDate)

        datesLabel.text = "\(startString) - \(endString)"
    }
}
