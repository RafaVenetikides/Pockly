//
//  HostingViewController.swift
//  payment-tracker
//
//  Created by Rafael Venetikides on 13/10/25.
//

import UIKit

final class HostingViewController<RootView: UIView>: UIViewController {
    let rootView: RootView

    init(rootView: RootView) {
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)

        rootView.backgroundColor = .systemBackground
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func loadView() {
        view = rootView
    }
}
