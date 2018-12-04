//
//  DrawerComponent+Menu.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 2/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of Drawer to provide for the Menu scope.
// TODO: Update DrawerDependency protocol to inherit this protocol.
protocol DrawerDependencyMenu: Dependency {
    // TODO: Declare dependencies needed from the parent scope of Drawer to provide dependencies
    // for the Menu scope.
}

extension DrawerComponent: MenuDependency {

    // TODO: Implement properties to provide for Menu scope.
}
