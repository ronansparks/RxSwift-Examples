//
//  SimpleValidationVC.swift
//  RxSwift-Examples
//
//  Created by Ronan on 5/21/18.
//  Copyright © 2018 RonanStudio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

fileprivate let minimalUsernameLength = 5
fileprivate let minimalPasswordLength = 5

//Validate username & password
class SimpleValidationVC: ParentVC {

    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var usernameErrorLabel: UILabel!
    
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var passwordErrorLabel: UILabel!
    
    @IBOutlet var doSomethingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        usernameTextField.placeholder = "at least \(minimalUsernameLength) characters"
        passwordTextField.placeholder = "at least \(minimalPasswordLength) characters"
        
        //Valid username, password length
        let usernameValid = usernameTextField.rx.text.orEmpty
            .map{ $0.count >= minimalUsernameLength }
            .share(replay: 1)
        
        let passwordValid = passwordTextField.rx.text.orEmpty
            .map{ $0.count >= minimalPasswordLength }
            .share(replay: 1)
        
        let bothValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)
        
        //bind username, password validation to other controls
        usernameValid
            .bind(to: passwordTextField.rx.isEnabled)
            .disposed(by: disposeBag)
        
        usernameValid
            .bind(to: usernameErrorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        passwordValid
            .bind(to: passwordErrorLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        
        bothValid
            .bind(to: doSomethingButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        //button TouchUpInside event
        doSomethingButton.rx.tap
            .subscribe(onNext: {
                [weak self] _ in
                self?.showAlert()
            })
            .disposed(by: disposeBag)
    }

    
    func showAlert() {
        let alertVC = UIAlertController(title: "Simple Validation", message: "Enjoy this?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
        alertVC.addAction(okAction)
        present(alertVC, animated: true, completion: nil)
    }
}
