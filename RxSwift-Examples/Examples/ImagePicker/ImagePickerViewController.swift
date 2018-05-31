//
//  ImagePickerViewController.swift
//  RxSwift-Examples
//
//  Created by Ronan on 5/31/18.
//  Copyright © 2018 RonanStudio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ImagePickerViewController: UIViewController {

    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var cropButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let imagePicker = UIImagePickerController()
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        cameraButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                        picker.sourceType = .camera
                        picker.allowsEditing = false
                    }
                    .flatMap { $0.rx.didFinishPickingMediaWithInfo }
            }
            .map { info in
                return info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            .bind(to: imageView.rx.image)
            .disposed(by: bag)
        
        galleryButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                        picker.sourceType = .photoLibrary
                        picker.allowsEditing = false
                    
                    }
                    .flatMap { $0.rx.didFinishPickingMediaWithInfo }
            }
            .map { info in
                return info[UIImagePickerControllerOriginalImage] as? UIImage
            }
            .bind(to: imageView.rx.image)
            .disposed(by: bag)
        
        cropButton.rx.tap
            .flatMapLatest { [weak self] _ in
                return UIImagePickerController.rx.createWithParent(self) { picker in
                        picker.sourceType = .photoLibrary
                        picker.allowsEditing = true
                    }
                    .flatMap { $0.rx.didFinishPickingMediaWithInfo }
            }
            .map { info in
                return info[UIImagePickerControllerEditedImage] as? UIImage
            }
            .bind(to: imageView.rx.image)
            .disposed(by: bag)
    }
}
