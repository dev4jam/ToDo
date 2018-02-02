//
//  MenuViewController.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 2/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift
import UIKit
import Eureka

protocol MenuPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.

    func didPrepareView()
}

final class MenuViewController: FormViewController, MenuPresentable, MenuViewControllable {
    /// The UIKit view representation of this view.
    public final var uiviewController: UIViewController { return self }

    weak var listener: MenuPresentableListener?

    override func viewDidLoad() {
        super.viewDidLoad()

        listener?.didPrepareView()
    }

    // MARK: - MenuPresentable

    func showMenuItems(_ sections: [Section]) {
        LabelRow.defaultCellUpdate = { cell, row in cell.tintColor = .darkGray }
        URLRow.defaultCellUpdate = { cell, row in cell.textField.textColor = .darkGray }
        CheckRow.defaultCellSetup = { cell, row in cell.tintColor = .darkGray }
        SegmentedRow<String>.defaultCellSetup = { cell, row in cell.tintColor = .darkGray }
        PasswordRow.defaultCellSetup = { cell, row in cell.tintColor = .darkGray }
        DateRow.defaultRowInitializer = { row in row.minimumDate = Date() }
        NameRow.defaultCellSetup = { cell, row in cell.tintColor = .darkGray }
        TextAreaRow.defaultCellSetup = { cell, row in cell.tintColor = .darkGray }
        EmailRow.defaultCellSetup = { cell, row in cell.tintColor = .darkGray }
        PhoneRow.defaultCellSetup = { cell, row in cell.tintColor = .darkGray }
        SwitchRow.defaultCellSetup = { cell, row in cell.tintColor = .darkGray }
        TimeInlineRow.defaultCellSetup = { cell, row in cell.tintColor = .darkGray }
        ButtonRow.defaultCellSetup = { cell, row in
            cell.tintColor = .darkGray
            cell.accessoryType = .disclosureIndicator
            cell.textLabel?.textAlignment = .left
        }

        form.append(contentsOf: sections)
    }
}
