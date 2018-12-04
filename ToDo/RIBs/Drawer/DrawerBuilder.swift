//
//  LoggedOutInteractor.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift

protocol DrawerDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.

    var service: ToDoServiceProtocol { get }
    var config: Variable<Config> { get }
}

final class DrawerComponent: Component<DrawerDependency> {
    var service: ToDoServiceProtocol {
        return dependency.service
    }

    var config: Variable<Config> {
        return dependency.config
    }
}

// MARK: - Builder

protocol DrawerBuildable: Buildable {
    func build(withListener listener: DrawerListener) -> (router: DrawerRouting, actionableItem: DrawerActionableItem)
}

final class DrawerBuilder: Builder<DrawerDependency>, DrawerBuildable {

    override init(dependency: DrawerDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: DrawerListener) -> (router: DrawerRouting, actionableItem: DrawerActionableItem) {
        let screenWidth = UIScreen.main.bounds.size.width
        var menuWidth: CGFloat = screenWidth - 75.0

        if screenWidth > 375 {
            menuWidth = screenWidth - 150.0
        } else if screenWidth > 320 {
            menuWidth = screenWidth - 82.0
        }

        let component        = DrawerComponent(dependency: dependency)
        let viewController   = DrawerViewController(menuWidth: menuWidth)
        let interactor       = DrawerInteractor(presenter: viewController)

        interactor.listener  = listener
        
        let menuBuilder = MenuBuilder(dependency: component)
        let listBuilder = ListBuilder(dependency: component)

        let router = DrawerRouter(interactor: interactor, viewController: viewController,
                                  menuBuilder: menuBuilder, listBuilder: listBuilder)

        return (router, interactor)
    }
}
