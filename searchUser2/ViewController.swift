//
//  ViewController.swift
//  searchUser2
//
//  Created by Serena on 2019/7/13.
//  Copyright © 2019 Serena. All rights reserved.
//

import UIKit
import Toaster

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UISearchBarDelegate, ViewModelDelegate {
    private let LOAD_MORE_WEHN_LESS_THAN : Int = 3
    private let NUM_OF_CELL_PER_ROW : Int = 3
    private let refreshControl = UIRefreshControl()
    var searchBar : UISearchBar
    var collectionView : UICollectionView
    var cellWidth : CGFloat
    var viewModel : ViewModel
    
    required init?(coder aDecoder: NSCoder) {
        searchBar = UISearchBar()
        cellWidth = (UIScreen.main.bounds.size.width - 8) / CGFloat(NUM_OF_CELL_PER_ROW)
        viewModel = ViewModel()

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 4.0
        layout.minimumInteritemSpacing = 4.0
        layout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupUI()
        viewModel.delegate = self
        self.viewModel.fetchData(keyWord: "")
    }
    
    func setupUI() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .yellow
        
        // searchbar UI
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[searchBar]|", options: [], metrics: nil, views: ["searchBar": searchBar]))
        
        // collectionview UI
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[collectionView(width)]|", options: [], metrics: ["width": view.frame.width], views: ["collectionView": collectionView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[searchBar(44)][collectionView]-|", options: [], metrics: nil, views: ["searchBar": searchBar, "collectionView":collectionView]))
        
        // setup CollectionView
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UserCell.self, forCellWithReuseIdentifier: "UserCell")
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        // setup SearchBar
        searchBar.showsCancelButton = true
        searchBar.delegate = self
        searchBar.placeholder = "Type Name to Search User"
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(view.endEditing)))
    }
    
    @objc private func refreshData(_ sender: Any) {
        self.viewModel.fetchData(keyWord: self.searchBar.text ?? "")
    }
    
    //  MARK: Collection View Delegates
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.users?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UserCell", for: indexPath) as! UserCell
        myCell.backgroundColor = UIColor.lightGray
        myCell.updateCellWithModel(model: self.viewModel.users?[indexPath.row])

        return myCell
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let count = self.viewModel.users?.count, count - indexPath.row < LOAD_MORE_WEHN_LESS_THAN else { return }
        
        self.viewModel.loadMore()
    }
    
    // MARK: Search Bar Delegate
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchText = searchBar.text ?? ""
        self.viewModel.fetchData(keyWord: searchText)
        searchBar.resignFirstResponder()
    }

    
    // MARK: ViewModelDelegate
    func reloadUI() {
        self.refreshControl.endRefreshing()
        self.collectionView.reloadData()
    }
    
    func showToast(with text: String?) {
        Toast(text:text).show()
    }
}

