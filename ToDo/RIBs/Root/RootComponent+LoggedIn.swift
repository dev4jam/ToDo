//
//  RootComponent+LoggedIn.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of Root to provide for the LoggedIn scope.
// TODO: Update RootDependency protocol to inherit this protocol.
protocol RootDependencyLoggedIn: Dependency {

    // TODO: Declare dependencies needed from the parent scope of Root to provide dependencies
    // for the LoggedIn scope.
}

extension RootComponent: LoggedInDependency {    
    var loggedInViewController: LoggedInViewControllable {
        return rootViewController
    }
}
