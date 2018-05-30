//
//  APIWrappersViewController.swift
//  RxSwift-Examples
//
//  Created by Ronan on 5/29/18.
//  Copyright © 2018 RonanStudio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class APIWrappersViewController: UIViewController {

    @IBOutlet weak var barButton: UIBarButtonItem!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textField2: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var tapButton: UIButton!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var debugLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textView2: UITextView!
    
    let bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.date = Date(timeIntervalSince1970: 0)
        
        barButton.rx.tap
            .subscribe(onNext: { [weak self] x in
                self?.debug("UIBarbuttonItem tapped")
            })
            .disposed(by: bag)
        
        
        let segmentedValue = Variable(0)
        _ = segmentedControl.rx.value <-> segmentedValue

        segmentedValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UISegmentedControl value \(x)")
            })
            .disposed(by: bag)
        
        
        let switchValue = Variable(true)
        _ = switcher.rx.value <-> switchValue
        
        switchValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UISwitch value \(x)")
            })
            .disposed(by: bag)
        
        switcher.rx.value
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: bag)
        
        
        tapButton.rx.tap
            .subscribe(onNext: { [weak self] x in
                self?.debug("UIButton tapped")
            })
            .disposed(by: bag)
        
        
        let siliderValue = Variable<Float>(1.0)
        _ = slider.rx.value <-> siliderValue
        
        siliderValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UISlider value \(x)")
            })
            .disposed(by: bag)
        
        
        let dateValue = Variable(Date(timeIntervalSince1970: 0))
        _ = datePicker.rx.date <-> dateValue
        
        dateValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UIDatePicker date \(x)")
            })
            .disposed(by: bag)
        
        
        let textValue = Variable("")
        _ = textField.rx.textInput <-> textValue
        
        textValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UITextField text \(x)")
            })
        .disposed(by: bag)
        
        
        let attributedTextValue = Variable<NSAttributedString?>(NSAttributedString(string: ""))
        _ = textField2.rx.attributedText <-> attributedTextValue
        
        attributedTextValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UITextField attributedText \(x?.description ?? "")")
            })
            .disposed(by: bag)
        
        
        let textViewValue = Variable("")
        _ = textView.rx.textInput <-> textViewValue
        
        textViewValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UITextView text \(x)")
            })
            .disposed(by: bag)
        
        let attributedTextViewValue = Variable<NSAttributedString?>(NSAttributedString(string: ""))
        _ = textView2.rx.attributedText <-> attributedTextViewValue
        
        attributedTextViewValue.asObservable()
            .subscribe(onNext: { [weak self] x in
                self?.debug("UITextView attributedText \(x?.description ?? "")")
            })
            .disposed(by: bag)
        
    }
    
    func debug(_ string: String) {
        print(string)
        debugLabel.text = "Debug: \(string)"
    }
}

extension UILabel {
    open override var accessibilityValue: String! {
        get {
            return self.text
        }
        set {
            self.text = newValue
            self.accessibilityValue = newValue
        }
    }
}
