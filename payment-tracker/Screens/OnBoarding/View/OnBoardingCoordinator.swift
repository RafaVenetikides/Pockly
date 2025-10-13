//
//  OnBoardingCoordinator.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 13/10/25.
//

import UIKit

final class OnBoardingCoordinator {
    private let nav: UINavigationController
    private let homeFactory: () -> UIViewController
    
    private var steps: [UIViewController] = []
    private var index = 0

    init(nav: UINavigationController, homeFactory: @escaping () -> UIViewController) {
        self.nav = nav
        self.homeFactory = homeFactory
    }

    func start() {
        nav.setNavigationBarHidden(true, animated: false)

        let first = HostingViewController(rootView: OnBoardingFirstView())
        let second = HostingViewController(rootView: OnBoardingSecondView())
        let third = HostingViewController(rootView: OnBoardingThirdView())
        let fourth = HostingViewController(rootView: OnBoardingFourthView())
        let final = HostingViewController(rootView: OnBoardingFinishView())

        first.rootView.onSkip = { [weak self] in
            self?.finish()
        }
        
        first.rootView.onContinue = { [weak self] in
            self?.goNext()
        }

        second.rootView.onContinue = { [weak self] in
            self?.goNext()
        }

        third.rootView.onContinue = { [weak self] in
            self?.goNext()
        }

        fourth.rootView.onContinue = { [weak self] in
            self?.goNext()
        }
        
        final.rootView.onContinue = { [weak self] in
            self?.finish()
        }
        
        final.rootView.onRepeat = { [weak self] in
            self?.reset()
        }

        steps = [first, second, third, fourth, final]
        nav.setViewControllers([steps[0]], animated: false)
    }

    func goNext() {
        guard index + 1 < steps.count else {
            finish()
            return
        }
        index += 1
        nav.pushViewController(steps[index], animated: true)
    }

    func finish() {
        UserDefaults.standard.set(true, forKey: "onboardingCompleted")
        
        let homeVC = homeFactory()
        
        UIView.transition(with: nav.view, duration: 0.35, options: .transitionCrossDissolve) {
            self.nav.setViewControllers([homeVC], animated: false)
        }
    }
    
    func reset() {
        guard steps.indices.contains(1) else { return }
        index = 1
        nav.popToViewController(steps[index], animated: true)
    }
}
