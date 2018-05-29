//
//  Wireframe.swift
//  RxSwift-Examples
//
//  Created by Ronan on 5/29/18.
//  Copyright © 2018 RonanStudio. All rights reserved.
//

import RxSwift

protocol Wireframe {
    func open(url: URL)
}

class DefaultWireframe: Wireframe {
    func open(url: URL) {
        UIApplication.shared.openURL(url)
    }
    
    private static func rootViewController() -> UIViewController {
        return UIApplication.shared.keyWindow!.rootViewController!
    }
    
    static func presentAlert(_ message: String) {
        let alertController = UIAlertController(title: "RxSwift-Example", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        rootViewController().present(alertController, animated: true, completion: nil)
    }
}
