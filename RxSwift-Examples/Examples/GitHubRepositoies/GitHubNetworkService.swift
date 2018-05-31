//
//  GitHubNetworkService.swift
//  RxSwift-Examples
//
//  Created by Ronan on 5/30/18.
//  Copyright © 2018 RonanStudio. All rights reserved.
//

import RxSwift
import RxCocoa

class GitHubNetworkService {
    func searchRepositories(query: String) -> Driver<GitHubRepositories> {
        return GitHubProvider.rx.request(.repositories(query))
            .filterSuccessfulStatusCodes()
            .map(GitHubRepositories.self)
            .asDriver(onErrorDriveWith: Driver.empty())
    }
}
