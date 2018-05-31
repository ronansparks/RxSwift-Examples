//
//  GithubRepositoriesViewController.swift
//  RxSwift-Examples
//
//  Created by Ronan on 5/30/18.
//  Copyright © 2018 RonanStudio. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GitHubRepositoriesViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let searchAction = searchBar.rx.text.orEmpty.asDriver()
            .throttle(0.5)
            .distinctUntilChanged()
        
        let vm = GitHubViewModel(searchAction: searchAction)
        vm.navigationTitle
            .drive(navigationItem.rx.title)
            .disposed(by: bag)
        vm.repositories.drive(tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = element.name
            cell.detailTextLabel?.text = element.description
            return cell
        }
        .disposed(by: bag)
        
        tableView.rx.modelSelected(GitHubRepository.self)
            .subscribe(onNext: { [weak self] item in
                self?.showAlert(title: item.name, message: item.description)
            })
            .disposed(by: bag)
    }

    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}
