//
//  RootActionableItem.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RxSwift

public protocol RootActionableItem: class {
    func waitForLogin() -> Observable<(LoggedInActionableItem, ())>
}
