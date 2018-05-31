//
//  GithubSignupViewModel.swift
//  RxSwift-Examples
//
//  Created by Ronan on 5/30/18.
//  Copyright © 2018 RonanStudio. All rights reserved.
//

import RxSwift
import RxCocoa

class GithubSignupViewModel {
    
    let validatedUsername: Driver<ValidationResult>
    let validatedPassword: Driver<ValidationResult>
    let validatedPasswordRepeated: Driver<ValidationResult>
    
    let signupEnabled: Driver<Bool>
    let signupResult: Driver<Bool>
    let signingIn: Driver<Bool>
    
    init(input: (
            username: Driver<String>,
            password: Driver<String>,
            repeatedPassword: Driver<String>,
            loginTaps: Signal<()>
        ),
        dependency: (
            API: GithubAPI,
            validationService: GithubValidationService,
            wireframe: Wireframe
        )
    ) {
        let API = dependency.API
        let validationService = dependency.validationService
        let wireframe = dependency.wireframe
        
        validatedUsername = input.username
            .flatMap { username in
                return validationService.validateUsername(username)
                    .asDriver(onErrorJustReturn: .failed(message: "Error contacting server"))
            }
        
        validatedPassword = input.password
            .map { password in
                return validationService.validatePassword(password)
            }
        
        validatedPasswordRepeated = Driver.combineLatest(input.password, input.repeatedPassword, resultSelector: validationService.validateRepeatedPassword)
        
        let activityIndicator = ActivityIndicator()
        self.signingIn = activityIndicator.asDriver()
        
        let usernameAndPassword = Driver.combineLatest(input.username, input.password) {
            (username: $0, password: $1)
        }
        
        signupResult = input.loginTaps.withLatestFrom(usernameAndPassword)
            .flatMapLatest { pair in
                return API.signup(pair.username, password: pair.password)
                .trackActivity(activityIndicator)
                .asDriver(onErrorJustReturn: false)
            }
            .flatMapLatest { loggedIn -> Driver<Bool> in
                let message = loggedIn ? "Mock: Signed up to Github." : "Mock: Sign up to Github failed"
                return wireframe.promptFor(message, cancelAction: "OK", actions: [])
                    .map { _ in
                        loggedIn
                    }
                    .asDriver(onErrorJustReturn: false)
            }
        
        signupEnabled = Driver.combineLatest(
            validatedUsername,
            validatedPassword,
            validatedPasswordRepeated,
            signingIn
        ) { username, password, repeatedPassword, signingIn in
            username.isValid &&
            password.isValid &&
            repeatedPassword.isValid &&
            !signingIn
        }
        .distinctUntilChanged()
    }
}
