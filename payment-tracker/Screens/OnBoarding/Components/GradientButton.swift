//
//  GradientButton.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 13/10/25.
//

import UIKit

final class GradientButton: UIButton {
    private let gradientLayer = CAGradientLayer()

    var gradientColors: [UIColor] = [.systemBlue, .systemTeal] {
        didSet { gradientLayer.colors = gradientColors.map { $0.cgColor } }
    }

    enum Direction {
        case horizontal, vertical, topLeftToBottomRight, bottomLeftToTopRight
    }
    var direction: Direction = .horizontal {
        didSet { updatePoints() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        setTitleColor(.white, for: .normal)
        titleLabel?.font = .systemFont(ofSize: 26, weight: .semibold)

        gradientLayer.colors = gradientColors.map { $0.cgColor }
        updatePoints()
        layer.insertSublayer(gradientLayer, at: 0)

        layer.cornerRadius = 12
        layer.cornerCurve = .continuous
        clipsToBounds = true
    }

    private func updatePoints() {
        switch direction {
        case .horizontal:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        case .vertical:
            gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
            gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        case .topLeftToBottomRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        case .bottomLeftToTopRight:
            gradientLayer.startPoint = CGPoint(x: 0, y: 1)
            gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
    }
    
    override var isHighlighted: Bool {
        didSet { gradientLayer.opacity = isHighlighted ? 0.85 : 1.0 }
    }
}
