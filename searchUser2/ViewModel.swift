//
//  ViewModel.swift
//  searchUser2
//
//  Created by Serena on 2019/7/13.
//  Copyright © 2019 Serena. All rights reserved.
//

import UIKit

protocol ViewModelDelegate : class {
    func reloadUI()
    func showToast(with text:String?)
}


class ViewModel: NSObject {
    weak var delegate: ViewModelDelegate?
    var users : [User]? = []
    var currentPage : Int = 1
    var searchKeyword : String? = ""
    
    func fetchData() {
        currentPage = 1
        UserService.shared.getUsers(withKeyword: searchKeyword ?? "", page: currentPage) { (users, error) in
            if let error = error {
                print("Error:", error.localizedDescription as Any)
                self.delegate?.showToast(with: error.localizedDescription)
                return
            }
            if users.count == 0 {
                self.delegate?.showToast(with: "Reaches the API limit, plz try later")
                return
            }
            self.users = users
            self.delegate?.reloadUI()
        }
    }
    
    func fetchData(keyWord: String) {
        currentPage = 1
        if searchKeyword == keyWord { return }
        
        searchKeyword = keyWord
        UserService.shared.getUsers(withKeyword: searchKeyword ?? "", page: currentPage) { (users, error) in
            if let error = error {
                print("Error:", error.localizedDescription as Any)
                self.delegate?.showToast(with: error.localizedDescription)
                return
            }
            if users.count == 0 {
                self.delegate?.showToast(with: "Reaches the API limit, plz try later")
                return
            }
            self.users = users
            self.delegate?.reloadUI()
        }
    }
    
    func loadMore() {
        currentPage = currentPage + 1;
        UserService.shared.getUsers(withKeyword: searchKeyword ?? "", page: currentPage) { (users, error) in
            if let error = error {
                print("Error:", error.localizedDescription as Any)
                self.delegate?.showToast(with: error.localizedDescription)
                return
            }
            if users.count == 0 {
                self.delegate?.showToast(with: "Reaches the API limit, plz try later")
                return
            }
            self.users?.append(contentsOf: users)
            self.delegate?.reloadUI()
        }
    }
}
