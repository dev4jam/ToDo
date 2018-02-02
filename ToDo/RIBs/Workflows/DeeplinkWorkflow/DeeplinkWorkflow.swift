//
//  DeeplinkWorkflow.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxSwift

public class DeeplinkWorkflow: Workflow<RootActionableItem> {
    enum FlowType {
        case task(String)
        case blankTask
        case hi
    }
    
    public init(url: URL) {
        super.init()

        let flowType = parseDeeplinkData(from: url)

        self
            .onStep { (rootItem: RootActionableItem) -> Observable<(LoggedInActionableItem, ())> in
                rootItem.waitForLogin()
            }
            .onStep { (loggedInItem: LoggedInActionableItem, _) -> Observable<(DrawerActionableItem, ())> in
                loggedInItem.waitForDrawer()
            }
            .onStep { (drawerItem: DrawerActionableItem, _) -> Observable<(ListActionableItem, ())> in
                switch flowType {
                case .hi:
                    return drawerItem.sayHi()
                default:
                    return drawerItem.waitForList()
                }
            }
            .onStep { (listItem: ListActionableItem, _) -> Observable<(ListActionableItem, ())> in
                switch flowType {
                case .blankTask:
                    return listItem.createBlankTask()
                case .task(let details):
                    return listItem.createTask(with: details)
                case .hi:
                    return listItem.doNothing()
                }
            }
            .commit()
    }

    private func parseDeeplinkData(from url: URL) -> FlowType {
        guard let host = url.host else { return .blankTask }

        let value = url.path.replacingOccurrences(of: "/", with: "")

        if host == "task" {
            return .task(value)
        } else if host == "sayhi" {
            return .hi
        }

        return .blankTask
    }
}

