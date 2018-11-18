//
//  ItemViewController.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol ItemPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.

    func didChangeDetails(_ value: String)
    func didMarkAsDone()
    func didSave()
    func didPrepareView()
    func didNavigateBack()
}

final class ItemViewController: UIViewController, ItemPresentable, ItemViewControllable, UITextFieldDelegate {

    /// The UIKit view representation of this view.
    public final var uiviewController: UIViewController { return self }

    weak var listener: ItemPresentableListener?

    @IBOutlet private weak var detailsField: UITextField!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var saveButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        listener?.didPrepareView()
    }

    @IBAction private func onSaveButtonTap() {
        listener?.didChangeDetails(detailsField.text ?? "")
        listener?.didSave()
    }

    @IBAction private func onDoneButtonTap() {
        listener?.didChangeDetails(detailsField.text ?? "")
        listener?.didMarkAsDone()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

		if isMovingFromParent {
            listener?.didNavigateBack()
        }
    }

    // MARK: - ItemPresentable

    func showDetails(_ value: String) {
        detailsField.text = value
    }

    func showTitle(_ title: String) {
        self.title = title
    }
}
