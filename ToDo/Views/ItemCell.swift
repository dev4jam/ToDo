//
//  ItemCell.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import UIKit

final class ItemCell: UITableViewCell {
    @IBOutlet private weak var detailsLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var statusIndicator: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func display(item: ItemViewModel) {
        detailsLabel.text               = item.details
        timeLabel.text                  = item.createdAt
        statusIndicator.backgroundColor = item.statusColor
    }
}
