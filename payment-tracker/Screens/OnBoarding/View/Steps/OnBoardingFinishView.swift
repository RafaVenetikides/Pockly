//
//  OnBoardingFinishView.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 13/10/25.
//

import UIKit
import SnapKit

class OnBoardingFinishView: UIView {
    var onContinue: (() -> Void)?
    var onRepeat: (() -> Void)?
    
    private(set) lazy var doneLabel: UILabel = {
        let view = UILabel()
        view.text = "Pronto!"
        view.textColor = .lightBlueCustom
        view.font = .systemFont(ofSize: 40, weight: .bold)
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var descriptionLabel: UILabel = {
        let view = UILabel()
        view.text = "Agora compras feitas por aproximação com o celular serão automaticamente cadastradas no Pockly!"
        view.textColor = .white
        view.font = .systemFont(ofSize: 26, weight: .regular)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var homeButton: GradientButton = {
        let view = GradientButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.setTitle("Concluir", for: .normal)
        view.gradientColors = [.lightBlueCustom, .blueCustom, .lightBlueCustom]
        view.direction = .topLeftToBottomRight
        view.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        
        return view
    }()
    
    @objc
    private func handleContinue() {
        onContinue?()
    }
    
    private(set) lazy var repeatButton: UIButton = {
        let view = UIButton()
        view.setTitle("Repetir configuração", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.titleLabel?.font = .systemFont(ofSize: 22, weight: .regular)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addTarget(self, action: #selector(handleRepeat), for: .touchUpInside)
        
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
    
    private func setupViews() {
        addSubview(doneLabel)
        addSubview(descriptionLabel)
        addSubview(homeButton)
        addSubview(repeatButton)
    }
    
    private func setupConstraints() {
        doneLabel.snp.makeConstraints { make in
            make.bottom.equalTo(descriptionLabel.snp.top).offset(-16)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(302)
        }
        
        homeButton.snp.makeConstraints { make in
            make.bottom.equalTo(repeatButton.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
        
        repeatButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-40)
            make.centerX.equalToSuperview()
            make.height.equalTo(30)
        }
    }
}
