//
//  ItemInteractor.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift

protocol ItemRouting: ViewableRouting {
    // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol ItemPresentable: Presentable {
    var listener: ItemPresentableListener? { get set }
    // TODO: Declare methods the interactor can invoke the presenter to present data.

    func showTitle(_ title: String)
    func showDetails(_ value: String)
}

protocol ItemListener: class {
    // TODO: Declare methods the interactor can invoke to communicate with other RIBs.

    func closeItem()
    func didUpdateItemDetails(_ item: ItemViewModel)
    func didMarkAsDone(_ item: ItemViewModel)
}

final class ItemInteractor: PresentableInteractor<ItemPresentable>, ItemInteractable, ItemPresentableListener {

    weak var router: ItemRouting?
    weak var listener: ItemListener?

    private let item: ItemViewModel
    private let service: ToDoServiceProtocol
    private let config: Variable<Config>
    private var newDetails: String

    // TODO: Add additional dependencies to constructor. Do not perform any logic
    // in constructor.
    init(presenter: ItemPresentable, item: ItemViewModel,
         service: ToDoServiceProtocol, config: Variable<Config>) {

        self.item       = item
        self.config     = config
        self.service    = service
        self.newDetails = item.details

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

    // MARK: - ItemPresentableListener

    func didNavigateBack() {
        listener?.closeItem()
    }
    
    func didPrepareView() {
        presenter.showTitle("ToDo")
        presenter.showDetails(item.details)
    }

    func didChangeDetails(_ value: String) {
        newDetails = value
    }

    func didMarkAsDone() {
        let newItem = Item(id: item.key,
                           createdAt: item.model.createdAt,
                           details: newDetails,
                           isComplete: true)

        listener?.didMarkAsDone(ItemViewModel(model: newItem))
    }

    func didSave() {
        let newItem = Item(id: item.key,
                           createdAt: item.model.createdAt,
                           details: newDetails,
                           isComplete: item.model.isComplete)

        listener?.didUpdateItemDetails(ItemViewModel(model: newItem))
    }
}
