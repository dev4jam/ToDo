//
//  ListRouter.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs

protocol ListInteractable: Interactable, ItemListener {
    var router: ListRouting? { get set }
    var listener: ListListener? { get set }
}

protocol ListViewControllable: ViewControllable {
    // TODO: Declare methods the router invokes to manipulate the view hierarchy.

    func present(view: ViewControllable)
    func dismiss(view: ViewControllable)
}

final class ListRouter: LaunchRouter<ListInteractable, ListViewControllable>, ListRouting {
    private let itemBuilder: ItemBuildable
    private var child: ViewableRouting?

    // TODO: Constructor inject child builder protocols to allow building children.
    init(interactor: ListInteractable, viewController: ListViewControllable,
         itemBuilder: ItemBuildable) {

        self.itemBuilder = itemBuilder

        super.init(interactor: interactor, viewController: viewController)

        interactor.router = self
    }

    // MARK: - ListRouting

    func routeToItem(_ item: ItemViewModel) {
        let rib = itemBuilder.build(withListener: interactor, item: item)

        attachChild(rib)

        viewController.present(view: rib.viewControllable)

        child = rib
    }

    func closeItem() {
        guard let child = self.child else { return }

        detachChild(child)

        viewController.dismiss(view: child.viewControllable)

        self.child = nil
    }
}
