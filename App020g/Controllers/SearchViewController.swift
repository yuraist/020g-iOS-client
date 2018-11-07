//
//  SearchViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController {
  
  private let searchController = UISearchController(searchResultsController: nil)
  private let viewModel = SearchViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.setWhiteBackgroundColor()
    setNavigationBarTitle()
    setupSearchController()
    setupTableViewAppearance()
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
      
      let cell = SearchCategoriesTableViewCell(reuseIdentifier: nil)
      cell.categoriesCollectionView.categories = viewModel.categories
      return cell
      
    } else {
      
      let cell = SearchCatalogTableViewCell(reuseIdentifier: nil)
      cell.catalogCollectionView.products = viewModel.products
      return cell
    }
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 30
    } else if indexPath.row == 1 {
      return estimatedCategoriesCollectionViewHeight()
    } else if indexPath.row == 2 {
      return view.frame.size.height
    }
    
    return 180
  }
  
  private func estimatedCategoriesCollectionViewHeight() -> CGFloat {
    let top = 8
    let bottom = 8
    let lineHeight = 38
    let interlineOffset = 8
    
    var width = CGFloat(view.frame.width - 16)
    var lines = 1
    
    for category in viewModel.categories {
      let categoryWidth = category.text.estimatedWidth()
      if width - categoryWidth < 0 {
        lines += 1
        width = 304 - categoryWidth
      } else {
        width -= categoryWidth
      }
    }
    
    let estimatedHeight = CGFloat(lineHeight * lines + interlineOffset * (lines - 1) + top + bottom)
    return estimatedHeight
  }
  
  private func reloadTableViewAsynchronously() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
}

extension SearchViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchQuery = getValidQueryString(for: searchController) else {
      return
    }
    
    viewModel.search(query: searchQuery) { [unowned self] in
      self.reloadTableViewAsynchronously()
    }
  }
  
  private func getValidQueryString(for searchController: UISearchController) -> String? {
    if let searchQuery = searchController.searchBar.text, searchQuery.count > 0 {
      return searchQuery
    }
    return nil
  }
}
