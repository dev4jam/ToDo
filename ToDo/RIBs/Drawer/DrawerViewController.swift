//
//  LoggedOutInteractor.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import REFrostedViewController

protocol DrawerPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    
    func didOpenMenu()
    func didCloseMenu()
    func didAppear()
}

final class DrawerViewController: REFrostedViewController, DrawerPresentable, DrawerViewControllable {

    /// The UIKit view representation of this view.
    public final var uiviewController: UIViewController { return self }

    weak var listener: DrawerPresentableListener?
    
    init(menuWidth: CGFloat) {
        super.init(contentViewController: nil, menuViewController: nil)
        
        let screenHeight = UIScreen.main.bounds.size.height

        self.direction = .right
        self.liveBlurBackgroundStyle = .dark
        self.liveBlur = true
        self.panGestureEnabled = true
        self.limitMenuViewSize = true
        self.menuViewSize = CGSize(width: menuWidth, height: screenHeight)
        self.panGestureRecognizer.delegate = self
        self.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        listener?.didAppear()
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func presentContent(viewController: ViewControllable) {
        contentViewController = viewController.uiviewController
    }
    
    func presentMenu(viewController: ViewControllable) {
        viewController.uiviewController.view.frame = CGRect(x: 0, y: 0,
                                                            width: menuViewSize.width,
                                                            height: menuViewSize.height)
        menuViewController = viewController.uiviewController
    }
    
    func presentMenuItem(viewController: ViewControllable) {
        present(viewController.uiviewController, animated: true)
    }
    
    func dismissMenuItem(viewController: ViewControllable) {
        viewController.uiviewController.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - DrawerPresentable
    
    func showMenu() {
        presentMenuViewController()
    }
    
    func hideMenu() {
        hideMenuViewController()
    }

    func showHi() {
        let alert = UIAlertController(title: "Hi! 👋🏻", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    func showSelectedMenuItem(_ menuItem: String) {
        let alert = UIAlertController(title: "You've selected:", message: menuItem, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }
}

// MARK: - UIGestureRecognizerDelegate

extension DrawerViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        guard let view = gestureRecognizer.view else { return true }
        
        if view.isKind(of: UICollectionView.self) {
            return false
        } else {
            return true
        }
    }
}

// MARK: - REFrostedViewControllerDelegate

extension DrawerViewController: REFrostedViewControllerDelegate {
    func frostedViewController(_ frostedViewController: REFrostedViewController!,
                               didShowMenuViewController menuViewController: UIViewController!) {
        listener?.didOpenMenu()
    }
    
    func frostedViewController(_ frostedViewController: REFrostedViewController!,
                               didHideMenuViewController menuViewController: UIViewController!) {
        listener?.didCloseMenu()
    }
}
