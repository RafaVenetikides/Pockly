//
//  OnBoardingThirdView.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 13/10/25.
//

import SnapKit
import UIKit

class OnBoardingThirdView: UIView {
    var onContinue: (() -> Void)?

    private(set) lazy var firstStepLabel: UILabel = {
        let view = UILabel()
        view.text =
            "3º Passo:\nSelecione a opção \"Executar Automaticamente\" e clique em \"Seguinte\""
        view.textAlignment = .center
        view.numberOfLines = 0
        view.textColor = .label
        view.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: .systemFont(ofSize: 16, weight: .semibold)
        )
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private(set) lazy var executionImage: UIImageView = {
        let image = UIImage(named: "execution")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private(set) lazy var secondStepLabel: UILabel = {
        let view = UILabel()
        view.text =
            "4º Passo:\nClique em \"Criar Novo Atalho\" e busque pelo Pockly, selecionando \"Adicionar nova transação\""
        view.textAlignment = .center
        view.numberOfLines = 0
        view.textColor = .label
        view.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: .systemFont(ofSize: 16, weight: .semibold)
        )
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private(set) lazy var newShortcutImage: UIImageView = {
        let image = UIImage(named: "new_shortcut")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit

        return view
    }()

    private(set) lazy var pocklySearchImage: UIImageView = {
        let image = UIImage(named: "pockly_search")
        let view = UIImageView(image: image)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .scaleAspectFit

        return view
    }()

    private(set) lazy var nextButton: GradientButton = {
        let view = GradientButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Próximo", for: .normal)
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

    private(set) lazy var scroll: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(container)

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
                firstStepLabel,
                executionImage,
                secondStepLabel,
                newShortcutImage,
                pocklySearchImage,
            ]
        )
        view.axis = .vertical
        view.spacing = 16
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    @objc
    private func handleContinue() {
        onContinue?()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateScrollingIfNeeded()
    }

    override func traitCollectionDidChange(
        _ previousTraitCollection: UITraitCollection?
    ) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory
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

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black

        setupViews()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(scroll)
        addSubview(nextButton)
    }

    private func setupConstraints() {
        scroll.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(nextButton.snp.top).offset(-24)
        }

        container.snp.makeConstraints { make in
            make.edges.equalTo(scroll.contentLayoutGuide)
            make.width.equalTo(scroll.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scroll.frameLayoutGuide).priority(
                250
            )
        }

        content.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(container).inset(20)
            make.top.greaterThanOrEqualTo(container).inset(24)
            make.bottom.lessThanOrEqualTo(container).inset(24)
            make.centerY.equalTo(container).priority(250)
        }

        executionImage.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(container).inset(20)
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(scroll.snp.height)
                .multipliedBy(0.3)
        }

        newShortcutImage.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(container).inset(20)
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(scroll.snp.height)
                .multipliedBy(0.2)
        }

        pocklySearchImage.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(container).inset(20)
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(scroll.snp.height)
                .multipliedBy(0.35)
        }

        nextButton.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(48)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
        }
    }
}
