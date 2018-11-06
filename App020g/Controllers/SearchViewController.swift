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
    
    addSearchQueryListener()
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
  
  private func addSearchQueryListener() {
    
  }
}

extension SearchViewController {
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let cell = SearchBreadcrumbsCell(reuseIdentifier: "")
      cell.breadcrumbsView.breadcrumbs = viewModel.breadcrumbs
      return cell
    } else if indexPath.row == 1 {
      let cell = UITableViewCell(style: .default, reuseIdentifier: "1")
      cell.textLabel?.text = "\(viewModel.categories)"
      return cell
    } else {
      let cell = UITableViewCell(style: .default, reuseIdentifier: "2")
      cell.textLabel?.text = "\(viewModel.products)"
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 30
    } else if indexPath.row == 2 {
      return view.frame.size.height
    }
    
    return 44
  }
}

extension SearchViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    if let searchQuery = getValidQueryString(for: searchController) {
      viewModel.search(query: searchQuery) { [unowned self] in
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  }
  
  private func getValidQueryString(for searchController: UISearchController) -> String? {
    if let searchQuery = searchController.searchBar.text, searchQuery.count > 0 {
      return searchQuery
    }
    return nil
  }
}
