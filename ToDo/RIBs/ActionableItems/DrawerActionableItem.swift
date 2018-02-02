//
//  DrawerActionableItem.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RxSwift

public protocol DrawerActionableItem: class {
    func waitForList() -> Observable<(ListActionableItem, ())>
    func sayHi() -> Observable<(ListActionableItem, ())>
}

