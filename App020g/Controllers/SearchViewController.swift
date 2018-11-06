//
//  SearchViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
  
  private let viewModel = SearchViewModel()
  
  let searchController = UISearchController(searchResultsController: nil)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.setWhiteBackgroundColor()
    setNavigationBarTitle()
    setupSearchController()
    setupTableViewAppearance()
    registerTableViewCells()
  }
  
  private func setNavigationBarTitle() {
    navigationItem.title = "Поиск"
  }
  
  private func setupSearchController() {
    searchController.searchResultsUpdater = self
    searchController.searchBar.placeholder = "Введите запрос"
    searchController.hidesNavigationBarDuringPresentation = false
    searchController.dimsBackgroundDuringPresentation = false
    searchController.searchBar.tintColor = ApplicationColors.white
    
    UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: ApplicationColors.white]
    
    if #available(iOS 9.1, *) {
      searchController.obscuresBackgroundDuringPresentation = false
    }
    if #available(iOS 11.0, *) {
      navigationItem.searchController = searchController
      navigationItem.hidesSearchBarWhenScrolling = false
    } else {
      tableView.tableHeaderView = searchController.searchBar
    }
  }
  
  private func setupTableViewAppearance() {
    tableView.separatorStyle = .none
  }
  
  private func registerTableViewCells() {
    
  }
}

extension SearchViewController {
//  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    return 3
//  }
//  
//  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//  }
}

extension SearchViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    // TODO
    
  }
}
