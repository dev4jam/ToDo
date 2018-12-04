//
//  ListBuilder.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift

protocol ListDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.

    var service: ToDoServiceProtocol { get }
    var config: Variable<Config> { get }
}

final class ListComponent: Component<ListDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.

    var service: ToDoServiceProtocol {
        return dependency.service
    }

    var config: Variable<Config> {
        return dependency.config
    }
}

// MARK: - Builder

protocol ListBuildable: Buildable {
    func build(withListener listener: ListListener) -> (router: ListRouting, actionableItem: ListActionableItem)
}

final class ListBuilder: Builder<ListDependency>, ListBuildable {

    override init(dependency: ListDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ListListener) -> (router: ListRouting, actionableItem: ListActionableItem) {
        let component      = ListComponent(dependency: dependency)
        let viewController = ListViewController(nibName: "ListViewController", bundle: Bundle.main)
        let itemBuilder    = ItemBuilder(dependency: component)
        let interactor     = ListInteractor(presenter: viewController,
                                            service: component.service,
                                            config: component.config)
        interactor.listener = listener

        let router = ListRouter(interactor: interactor, viewController: viewController,
                                itemBuilder: itemBuilder)

        return (router, interactor)
    }
}
