//
//  GithubSignupViewController.swift
//  RxSwift-Examples
//
//  Created by Ronan on 5/30/18.
//  Copyright © 2018 RonanStudio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GithubSignupViewController: UIViewController {

    @IBOutlet weak var usernameInput: UITextField!
    @IBOutlet weak var usernameValidationLabel: UILabel!
    @IBOutlet weak var passwordInput: UITextField!
    @IBOutlet weak var passwordValidationLabel: UILabel!
    @IBOutlet weak var repeatedPasswordInput: UITextField!
    @IBOutlet weak var repeatedPasswordValidationLabel: UILabel!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var signingUpIndicator: UIActivityIndicatorView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = GithubSignupViewModel(
            input: (
                username: usernameInput.rx.text.orEmpty.asDriver(),
                password: passwordInput.rx.text.orEmpty.asDriver(),
                repeatedPassword: repeatedPasswordInput.rx.text.orEmpty.asDriver(),
                loginTaps: signupButton.rx.tap.asSignal()
            ),
            dependency: (
                API: GithubDefaultAPI.sharedAPI,
                validationService: GithubDefaultValidationService.sharedValidationService,
                wireframe: DefaultWireframe.shared
            )
        )
        
        viewModel.signupEnabled
            .drive(onNext: { [weak self] valid in
                self?.signupButton.isEnabled = valid
                self?.signupButton.alpha = valid ? 1.0 : 0.5
            })
            .disposed(by: bag)
        
        viewModel.validatedUsername
            .drive(usernameValidationLabel.rx.validationResult)
            .disposed(by: bag)
        
        viewModel.validatedPassword
            .drive(passwordValidationLabel.rx.validationResult)
            .disposed(by: bag)
        
        viewModel.validatedPasswordRepeated
            .drive(repeatedPasswordValidationLabel.rx.validationResult)
            .disposed(by: bag)
        
        viewModel.signingIn
            .drive(signingUpIndicator.rx.isAnimating)
            .disposed(by: bag)
        
        viewModel.signupResult
            .drive(onNext: { signedIn in
                print("User signed in \(signedIn)")
            })
            .disposed(by: bag)
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.view.endEditing(true)
            })
            .disposed(by: bag)
        view.addGestureRecognizer(tapBackground)
    }
}
