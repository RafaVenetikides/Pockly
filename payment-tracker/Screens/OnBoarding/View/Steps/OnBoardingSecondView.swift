//
//  OnBoardingSecondView.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 13/10/25.
//

import UIKit
import SnapKit
import AVFoundation

class OnBoardingSecondView: UIView {
    var onContinue: (() -> Void)?
    
    private var player: AVQueuePlayer?
    private var looper: AVPlayerLooper?
    
    private(set) lazy var firstStepLabel: UILabel = {
        let view = UILabel()
        view.text = "1º Passo:\nProcure pelo app Atalhos no seu dispositivo"
        view.textAlignment = .center
        view.numberOfLines = 0
        view.textColor = .label
        view.font = .systemFont(ofSize: 14, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var shortcutImage: UIImageView = {
        let image = UIImage(named: "shortcuts")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var secondStepLabel: UILabel = {
        let view = UILabel()
        view.text = "2º Passo:\nNo Atalhos, vá em criar nova automação e selecione o app Carteira"
        view.textAlignment = .center
        view.numberOfLines = 0
        view.textColor = .label
        view.font = .systemFont(ofSize: 14, weight: .semibold)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private(set) lazy var videoView: PlayerView = {
        let view = PlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        
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
        setupNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()

        if window != nil {
            if player == nil {
                startVideo()
            } else {
                player?.play()
            }
        } else {
            player?.pause()
        }
    }

    func startVideo() {
        guard let url = Bundle.main.url(forResource: "wallet_opening", withExtension: "mov") else {
            print("video not found")
            return
        }
        
        let item = AVPlayerItem(url: url)
        let player = AVQueuePlayer()
        let looper = AVPlayerLooper(player: player, templateItem: item)
        
        self.player = player
        self.looper = looper
        
        if let layer = videoView.layer as? AVPlayerLayer {
            layer.videoGravity = .resizeAspectFill
        }
        
        videoView.player = player
        player.isMuted = true
        player.play()
    }

    @objc
    private func appDidBecomeActive() {
        guard window != nil else { return }

        if player == nil {
            startVideo()
        } else {
            player?.play()
        }
    }

    @objc
    private func appWillResignActive() {
        player?.pause()
    }

    private func setupViews() {
        addSubview(firstStepLabel)
        addSubview(shortcutImage)
        addSubview(secondStepLabel)
        addSubview(videoView)
        addSubview(nextButton)
    }
    
    private func setupConstraints() {
        firstStepLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(75)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(290)
        }
        
        shortcutImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(firstStepLabel.snp.bottom).offset(12)
            make.height.equalTo(86)
            make.width.equalTo(86)
        }
        
        secondStepLabel.snp.makeConstraints { make in
            make.top.equalTo(shortcutImage.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
            make.height.equalTo(70)
            make.width.equalTo(300)
        }
        
        videoView.snp.makeConstraints { make in
            make.top.equalTo(secondStepLabel.snp.bottom).offset(12)
            make.bottom.equalTo(nextButton.snp.top).offset(-24)
            make.centerX.equalToSuperview()
            make.width.equalTo(190)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(36)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(300)
        }
    }

    private func setupNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.didBecomeActiveNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appDidBecomeActive),
            name: UIApplication.willResignActiveNotification,
            object: nil
        )
    }
}
