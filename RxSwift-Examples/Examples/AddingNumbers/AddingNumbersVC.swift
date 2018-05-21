//
//  AddingNumbersVC.swift
//  RxSwift-Examples
//
//  Created by Ronan on 5/21/18.
//  Copyright © 2018 RonanStudio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

//Adding 3 input numbers
class AddingNumbersVC: ParentVC {

    @IBOutlet weak var firstTextField: UITextField!
    @IBOutlet weak var secondTextField: UITextField!
    @IBOutlet weak var thirdTextField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        Observable.combineLatest(firstTextField.rx.text.orEmpty, secondTextField.rx.text.orEmpty, thirdTextField.rx.text.orEmpty)
        {
            textValue1, textValue2, textValue3 -> Int in
            return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
        }
            .map { $0.description }
            .bind(to: resultLabel.rx.text)
            .disposed(by: disposeBag)
    }
}
