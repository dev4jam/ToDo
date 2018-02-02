//
//  LoggedInRouter.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift

protocol LoggedInInteractable: Interactable, DrawerListener {
    weak var router: LoggedInRouting? { get set }
    weak var listener: LoggedInListener? { get set }
}

protocol LoggedInViewControllable: ViewControllable {
    func replaceModal(viewController: ViewControllable?)
}

final class LoggedInRouter: ViewableRouter<LoggedInInteractable, LoggedInViewControllable>, LoggedInRouting {
    private var drawerBuilder: DrawerBuildable
    private var drawerChild: (router: DrawerRouting, actionableItem: DrawerActionableItem)?

    required init(interactor: LoggedInInteractable,
                  viewController: LoggedInViewControllable,
                  drawerBuilder: DrawerBuildable) {

        self.drawerBuilder = drawerBuilder

        super.init(interactor: interactor, viewController: viewController)

        interactor.router = self
    }

    // MARK: - LoggedInRouting

    func cleanupViews() {
        if drawerChild != nil {
            viewController.replaceModal(viewController: nil)
        }
    }

    func routeToDrawer() -> DrawerActionableItem {
        let rib = drawerBuilder.build(withListener: interactor)

        self.drawerChild = rib

        attachChild(rib.router)

        viewController.replaceModal(viewController: rib.router.viewControllable)

        return rib.actionableItem
    }

    // MARK: - Private

    private func detachCurrentChild() {
        if let child = drawerChild {
            detachChild(child.router)
            viewController.replaceModal(viewController: nil)
        }
    }
}
