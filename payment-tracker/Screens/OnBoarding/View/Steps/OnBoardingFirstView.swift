//
//  OnBoardingFirstView.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 13/10/25.
//

import UIKit
import SnapKit

class OnBoardingFirstView: UIView {
    
    var onContinue: (() -> Void)?
    var onSkip: (() -> Void)?
    
    private(set) lazy var welcome: UILabel = {
        let view = UILabel()
        view.text = "Bem vindo ao"
        view.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 24))
        view.textColor = .label
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontForContentSizeCategory = true

        return view
    }()
    
    private(set) lazy var logoView: UIImageView = {
        let image = UIImage(named: "logo")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.text = "Antes de começar, vamos configurar o seu app para cadastrar transações automaticamente?"
        view.textAlignment = .center
        view.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: .systemFont(ofSize: 26))
        view.textColor = .label
        view.lineBreakMode = .byWordWrapping
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.adjustsFontForContentSizeCategory = true
        view.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        return view
    }()

    private(set) lazy var content: UIStackView = {
        let view = UIStackView(arrangedSubviews: [welcome, logoView, messageLabel])
        view.axis = .vertical
        view.spacing = 20
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private(set) lazy var scroll: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.alwaysBounceVertical = true

        return view
    }()

    private(set) lazy var container: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private(set) lazy var continueButton: GradientButton = {
        let view = GradientButton()
        view.setTitle("Vamos lá!", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.gradientColors = [.lightBlueCustom1, .blueCustom1, .lightBlueCustom1]
        view.direction = .topLeftToBottomRight
        view.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)

        return view
    }()
    
    @objc
    private func handleContinue() {
        onContinue?()
    }
    
    private(set) lazy var skipButton: UIButton = {
        let view = UIButton()
        view.setTitle("Pular configuração", for: .normal)
        view.setTitleColor(.label, for: .normal)
        view.titleLabel?.font = UIFontMetrics(forTextStyle: .title2).scaledFont(for: .systemFont(ofSize: 22))
        view.titleLabel?.adjustsFontForContentSizeCategory = true
        view.titleLabel?.textAlignment = .center
        view.titleLabel?.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        
        return view
    }()
    
    @objc
    private func handleSkip() {
        onSkip?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
        setupConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateScrollingIfNeeded()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if previousTraitCollection?.preferredContentSizeCategory != traitCollection.preferredContentSizeCategory {
            setNeedsLayout()
        }
    }

    private func updateScrollingIfNeeded() {
        layoutIfNeeded()

        let visibleHeight = scroll.bounds.height
        let contentHeight = scroll.contentSize.height

        let needsScroll = contentHeight > visibleHeight + 1
        scroll.isScrollEnabled = needsScroll
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(scroll)
        scroll.addSubview(container)
        container.addSubview(content)
        addSubview(continueButton)
        addSubview(skipButton)
    }
    
    private func setupConstraints() {
        scroll.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(continueButton.snp.top).offset(-16)
        }

        container.snp.makeConstraints { make in
            make.edges.equalTo(scroll.contentLayoutGuide)
            make.width.equalTo(scroll.frameLayoutGuide)
            make.height.greaterThanOrEqualTo(scroll.frameLayoutGuide).priority(250)
        }

        content.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(container).inset(20)
            make.top.greaterThanOrEqualTo(container).inset(24)
            make.bottom.lessThanOrEqualTo(container).inset(24)
            make.centerY.equalTo(container).priority(250)
        }

        logoView.snp.makeConstraints { make in
            make.height.equalTo(88)
        }

        continueButton.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(48)
            make.bottom.equalTo(skipButton.snp.top).offset(-20)
            make.horizontalEdges.equalToSuperview().inset(20)
        }

        skipButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
    }
}
