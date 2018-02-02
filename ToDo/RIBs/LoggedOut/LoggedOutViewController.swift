//
//  LoggedOutViewController.swift
//  ToDo
//
//  Created by Dmitry Klimkin on 1/2/18.
//  Copyright © 2018 Dev4Jam. All rights reserved.
//

import RIBs
import RxCocoa
import RxSwift
import UIKit
import TransitionButton
import SVProgressHUD

protocol LoggedOutPresentableListener: class {
    func login(withName: String?, password: String?)
}

final class LoggedOutViewController: UIViewController, LoggedOutPresentable, LoggedOutViewControllable {
    // MARK: - Private

    private let disposeBag = DisposeBag()

    @IBOutlet private var loginButton: TransitionButton!
    @IBOutlet private var usernameField: UITextField!
    @IBOutlet private var passwordField: UITextField!

    weak var listener: LoggedOutPresentableListener?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.rx.tap
            .debounce(0.5, scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let this = self else { return }

                this.usernameField.resignFirstResponder()
                this.passwordField.resignFirstResponder()
                
                this.listener?.login(withName: this.usernameField?.text, password: this.passwordField?.text)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - LoggedOutPresentable

    func showLoadingIndicator() {
        loginButton.startAnimation()
    }

    func hideLoadingIndicator() {
        loginButton.stopAnimation()
    }

    func showError(_ text: String) {
        SVProgressHUD.showError(withStatus: text)
    }
}
