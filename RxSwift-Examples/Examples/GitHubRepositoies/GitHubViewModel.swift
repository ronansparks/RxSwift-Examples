//
//  GitHubViewModel.swift
//  RxSwift-Examples
//
//  Created by Ronan on 5/30/18.
//  Copyright © 2018 RonanStudio. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GitHubViewModel {
    
    let networkService = GitHubNetworkService()
    // search
    fileprivate let searchAction: Driver<String>
    
    // search result
    let searchResult: Driver<GitHubRepositories>
    
    // result list
    let repositories: Driver<[GitHubRepository]>
    
    let cleanResult: Driver<Void>
    
    let navigationTitle: Driver<String>
    
    init(searchAction: Driver<String>) {
        self.searchAction = searchAction
        
        searchResult = searchAction
            .filter { !$0.isEmpty }
            .flatMapLatest(networkService.searchRepositories)
        
        self.cleanResult = searchAction.filter { $0.isEmpty }.map { _ in Void() }
        
        self.repositories = Driver.merge(
            searchResult.map { $0.items },
            cleanResult.map {[]}
        )
        
        self.navigationTitle = Driver.merge(
            searchResult.map { "\($0.totalCount) results" },
            cleanResult.map { "GitHub" }
        )
    }
}
