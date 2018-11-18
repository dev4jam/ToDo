//
//  ItemRouter.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs

protocol ItemInteractable: Interactable {
    var router: ItemRouting? { get set }
    var listener: ItemListener? { get set }
}

protocol ItemViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class ItemRouter: ViewableRouter<ItemInteractable, ItemViewControllable>, ItemRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: ItemInteractable, viewController: ItemViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
