//
//  RootRouter.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs

protocol RootInteractable: Interactable, LoggedOutListener, LoggedInListener {
    var router: RootRouting? { get set }
    var listener: RootListener? { get set }
}

protocol RootViewControllable: ViewControllable {
    func replaceModal(viewController: ViewControllable?)
}

final class RootRouter: LaunchRouter<RootInteractable, RootViewControllable>, RootRouting {
    // MARK: - Private properties

    private let loggedOutBuilder: LoggedOutBuildable
    private let loggedInBuilder: LoggedInBuildable

    private var loggedIn: (router: LoggedInRouting, actionableItem: LoggedInActionableItem)?
    private var loggedOut: ViewableRouting?

    init(interactor: RootInteractable,
         viewController: RootViewControllable,
         loggedOutBuilder: LoggedOutBuildable,
         loggedInBuilder: LoggedInBuildable) {

        self.loggedOutBuilder = loggedOutBuilder
        self.loggedInBuilder = loggedInBuilder

        super.init(interactor: interactor, viewController: viewController)

        interactor.router = self
    }

    override func didLoad() {
        super.didLoad()

        // If need to start with login screen:
        //routeToLoggedOut()
    }

    func routeToLoggedIn(sessionToken: String) -> LoggedInActionableItem {
        // Detach logged out.
        if let child = self.loggedOut {
            detachChild(child)
            viewController.replaceModal(viewController: nil)

            self.loggedOut = nil
        }

        loggedIn = loggedInBuilder.build(withListener: interactor, session: sessionToken)

        guard let loggedIn = self.loggedIn else { fatalError("failed to allocate rib") }

        attachChild(loggedIn.router)

        return loggedIn.actionableItem
    }

    func routeToLoggedOut() {
        // Detach loggedIn out.
        if let child = loggedIn {
            detachChild(child.router)
        }

        if loggedOut == nil {
            loggedOut = loggedOutBuilder.build(withListener: interactor)
        }

        guard let loggedOut = self.loggedOut else { fatalError("failed to allocate rib") }

        attachChild(loggedOut)
        viewController.replaceModal(viewController: loggedOut.viewControllable)
    }
}

