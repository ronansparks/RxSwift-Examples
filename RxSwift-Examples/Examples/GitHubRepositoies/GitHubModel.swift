//
//  GitHubModel.swift
//  RxSwift-Examples
//
//  Created by Ronan on 5/30/18.
//  Copyright © 2018 RonanStudio. All rights reserved.
//

import Foundation

struct GitHubRepositories: Codable {
    var totalCount: Int!
    var incompleteResults: Bool!
    var items: [GitHubRepository]!
}

struct GitHubRepository: Codable {
    var id: Int!
    var name: String!
    var fullName: String!
    var htmlURL: String!
    var description: String!
}
