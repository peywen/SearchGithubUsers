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
    private var total_record : Int = 0
    
    func fetchData(keyWord: String) {
        currentPage = 1
        total_record = 0

        searchKeyword = keyWord
        UserService.shared.getUsers(withKeyword: searchKeyword ?? "", page: currentPage) { [weak self] (result, error) in
            if let error = error {
                print("Error:", error.localizedDescription as Any)
                self?.delegate?.showToast(with: error.localizedDescription)
                return
            }
            guard let result = result, let items = result.items else {
                self?.delegate?.showToast(with: "Reaches the API limit, plz try later")
                return
            }
            self?.total_record = result.total_count ?? 0
            self?.users = items
            self?.delegate?.reloadUI()
        }
    }
    
    func loadMore() {
        if(currentPage * count_per_page >  total_record) { return }

        currentPage = currentPage + 1;
        UserService.shared.getUsers(withKeyword: searchKeyword ?? "", page: currentPage) { [weak self] (result, error) in
            if let error = error {
                print("Error:", error.localizedDescription as Any)
                self?.delegate?.showToast(with: error.localizedDescription)
                return
            }
            guard let result = result, let items = result.items else {
                self?.delegate?.showToast(with: "Reaches the API limit, plz try later")
                return
            }
            self?.total_record = result.total_count ?? 0
            self?.users?.append(contentsOf: items)
            self?.delegate?.reloadUI()
        }
    }
}
