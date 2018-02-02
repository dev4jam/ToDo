//
//  LoadingPresentable.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import UIKit
import SVProgressHUD

protocol LoadingPresentable: class {
    func showLoading(with status: String?)
    func showSuccess(with status: String?)
    func showError(with status: String?)

    func hideLoading()
}

extension UIViewController: LoadingPresentable {
    func showLoading(with status: String?) {
        SVProgressHUD.show(withStatus: status)
    }

    func showSuccess(with status: String?) {
        SVProgressHUD.showSuccess(withStatus: status)
    }

    func showError(with status: String?) {
        SVProgressHUD.showError(withStatus: status)
    }

    func hideLoading() {
        SVProgressHUD.dismiss()
    }
}

