//
//  SearchViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class SearchViewController: UICollectionViewController {
  
  private let breadcrumbsCellId = "breadcrumbsCell"
  private let categoryCellId = "categoryCell"
  private let productCellId = "productCell"
  
  private let searchController = UISearchController(searchResultsController: nil)
  private let viewModel = SearchViewModel()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.setGrayBackgroundColor()
    
    setNavigationBarTitle()
    setupSearchController()
    
    registerCollectionViewCells()
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
    
    if #available(iOS 9.1, *) {
      searchController.obscuresBackgroundDuringPresentation = false
    }
    
    if #available(iOS 11.0, *) {
      navigationItem.searchController = searchController
      navigationItem.hidesSearchBarWhenScrolling = false
      UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: ApplicationColors.white]
    } else {
      // TODO: - Implement search bar for iOS < 11.0
      searchController.searchBar.tintColor = ApplicationColors.black
      navigationItem.titleView = searchController.searchBar
    }
  }
  
  private func registerCollectionViewCells() {
    collectionView.register(SearchBreadcrumbsCell.self, forCellWithReuseIdentifier: breadcrumbsCellId)
    collectionView.register(SearchCategoryCollectionViewCell.self, forCellWithReuseIdentifier: categoryCellId)
    collectionView.register(SearchCatalogCollectionViewCell.self, forCellWithReuseIdentifier: productCellId)
  }
}

// MARK: - UICollectionViewDataSource

extension SearchViewController {
  
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 3
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 0 {
      return 1
    } else if section == 1 {
      return viewModel.categories.count
    }
    
    return viewModel.products.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    if indexPath.section == 0 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: breadcrumbsCellId, for: indexPath) as! SearchBreadcrumbsCell
      cell.breadcrumbsView.breadcrumbs = viewModel.breadcrumbs
      return cell
    } else if indexPath.section == 1 {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellId, for: indexPath) as! SearchCategoryCollectionViewCell
      cell.label.text = viewModel.categories[indexPath.item].text
      return cell
    } else {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productCellId, for: indexPath) as! SearchCatalogCollectionViewCell
      cell.product = viewModel.products[indexPath.item]
      
      if last(index: indexPath) {
        fetchNextPage()
      }
      
      return cell
    }
  }
  
  private func last(index: IndexPath) -> Bool {
    return index.item == viewModel.products.count - 1
  }
  
  private func fetchNextPage() {
    viewModel.fetchNextPage { [unowned self] in
      self.reloadCollectionViewAsynchronously()
    }
    
  }
  
  private func reloadCollectionViewAsynchronously() {
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
}

// MARK: - UICollectionViewFlowLayoutDelegate

extension SearchViewController: UICollectionViewDelegateFlowLayout {
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if indexPath.section == 0 {
      return CGSize(width: collectionView.frame.size.width, height: 24)
    } else if indexPath.section == 1 {
      let category = viewModel.categories[indexPath.item]
      let width = category.text.estimatedWidth()
      return CGSize(width: width, height: 38)
    } else {
      return CGSize(width: collectionView.frame.size.width/2 - 1, height: collectionView.frame.size.width/2 - 2)
    }
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
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return section == 1 ? 8 : 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return section == 1 ? 8 : 1
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return section == 1 ? UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8) : UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
  }
}

// MARK: - UICollectionViewDelegate

extension SearchViewController {
  override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    if indexPath.section == 1 {
      updateBreadcrumbs(selectedCategory: viewModel.categories[indexPath.item])
    } else if indexPath.section == 2 {
      showProductController(withProduct: viewModel.products[indexPath.item])
    }
  }
  
  private func updateBreadcrumbs(selectedCategory categrory: SearchCategory) {
    viewModel.selectedCategory = categrory
    if let query = getValidQueryString(for: searchController) {
      viewModel.search(query: query) { [unowned self] in
        self.reloadCollectionViewAsynchronously()
      }
    }
  }
  
  private func showProductController(withProduct product: SearchProduct) {
    viewModel.fetch(product: product) { [unowned self] (productResponse) in
      if productResponse != nil {
        DispatchQueue.main.async {
          let productController = ProductViewController(response: productResponse!)
          self.show(productController, sender: self)
        }
      }
    }
  }
}

// MARK: - UISearchResultsUpdating

extension SearchViewController: UISearchResultsUpdating {
  
  func updateSearchResults(for searchController: UISearchController) {
    guard let searchQuery = getValidQueryString(for: searchController) else {
      return
    }
    
    viewModel.search(query: searchQuery) { [unowned self] in
      self.reloadCollectionViewAsynchronously()
    }
  }
  
  private func getValidQueryString(for searchController: UISearchController) -> String? {
    if let searchQuery = searchController.searchBar.text, searchQuery.count > 0 {
      return searchQuery
    }
    return nil
  }
}
