//
//  LoggedOutBuilder.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift

protocol LoggedOutDependency: Dependency {
    // TODO: Declare the set of dependencies required by this RIB, but cannot be
    // created by this RIB.
    
    var service: ToDoServiceProtocol { get }
    var config: Variable<Config> { get }
}

final class LoggedOutComponent: Component<LoggedOutDependency> {

    // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.

    var service: ToDoServiceProtocol {
        return dependency.service
    }

    var config: Variable<Config> {
        return dependency.config
    }
}

// MARK: - Builder

protocol LoggedOutBuildable: Buildable {
    func build(withListener listener: LoggedOutListener) -> LoggedOutRouting
}

final class LoggedOutBuilder: Builder<LoggedOutDependency>, LoggedOutBuildable {

    override init(dependency: LoggedOutDependency) {
        super.init(dependency: dependency)
    }

    func build(withListener listener: LoggedOutListener) -> LoggedOutRouting {
        let component      = LoggedOutComponent(dependency: dependency)
        let viewController = LoggedOutViewController(nibName: "LoggedOutViewController", bundle: Bundle.main)
        let interactor     = LoggedOutInteractor(presenter: viewController,
                                                 service: component.service,
                                                 config: component.config)
        interactor.listener = listener
        
        return LoggedOutRouter(interactor: interactor, viewController: viewController)
    }
}
