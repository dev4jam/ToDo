//
//  ListViewController.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift
import UIKit

protocol ListPresentableListener: class {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.

    func didSelectItem(_ item: ItemViewModel)
    func didSelectMenu()
    func didAppear()
}

final class ListViewController: UIViewController, ListPresentable, ListViewControllable {

    /// The UIKit view representation of this view.
    public final var uiviewController: UIViewController { return self }

    weak var listener: ListPresentableListener?

    @IBOutlet private weak var tableView: UITableView!

    private let tableViewCellId = "ListViewControllerItemCellId"
    private var incompleteItems: [ItemViewModel] = []
    private var completeItems: [ItemViewModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate   = self
        tableView.rowHeight  = 60

        tableView.register(UINib(nibName: "ItemCell", bundle: nil), forCellReuseIdentifier: tableViewCellId)

        view.addSubview(tableView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        listener?.didAppear()
    }

    @objc
    private func onMenuButtonTap() {
        listener?.didSelectMenu()
    }

    // MARK: - ListPresentable

    func showIncompleteItems(_ items: [ItemViewModel]) {
        incompleteItems = items

        tableView.reloadData()
    }

    func showCompletedItems(_ items: [ItemViewModel]) {
        self.completeItems = items

        tableView.reloadData()
    }

    func showTitle(_ title: String) {
        self.title = title
    }

    func showMenu() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "More", style: .plain,
                                                            target: self,
                                                            action: #selector(self.onMenuButtonTap))
    }

    func showRevertConfirmationDialog(item: ItemViewModel,
                                      listener: RevertConfirmationDialogListener) {

        let alert = UIAlertController(title: "Revert changes?", message: nil, preferredStyle: .actionSheet)

        alert.addAction(UIAlertAction(title: "Mark as incomplete", style: .destructive,
                                      handler: { (action) in
            listener.didSelectRevert(item)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    // MARK: - ListViewControllable

    func present(view: ViewControllable) {
        navigationController?.pushViewController(view.uiviewController, animated: true)
    }

    func dismiss(view: ViewControllable) {
        navigationController?.popViewController(animated: true)
    }
}

extension ListViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.section == 0 {
            listener?.didSelectItem(incompleteItems[indexPath.row])
        } else {
            listener?.didSelectItem(completeItems[indexPath.row])
        }
    }
}

extension ListViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? incompleteItems.count : completeItems.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellId) else { fatalError() }
        guard let itemCell = cell as? ItemCell else { fatalError() }

        if indexPath.section == 0 {
            itemCell.display(item: incompleteItems[indexPath.row])
        } else {
            itemCell.display(item: completeItems[indexPath.row])
        }

        return cell
    }
}
