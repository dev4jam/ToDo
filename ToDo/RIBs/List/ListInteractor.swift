//
//  ListInteractor.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift

protocol RevertConfirmationDialogListener: class {
    func didSelectRevert(_ item: ItemViewModel)
}

protocol ListRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.

    func routeToItem(_ item: ItemViewModel)
    func closeItem()
}

protocol ListPresentable: Presentable, LoadingPresentable {
    weak var listener: ListPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.

    func showIncompleteItems(_ items: [ItemViewModel])
    func showCompletedItems(_ items: [ItemViewModel])
    func showTitle(_ title: String)
    func showMenu()

    func showRevertConfirmationDialog(item: ItemViewModel,
                                      listener: RevertConfirmationDialogListener)
}

protocol ListListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.

    func listDidAppear()
    func didSelectMenu()
}

final class ListInteractor: PresentableInteractor<ListPresentable>, ListInteractable,
                            ListPresentableListener, RevertConfirmationDialogListener,
                            ListActionableItem {

    weak var router: ListRouting?
    weak var listener: ListListener?

    private let service: ToDoServiceProtocol
    private let config: Variable<Config>

    private var incompleItems: [ItemViewModel] = []
    private var completedItems: [ItemViewModel] = []

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: ListPresentable, service: ToDoServiceProtocol, config: Variable<Config>) {
        self.service = service
        self.config  = config

        super.init(presenter: presenter)

        presenter.listener = self
    }

    override func didBecomeActive() {
        super.didBecomeActive()
        // TODO: Implement business logic here.

        reloadItems()
        
        presenter.showTitle("ToDo List")
        presenter.showMenu()
    }

    override func willResignActive() {
        super.willResignActive()
        // TODO: Pause any business logic.
    }

    private func reloadItems() {
        presenter.showLoading(with: "Loading...")

        service.getIncompleteItems { [weak self] (response) in
            guard let this = self else { return }

            this.presenter.hideLoading()

            switch response {
            case .success(let items):
                let itemVMs = items.map { ItemViewModel(model: $0) }

                this.incompleItems = itemVMs

                this.presenter.showIncompleteItems(itemVMs)
                this.reloadCompletedItems()
            case .error(let error):
                this.presenter.showError(with: error.message)
            }
        }
    }

    private func reloadCompletedItems() {
        presenter.showLoading(with: "Loading...")

        service.getCompletedItems { [weak self] (response) in
            guard let this = self else { return }

            this.presenter.hideLoading()

            switch response {
            case .success(let items):
                let itemVMs = items.map { ItemViewModel(model: $0) }

                this.completedItems = itemVMs

                this.presenter.showCompletedItems(itemVMs)
            case .error(let error):
                this.presenter.showError(with: error.message)
            }
        }
    }

    // MARK: - ListPresentableListener

    func didAppear() {
        listener?.listDidAppear()
    }

    func didSelectItem(_ item: ItemViewModel) {
        if item.isComplete {
            presenter.showRevertConfirmationDialog(item: item, listener: self)
        } else {
            router?.routeToItem(item)
        }
    }

    func didSelectMenu() {
        listener?.didSelectMenu()
    }

    // MARK: - ItemListener

    func closeItem() {
        router?.closeItem()
    }

    func didUpdateItemDetails(_ item: ItemViewModel) {
        router?.closeItem()

        guard let index = incompleItems.index(where: { (model) -> Bool in
            return model.key == item.key
        }) else { return }

        incompleItems[index] = item

        presenter.showIncompleteItems(incompleItems)
    }

    func didMarkAsDone(_ item: ItemViewModel) {
        router?.closeItem()

        completedItems.append(item)

        presenter.showCompletedItems(completedItems)

        guard let index = incompleItems.index(where: { (model) -> Bool in
            return model.key == item.key
        }) else { return }

        incompleItems.remove(at: index)
        presenter.showIncompleteItems(incompleItems)
    }

    // MARK: - RevertConfirmationDialogListener

    func didSelectRevert(_ item: ItemViewModel) {
        let newItem = Item(id: item.key,
                           createdAt: item.model.createdAt,
                           details: item.details,
                           isComplete: false)

        incompleItems.append(ItemViewModel(model: newItem))
        presenter.showIncompleteItems(incompleItems)

        guard let index = completedItems.index(where: { (model) -> Bool in
            return model.key == item.key
        }) else { return }

        completedItems.remove(at: index)
        presenter.showCompletedItems(completedItems)
    }

    // MARK: - ListActionableItem

    func createTask(with description: String) -> Observable<(ListActionableItem, ())> {
        let newItem = Item(id: Date().timestampInt, createdAt: Date(), details: description, isComplete: false)

        incompleItems.append(ItemViewModel(model: newItem))

        presenter.showIncompleteItems(incompleItems)

        return Observable.just((self, ()))
    }

    func createBlankTask() -> Observable<(ListActionableItem, ())> {
        let newItem = Item(id: Date().timestampInt, createdAt: Date(), details: "", isComplete: false)
        let itemVM = ItemViewModel(model: newItem)

        incompleItems.append(itemVM)

        presenter.showIncompleteItems(incompleItems)

        router?.routeToItem(itemVM)

        return Observable.just((self, ()))
    }

    func doNothing() -> Observable<(ListActionableItem, ())> {
        return Observable.just((self, ()))
    }

}
