//
//  RootInteractor.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift

protocol RootRouting: ViewableRouting {
    func routeToLoggedIn(sessionToken: String) -> LoggedInActionableItem
    func routeToLoggedOut()
}

protocol RootPresentable: Presentable {
    weak var listener: RootPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol RootListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class RootInteractor: PresentableInteractor<RootPresentable>, RootInteractable, RootPresentableListener,
RootActionableItem, UrlHandler {

    weak var router: RootRouting?
    weak var listener: RootListener?

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    override init(presenter: RootPresentable) {
        super.init(presenter: presenter)

        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.

        router?.routeToLoggedOut()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }

    private func nextAction(with session: String, animated: Bool) {
        let loggedInActionableItem = router?.routeToLoggedIn(sessionToken: session)

        if let loggedInActionableItem = loggedInActionableItem {
            loggedInActionableItemSubject.onNext(loggedInActionableItem)
        }
    }

    // MARK: - LoggedOutListener

    func didLogin(sessionToken: String) {
        let loggedInActionableItem = router?.routeToLoggedIn(sessionToken: sessionToken)

        if let loggedInActionableItem = loggedInActionableItem {
            loggedInActionableItemSubject.onNext(loggedInActionableItem)
        }
    }

    // MARK: - LoggedInListener

    func didFinishLoggedInJob() {
        router?.routeToLoggedOut()
    }

    // MARK: - UrlHandler

    func handle(_ url: URL) -> Bool{
        let deeplinkFlow = DeeplinkWorkflow(url: url)

        deeplinkFlow.subscribe(self).disposeOnDeactivate(interactor: self)

        return true
    }

    // MARK: - RootActionableItem

    func waitForLogin() -> Observable<(LoggedInActionableItem, ())> {
        return loggedInActionableItemSubject
            .map { (loggedInItem: LoggedInActionableItem) -> (LoggedInActionableItem, ()) in
                (loggedInItem, ())
        }
    }

    // MARK: - Private

    private let loggedInActionableItemSubject = ReplaySubject<LoggedInActionableItem>.create(bufferSize: 1)
}

