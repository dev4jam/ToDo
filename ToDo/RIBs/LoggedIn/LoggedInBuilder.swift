//
//  LoggedInBuilder.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift

protocol LoggedInDependency: Dependency {
    var loggedInViewController: LoggedInViewControllable { get }
    
    var service: ToDoServiceProtocol { get }
    var config: Variable<Config> { get }
}

final class LoggedInComponent: Component<LoggedInDependency> {
    let sessionToken: String

    fileprivate var loggedInViewController: LoggedInViewControllable {
        return dependency.loggedInViewController
    }
    
    var service: ToDoServiceProtocol {
        return dependency.service
    }

    var config: Variable<Config> {
        return dependency.config
    }

    init(dependency: LoggedInDependency, sessionToken: String) {
        self.sessionToken = sessionToken

        super.init(dependency: dependency)
    }
}

// MARK: - Builder

protocol LoggedInBuildable: Buildable {
    func build(withListener listener: LoggedInListener, session: String) ->
            (router: LoggedInRouting, actionableItem: LoggedInActionableItem)
}

final class LoggedInBuilder: Builder<LoggedInDependency>, LoggedInBuildable {

    override init(dependency: LoggedInDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoggedInListener, session: String) ->
            (router: LoggedInRouting, actionableItem: LoggedInActionableItem) {

        let component     = LoggedInComponent(dependency: dependency, sessionToken: session)
        let interactor    = LoggedInInteractor(sessionToken: session)
        let drawerBuilder = DrawerBuilder(dependency: component)

        interactor.listener = listener

        let router = LoggedInRouter(interactor: interactor,
                                    viewController: component.loggedInViewController,
                                    drawerBuilder: drawerBuilder)
        return (router, interactor)
    }
}
