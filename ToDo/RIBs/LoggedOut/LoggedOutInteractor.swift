//
//  LoggedOutInteractor.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift

protocol LoggedOutRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol LoggedOutPresentable: Presentable {
    weak var listener: LoggedOutPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.
    
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showError(_ text: String)
}

protocol LoggedOutListener: class {
    func didLogin(sessionToken: String)
}

final class LoggedOutInteractor: PresentableInteractor<LoggedOutPresentable>, LoggedOutInteractable,
                                 LoggedOutPresentableListener {

    weak var router: LoggedOutRouting?
    weak var listener: LoggedOutListener?

    private let service: ToDoServiceProtocol
    private let config: Variable<Config>

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: LoggedOutPresentable, service: ToDoServiceProtocol, config: Variable<Config>) {
        self.service = service
        self.config  = config

        super.init(presenter: presenter)

        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.        
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }

    // MARK: - LoggedOutPresentableListener

    func login(withName userName: String?, password: String?) {
        guard let name = userName, let pass = password else { return }

        if name.isEmpty || pass.isEmpty {
            presenter.showError("Missing username or password")

            return
        }

        presenter.showLoadingIndicator()
        
        // TODO: Here should be a service call to request an access token
        service.requestAccessToken(login: name, password: pass) { [weak self] (response) in
            guard let this = self else { return }

            this.presenter.hideLoadingIndicator()

            switch response {
            case .success(let token):
                this.listener?.didLogin(sessionToken: token)
            default:
                break
            }
        }
    }
}
