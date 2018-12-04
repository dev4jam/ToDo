//
//  ListActionableItem.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 2/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RxSwift

public protocol ListActionableItem: class {
    func createTask(with description: String) -> Observable<(ListActionableItem, ())>
    func createBlankTask() -> Observable<(ListActionableItem, ())>
    func doNothing() -> Observable<(ListActionableItem, ())>
}
