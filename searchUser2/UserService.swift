//
//  UserService.swift
//  searchUser2
//
//  Created by Serena on 2019/7/13.
//  Copyright © 2019 Serena. All rights reserved.
//

import Foundation
import Alamofire

//static SEARCH_USER_API = "https://api.github.com/search/users?q=simon"

public let count_per_page : Int = 60

class UserService: NSObject {
    public let count_per_page : Int = 60
    public static let shared: UserService = UserService()
    
    public func getUsers(withKeyword keyword:String, page:Int, completion: @escaping (_ users: AllUsersModel?, _ error: Error?)->()) {
        var urlString:String
        if(keyword.isEmpty) {
            urlString = "https://api.github.com/search/users?q=abc"
        } else {
            urlString = "https://api.github.com/search/users?q="+keyword
        }
        
        Alamofire.request(urlString,
                          method: .get,
                          parameters: ["per_page": count_per_page, "page": page])
            .responseJSON { (response) in
                                
                if(response.result.isSuccess) {
                    if let data = response.data, let allData = try? JSONDecoder().decode(AllUsersModel.self, from: data)
                    {
                        completion(allData, response.error)
                        return
                    }
                }
                completion(nil, response.error)
        }
    }
}
