//
//  OnBoardingFourthView.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 13/10/25.
//

import AVFoundation
import SnapKit
import UIKit

class OnBoardingFourthView: UIView {
    var onContinue: (() -> Void)?

    private var player: AVQueuePlayer?
    private var looper: AVPlayerLooper?

    private(set) lazy var firstStepLabel: UILabel = {
        let view = UILabel()
        view.text =
            "5º Passo:\nNo Campo \"Valor\" selecione \"Selecionar Variável\""
        view.textAlignment = .center
        view.numberOfLines = 0
        view.textColor = .label
        view.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: .systemFont(ofSize: 14, weight: .semibold)
        )
        view.adjustsFontForContentSizeCategory = true
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private(set) lazy var shortcutImage: UIImageView = {
        let image = UIImage(named: "variable-addition")
        let view = UIImageView(image: image)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    private(set) lazy var secondStepLabel: UILabel = {
        let view = UILabel()
        view.text =
            "6º Passo:\nClique em \"Entrada do Atalho\" e altere o campo para \"Valor\""
        view.textAlignment = .center
        view.numberOfLines = 0
        view.textColor = .label
        view.font = UIFontMetrics(forTextStyle: .body).scaledFont(
            for: .systemFont(ofSize: 14, weight: .semibold)
        )
        view.adjustsFontForContentSizeCategory = true
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
        view.alwaysBounceVertical = true
        view.showsVerticalScrollIndicator = false
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
                shortcutImage,
                secondStepLabel,
                videoView,
            ]
        )
        view.axis = .vertical
        view.spacing = 16
        view.alignment = .center
        view.translatesAutoresizingMaskIntoConstraints = false

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

    func startVideo() {
        guard
            let url = Bundle.main.url(
                forResource: "setting_value2",
                withExtension: "mov"
            )
        else {
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

        shortcutImage.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(container).inset(20)
            make.centerX.equalToSuperview()
            make.height.lessThanOrEqualTo(scroll.snp.height)
                .multipliedBy(0.32)
        }

        videoView.snp.makeConstraints { make in
            make.width.equalTo(container).multipliedBy(0.75).inset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(videoView.snp.width).multipliedBy(13.0 / 6.0)
        }

        nextButton.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(48)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(16)
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
