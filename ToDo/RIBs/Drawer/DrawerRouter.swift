//
//  LoggedOutInteractor.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift

protocol DrawerInteractable: Interactable, MenuListener, ListListener {

    var router: DrawerRouting? { get set }
    var listener: DrawerListener? { get set }
}

protocol DrawerViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.
    
    func presentContent(viewController: ViewControllable)
    func presentMenu(viewController: ViewControllable)
}

final class DrawerRouter: ViewableRouter<DrawerInteractable, DrawerViewControllable>, DrawerRouting {
    private var menuBuilder: MenuBuildable
    private var listBuilder: ListBuildable

    private (set) var menuItemChild: ViewableRouting?

    // TODO: Constructor inject child builder protocols to allow building children.
    required init(interactor: DrawerInteractable, viewController: DrawerViewControllable,
                  menuBuilder: MenuBuildable, listBuilder: ListBuildable) {

        self.menuBuilder = menuBuilder
        self.listBuilder = listBuilder

        super.init(interactor: interactor, viewController: viewController)
        
        interactor.router = self
    }
    
    override func didLoad() {
        super.didLoad()
        
        attachMenu()
    }

    func showContent() -> ListActionableItem {
        let rib = listBuilder.build(withListener: interactor)

        attachChild(rib.router)

        let navController = UINavigationController(root: rib.router.viewControllable)

        viewController.presentContent(viewController: navController)

        return rib.actionableItem
    }

    func attachMenu() {
        let rib = menuBuilder.build(withListener: interactor)
        
        attachChild(rib)
        
        viewController.presentMenu(viewController: rib.viewControllable)
    }
}
