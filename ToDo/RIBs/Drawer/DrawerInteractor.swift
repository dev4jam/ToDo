//
//  LoggedOutInteractor.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift

protocol DrawerRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.

    func showContent() -> ListActionableItem
}

protocol DrawerPresentable: Presentable {
    var listener: DrawerPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.

    func showSelectedMenuItem(_ menuItem: String)
    func showMenu()
    func hideMenu()
    func showHi()
}

protocol DrawerListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.

    func drawerDidAppear()
}

final class DrawerInteractor: PresentableInteractor<DrawerPresentable>, DrawerInteractable,
                              DrawerPresentableListener, DrawerActionableItem {

    weak var router: DrawerRouting?
    weak var listener: DrawerListener?

    var listActionableItem: ListActionableItem?

    private var isMenuOpened: Bool = false
    private let listActionableItemSubject = ReplaySubject<ListActionableItem>.create(bufferSize: 1)

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: DrawerPresentable) {
        super.init(presenter: presenter)
        
        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.

        listActionableItem = router?.showContent()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }
    
    // MARK: - DrawerPresentableListener
    
    func didOpenMenu() {
        isMenuOpened = true
    }
    
    func didCloseMenu() {
        isMenuOpened = false
    }

    func didAppear() {
        listener?.drawerDidAppear()
    }
    
    // MARK: - MenuListener
    
    func didSelectMenu(_ menuItem: String) {
        presenter.hideMenu()
        presenter.showSelectedMenuItem(menuItem)
    }

    // MARK: - ListListener
    func listDidAppear() {
        if let listActionableItem = listActionableItem {
            listActionableItemSubject.onNext(listActionableItem)
        }

        listActionableItem = nil
    }

    func didSelectMenu() {
        presenter.showMenu()
    }

    // MARK: - DrawerActionableItem

    func waitForList() -> Observable<(ListActionableItem, ())> {
        return listActionableItemSubject
            .map { (listItem: ListActionableItem) -> (ListActionableItem, ()) in
                (listItem, ())
        }
    }

    func sayHi() -> Observable<(ListActionableItem, ())> {
        presenter.showHi()

        return listActionableItemSubject
            .map { (listItem: ListActionableItem) -> (ListActionableItem, ()) in
                (listItem, ())
        }
    }
}
