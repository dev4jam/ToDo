//
//  ItemViewModel.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import Foundation
import UIKit

final class ItemViewModel {
    let model: Item
    private static let dateFormatter = DateFormatter()

    init(model: Item) {
        self.model = model
    }

    var key: Int {
        return model.id
    }

    var isComplete: Bool {
        return model.isComplete
    }

    var statusColor: UIColor {
        return isComplete ? .blue : .green
    }

    var details: String {
        return model.details
    }

    var createdAt: String {
        get {
            ItemViewModel.dateFormatter.dateStyle = .short
            ItemViewModel.dateFormatter.timeStyle = .short

            return ItemViewModel.dateFormatter.string(from: model.createdAt)
        }
    }
}
