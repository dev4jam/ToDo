//
//  LoggedInInteractor.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift

protocol LoggedInRouting: Routing {
    func cleanupViews()
    func routeToDrawer() -> DrawerActionableItem
}

protocol LoggedInListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
    func didFinishLoggedInJob()
}

final class LoggedInInteractor: Interactor, LoggedInInteractable, LoggedInActionableItem {
    weak var router: LoggedInRouting?
    weak var listener: LoggedInListener?

    var drawerActionableItem: DrawerActionableItem?

    private let sessionToken: String

    init(sessionToken: String) {
        self.sessionToken = sessionToken

        super.init()
    }

    override func didBecomeActive() {
        super.didBecomeActive()

        drawerActionableItem = router?.routeToDrawer()
    }

    override func willResignActive() {
        super.willResignActive()

        // TODO: Pause any business logic.

        router?.cleanupViews()
    }

    // MARK: - DrawerListener

    func drawerDidAppear() {
        if let drawerActionableItem = drawerActionableItem {
            drawerActionableItemSubject.onNext(drawerActionableItem)
        }

        drawerActionableItem = nil
    }

    // MARK: - LoggedInActionableItem

    func waitForDrawer() -> Observable<(DrawerActionableItem, ())> {
        return drawerActionableItemSubject
            .map { (drawerItem: DrawerActionableItem) -> (DrawerActionableItem, ()) in
                (drawerItem, ())
        }
    }

    // MARK: - Private

    private let drawerActionableItemSubject = ReplaySubject<DrawerActionableItem>.create(bufferSize: 1)
}
