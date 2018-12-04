//
//  RootViewController.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import SnapKit
import UIKit

protocol RootPresentableListener: class {
    func viewDidAppear()
}

final class RootViewController: UIViewController, RootPresentable, RootViewControllable {

    weak var listener: RootPresentableListener?

    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("Method is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        listener?.viewDidAppear()
    }

    // MARK: - RootViewControllable

    func replaceModal(viewController: ViewControllable?) {
        targetViewController = viewController

        guard !animationInProgress else { return }

        if presentedViewController != nil {
            animationInProgress = true
            dismiss(animated: true) { [weak self] in
                guard let this = self else { return }

                if this.targetViewController != nil {
                    this.presentTargetViewController()
                } else {
                    this.animationInProgress = false
                }
            }
        } else {
            presentTargetViewController()
        }
    }

    // MARK: - Private

    private var targetViewController: ViewControllable?
    private var animationInProgress = false

    private func presentTargetViewController() {
        if let targetViewController = targetViewController {
            animationInProgress = true
            present(targetViewController.uiviewController, animated: true) { [weak self] in
                self?.animationInProgress = false
            }
        }
    }
}

// MARK: LoggedInViewControllable

extension RootViewController: LoggedInViewControllable {
}
