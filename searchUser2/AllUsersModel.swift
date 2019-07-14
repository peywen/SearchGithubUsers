//
//  AllUsersModel.swift
//  searchUser2
//
//  Created by Serena on 2019/7/13.
//  Copyright © 2019 Serena. All rights reserved.
//

import UIKit

struct AllUsersModel: Codable {
    var total_count: Int?
    var incomplete_results: Bool?
    var items: [User]?
    
    enum CodingKeys: String, CodingKey {
        case total_count
        case incomplete_results
        case items
    }
}
