//
//  DefaultImplementations.swift
//  RxSwift-Examples
//
//  Created by Ronan on 5/30/18.
//  Copyright © 2018 RonanStudio. All rights reserved.
//

import RxSwift


class GithubDefaultAPI: GithubAPI {
    
    let session: URLSession
    
    static let sharedAPI = GithubDefaultAPI(session: URLSession.shared)
    
    init(session: URLSession) {
        self.session = session
    }
    
    /// Check username available on Github
    ///
    /// - Parameter username: new username
    /// - Returns: is username available
    func usernameAvailabel(_ username: String) -> Observable<Bool> {
        let url = URL(string: "https://github.com/\(username.URLEscaped)")!
        let request = URLRequest(url: url)
        return self.session.rx.response(request: request)
            .map { pair in
                return pair.response.statusCode == 404
            }
            .catchErrorJustReturn(false)
    }
    
    /// Mockup for sign up using random result
    ///
    /// - Parameters:
    ///   - username: input username
    ///   - password: input password
    /// - Returns: does sign up succeed
    func signup(_ username: String, password: String) -> Observable<Bool> {
        let signupResult = arc4random() % 5 == 0 ? false : true
        
        return Observable.just(signupResult)
            .delay(1.0, scheduler: MainScheduler.instance)
    }
}


class GithubDefaultValidationService: GithubValidationService {
    
    let API: GithubAPI
    static let sharedValidationService = GithubDefaultValidationService(API: GithubDefaultAPI.sharedAPI)
    let minPasswordCount = 5

    init(API: GithubAPI) {
        self.API = API
    }
    
    func validateUsername(_ username: String) -> Observable<ValidationResult> {
        if username.isEmpty {
            return .just(.empty)
        }
        
        if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
            return .just(.failed(message: "Username can only contain letters or digits"))
        }
        
        let loadingValue = ValidationResult.validating
        
        return API
            .usernameAvailabel(username)
            .map { available in
                if available {
                    return .ok(message: "Username available")
                }
                else {
                    return .failed(message: "Username already taken")
                }
            }
            .startWith(loadingValue)
    }
    
    func validatePassword(_ password: String) -> ValidationResult {
        let numberOfCharacters = password.count
        if numberOfCharacters == 0 {
            return .empty
        }
        
        if numberOfCharacters < minPasswordCount {
            return .failed(message: "Password must be at least \(minPasswordCount) characters")
        }
        
        return .ok(message: "Password acceptable")
    }
    
    func validateRepeatedPassword(_ password: String, repeatedPassword: String) -> ValidationResult {
        if repeatedPassword.count == 0 {
            return .empty
        }
        
        if repeatedPassword == password {
            return .ok(message: "Password repeated")
        }
        else {
            return .failed(message: "Password different")
        }
    }
    
    
}
