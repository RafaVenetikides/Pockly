//
//  OnBoardingThirdView.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 13/10/25.
//

import UIKit
import SnapKit

class OnBoardingThirdView: UIView {
    var onContinue: (() -> Void)?
    
    private(set) lazy var firstStepLabel: UILabel = {
        let view = UILabel()
        view.text = "3º Passo:\nSelecione a opção \"Executar Automaticamente\" e clique em \"Seguinte\""
        view.textAlignment = .center
        view.numberOfLines = 0
        view.textColor = .label
        view.font = .systemFont(ofSize: 14, weight: .semibold)
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
        view.text = "4º Passo:\nClique em \"Criar Novo Atalho\" e busque pelo Pockly, selecionando \"Adicionar nova transação\""
        view.textAlignment = .center
        view.numberOfLines = 0
        view.textColor = .label
        view.font = .systemFont(ofSize: 14, weight: .semibold)
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
        view.gradientColors = [.lightBlueCustom1, .blueCustom1, .lightBlueCustom1]
        view.direction = .topLeftToBottomRight
        view.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        return view
    }()
    
    @objc
    private func handleContinue() {
        onContinue?()
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
        addSubview(firstStepLabel)
        addSubview(executionImage)
        addSubview(secondStepLabel)
        addSubview(newShortcutImage)
        addSubview(pocklySearchImage)
        addSubview(nextButton)
    }
    
    private func setupConstraints() {
        firstStepLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(75)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(290)
        }
        
        executionImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(firstStepLabel.snp.bottom).offset(12)
            make.height.equalTo(86)
            make.width.equalTo(185)
        }
        
        secondStepLabel.snp.makeConstraints { make in
            make.top.equalTo(executionImage.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(270)
        }
        
        newShortcutImage.snp.makeConstraints { make in
            make.top.equalTo(secondStepLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(200)
        }
        
        pocklySearchImage.snp.makeConstraints { make in
            make.top.equalTo(newShortcutImage.snp.bottom).offset(12)
            make.bottom.equalTo(nextButton.snp.top).offset(-24)
            make.centerX.equalToSuperview()
            make.width.equalTo(280)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(36)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
    }
}
