//
//  DrawerComponent+List.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of Drawer to provide for the List scope.
// TODO: Update DrawerDependency protocol to inherit this protocol.
protocol DrawerDependencyList: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Drawer to provide dependencies
    // for the List scope.
}

extension DrawerComponent: ListDependency {
    // TODO: Implement properties to provide for List scope.
}
