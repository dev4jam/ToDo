//
//  ItemBuilder.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift

protocol ItemDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.

    var config: Variable<Config> { get }
    var service: ToDoServiceProtocol { get }
}

final class ItemComponent: Component<ItemDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.

    var config: Variable<Config> {
        return dependency.config
    }

    var service: ToDoServiceProtocol {
        return dependency.service
    }
}

// MARK: - Builder

protocol ItemBuildable: Buildable {
    func build(withListener listener: ItemListener, item: ItemViewModel) -> ItemRouting
}

final class ItemBuilder: Builder<ItemDependency>, ItemBuildable {

    override init(dependency: ItemDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: ItemListener, item: ItemViewModel) -> ItemRouting {
        let component      = ItemComponent(dependency: dependency)
        let viewController = ItemViewController()
        let interactor     = ItemInteractor(presenter: viewController, item: item,
                                            service: component.service,
                                            config: component.config)
        interactor.listener = listener

        return ItemRouter(interactor: interactor, viewController: viewController)
    }
}
