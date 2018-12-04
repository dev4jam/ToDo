//
//  MenuInteractor.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 2/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift
import Eureka

protocol MenuRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol MenuPresentable: Presentable {
    var listener: MenuPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.

    func showMenuItems(_ sections: [Section])
}

protocol MenuListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.

    func didSelectMenu(_ menuItem: String)
}

final class MenuInteractor: PresentableInteractor<MenuPresentable>, MenuInteractable, MenuPresentableListener {

    weak var router: MenuRouting?
    weak var listener: MenuListener?

    private let service: ToDoServiceProtocol
    private let config: Variable<Config>

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: MenuPresentable, service: ToDoServiceProtocol, config: Variable<Config>) {
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

    // MARK: - MenuPresentableListener
    
    func didPrepareView() {
        var form: [Section] = []
        var section = Section("Support")

        form.append(section)

        var buttonRow = ButtonRow(tag: "feedback")

        buttonRow.title = "Feedback"

        buttonRow.onCellSelection { [unowned self] (cell, row) in
            self.onFeedbackTap()
        }

        buttonRow.cellUpdate { (cell, row) in
            cell.tintColor = .darkGray
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textAlignment = .left
        }

        section.append(buttonRow)

        buttonRow = ButtonRow(tag: "share")

        buttonRow.title = "Share"

        buttonRow.onCellSelection { [unowned self] (cell, row) in
            self.onShareTap()
        }

        buttonRow.cellUpdate { (cell, row) in
            cell.tintColor = .darkGray
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textAlignment = .left
        }

        section.append(buttonRow)

        buttonRow = ButtonRow(tag: "rate")

        buttonRow.title = "Rate us"

        buttonRow.onCellSelection { [unowned self] (cell, row) in
            self.onRateTap()
        }

        buttonRow.cellUpdate { (cell, row) in
            cell.tintColor = .darkGray
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textAlignment = .left
        }

        section.append(buttonRow)

        section = Section("Extra")

        form.append(section)

        buttonRow = ButtonRow(tag: "tos")

        buttonRow.title = "Terms and Conditions"

        buttonRow.onCellSelection { [unowned self] (cell, row) in
            self.onTermsOfServiceTap()
        }

        buttonRow.cellUpdate { (cell, row) in
            cell.tintColor = .darkGray
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textAlignment = .left
        }

        section.append(buttonRow)

        buttonRow = ButtonRow(tag: "pp")

        buttonRow.title = "Privacy Policy"

        buttonRow.onCellSelection { [unowned self] (cell, row) in
            self.onPrivacyPolicyTap()
        }

        buttonRow.cellUpdate { (cell, row) in
            cell.tintColor = .darkGray
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textAlignment = .left
        }

        section.append(buttonRow)

        section = Section()

        form.append(section)

        let labelRow = LabelRow(tag: "version")

        labelRow.title = "Version"
        labelRow.value = "\(config.value.appVersion) (\(config.value.buildNumber))"

        section.append(labelRow)

        presenter.showMenuItems(form)
    }

    private func onFeedbackTap() {
        listener?.didSelectMenu("Feedback")
    }

    private func onShareTap() {
        listener?.didSelectMenu("Share")
    }

    private func onRateTap() {
        listener?.didSelectMenu("Rate us")
    }

    private func onTermsOfServiceTap() {
        listener?.didSelectMenu("Terms of Service")
    }

    private func onPrivacyPolicyTap() {
        listener?.didSelectMenu("Privacy Policy")
    }
}
