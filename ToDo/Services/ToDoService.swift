//
//  ToDoService.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import Foundation

enum ToDoServiceError: Error {
    case failedToGetItems(message: String)
    case failedToGetItemDetails(message: String)

    var message: String {
        switch self {
        case .failedToGetItems(let message),
             .failedToGetItemDetails(let message):

            return message
        }
    }
}

enum ToDoServiceListResponse {
    case error(ToDoServiceError)
    case success(items: [Item])
}

enum ToDoServiceAuthResponse {
    case error(ToDoServiceError)
    case success(sessionToken: String)
}

typealias ToDoServiceItemsCallback = ((ToDoServiceListResponse) -> Void)
typealias ToDoServiceAuthCallback  = ((ToDoServiceAuthResponse) -> Void)

protocol ToDoServiceProtocol: class {
    func requestAccessToken(login: String, password: String, callback: @escaping ToDoServiceAuthCallback)
    func getAllItems(callback: @escaping ToDoServiceItemsCallback)
    func getIncompleteItems(callback: @escaping ToDoServiceItemsCallback)
    func getCompletedItems(callback: @escaping ToDoServiceItemsCallback)
}

final class ToDoService: ToDoServiceProtocol {
    private let fakeItems: [Item] = [
        Item(id: Date().timestampInt, createdAt: Date(), details: "Run a project", isComplete: false),
        Item(id: Date().timestampInt, createdAt: Date(), details: "Add new RIB",   isComplete: false),
        Item(id: Date().timestampInt, createdAt: Date(), details: "Wire new RIB",  isComplete: false),
        Item(id: Date().timestampInt, createdAt: Date(), details: "Schedule a session", isComplete: true),
    ]

    func requestAccessToken(login: String, password: String,
                            callback: @escaping ToDoServiceAuthCallback) {

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            callback(.success(sessionToken: "owheoasdhfalsdif"))
        }
    }

    func getAllItems(callback: @escaping ToDoServiceItemsCallback) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            callback(.success(items: self.fakeItems))
        }
    }

    func getIncompleteItems(callback: @escaping ToDoServiceItemsCallback) {
        let incompleteItems = fakeItems.filter { !$0.isComplete }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            callback(.success(items: incompleteItems))
        }
    }

    func getCompletedItems(callback: @escaping ToDoServiceItemsCallback) {
        let incompleteItems = fakeItems.filter { $0.isComplete }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            callback(.success(items: incompleteItems))
        }
    }
}
