//
//  MenuRouter.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 2/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs

protocol MenuInteractable: Interactable {
    var router: MenuRouting? { get set }
    var listener: MenuListener? { get set }
}

protocol MenuViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
}

final class MenuRouter: ViewableRouter<MenuInteractable, MenuViewControllable>, MenuRouting {

    // TODO: Constructor inject child builder protocols to allow building children.
    override init(interactor: MenuInteractable, viewController: MenuViewControllable) {
        super.init(interactor: interactor, viewController: viewController)
        interactor.router = self
    }
}
