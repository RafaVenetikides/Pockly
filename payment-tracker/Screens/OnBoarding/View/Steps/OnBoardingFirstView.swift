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
        view.font = UIFont.systemFont(ofSize: 24)
        view.textColor = .white
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
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
        view.font = .systemFont(ofSize: 26)
        view.textColor = .white
        view.numberOfLines = 0
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var continueButton: GradientButton = {
        let view = GradientButton()
        view.setTitle("Vamos lá!", for: .normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.gradientColors = [.lightBlueCustom, .blueCustom, .lightBlueCustom]
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
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 22)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        addSubview(welcome)
        addSubview(logoView)
        addSubview(messageLabel)
        addSubview(continueButton)
        addSubview(skipButton)
    }
    
    private func setupConstraints() {
        logoView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-50)
            make.centerX.equalToSuperview()
            make.height.equalTo(88)
            make.width.equalTo(220)
        }
        
        welcome.snp.makeConstraints { make in
            make.bottom.equalTo(logoView.snp.top).offset(12)
            make.centerX.equalToSuperview()
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(logoView.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
        
        skipButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(40)
            make.centerX.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints { make in
            make.bottom.equalTo(skipButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
    }
}
