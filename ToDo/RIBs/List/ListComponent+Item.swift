//
//  ListComponent+Item.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs

/// The dependencies needed from the parent scope of List to provide for the Item scope.
// TODO: Update ListDependency protocol to inherit this protocol.
protocol ListDependencyItem: Dependency {
    // TODO: Declare dependencies needed from the parent scope of List to provide dependencies
    // for the Item scope.
}

extension ListComponent: ItemDependency {
    // TODO: Implement properties to provide for Item scope.
}
