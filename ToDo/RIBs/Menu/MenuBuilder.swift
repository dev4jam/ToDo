//
//  MenuBuilder.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 2/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift

protocol MenuDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.

    var service: ToDoServiceProtocol { get }
    var config: Variable<Config> { get }
}

final class MenuComponent: Component<MenuDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.

    var service: ToDoServiceProtocol {
        return dependency.service
    }

    var config: Variable<Config> {
        return dependency.config
    }
}

// MARK: - Builder

protocol MenuBuildable: Buildable {
    func build(withListener listener: MenuListener) -> MenuRouting
}

final class MenuBuilder: Builder<MenuDependency>, MenuBuildable {

    override init(dependency: MenuDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: MenuListener) -> MenuRouting {
        let component      = MenuComponent(dependency: dependency)
        let viewController = MenuViewController(nibName: "MenuViewController", bundle: Bundle.main)
        let interactor     = MenuInteractor(presenter: viewController,
                                            service: component.service,
                                            config: component.config)
        interactor.listener = listener

        return MenuRouter(interactor: interactor, viewController: viewController)
    }
}
