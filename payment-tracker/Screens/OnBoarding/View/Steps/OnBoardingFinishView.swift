//
//  OnBoardingFinishView.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 13/10/25.
//

import SnapKit
import UIKit

class OnBoardingFinishView: UIView {
    var onContinue: (() -> Void)?
    var onRepeat: (() -> Void)?

    private(set) lazy var doneLabel: UILabel = {
        let view = UILabel()
        view.text = "Pronto!"
        view.textColor = .lightBlueCustom
        view.font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(
            for: .systemFont(ofSize: 40, weight: .bold)
        )
        view.adjustsFontForContentSizeCategory = true
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private(set) lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.text =
            "Agora compras feitas por aproximação com o celular serão automaticamente cadastradas no Pockly!"
        view.textColor = .label
        view.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: .systemFont(ofSize: 26, weight: .regular)
        )
        view.adjustsFontForContentSizeCategory = true
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setContentCompressionResistancePriority(
            .defaultLow,
            for: .vertical
        )

        return view
    }()

    private(set) lazy var homeButton: GradientButton = {
        let view = GradientButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Concluir", for: .normal)
        view.gradientColors = [
            .lightBlueCustom1, .blueCustom1, .lightBlueCustom1,
        ]
        view.direction = .topLeftToBottomRight
        view.addTarget(
            self,
            action: #selector(handleContinue),
            for: .touchUpInside
        )

        return view
    }()

    @objc
    private func handleContinue() {
        onContinue?()
    }

    private(set) lazy var repeatButton: UIButton = {
        let view = UIButton()
        view.setTitle("Repetir configuração", for: .normal)
        view.setTitleColor(.label, for: .normal)
        view.titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: .systemFont(ofSize: 22, weight: .regular)
        )
        view.titleLabel?.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.numberOfLines = 0
        view.addTarget(
            self,
            action: #selector(handleRepeat),
            for: .touchUpInside
        )

        return view
    }()

    private(set) lazy var scroll: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true

        return view
    }()

    private(set) lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(content)

        return view
    }()

    private(set) lazy var content: UIStackView = {
        let view = UIStackView(
            arrangedSubviews: [
                doneLabel,
                descriptionLabel
            ]
        )
        view.axis = .vertical
        view.alignment = .center
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    @objc
    private func handleRepeat() {
        onRepeat?()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateScrollingIfNeeded()
    }

    override func traitCollectionDidChange(_ previous: UITraitCollection?) {
        super.traitCollectionDidChange(previous)
        if previous?.preferredContentSizeCategory
            != traitCollection.preferredContentSizeCategory
        {
            setNeedsLayout()
        }
    }

    private func updateScrollingIfNeeded() {
        layoutIfNeeded()
        let visible = scroll.bounds.height
        let contentH = scroll.contentSize.height
        let needs = contentH > visible + 1
        scroll.isScrollEnabled = needs
    }

    private func setupViews() {
        addSubview(scroll)
        addSubview(homeButton)
        addSubview(repeatButton)
    }

    private func setupConstraints() {
        scroll.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(homeButton.snp.top).offset(-24)
        }

        container.snp.makeConstraints { make in
            make.edges.equalTo(scroll.contentLayoutGuide)
            make.width.equalTo(scroll.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scroll.frameLayoutGuide).priority(
                250
            )
        }

        content.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(container).inset(24)
            make.top.greaterThanOrEqualTo(container).inset(24)
            make.bottom.lessThanOrEqualTo(container).inset(24)
            make.centerY.equalTo(container).priority(250)
        }

        homeButton.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(48)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(repeatButton.snp.top).offset(-20)
        }

        repeatButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
