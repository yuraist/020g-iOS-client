//
//  MainViewController.swift
//  020g
//
//  Created by Юрий Истомин on 21/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class MainViewController: CenterViewController {
  
  var products = [Int: [Product]]()
  var lastPages = [Int: Int]()
  var contentOffsets = [Int: CGPoint]()
  
  private let itemCellId = "cellId"
  private let menuBar = BarView()
  
  var catalogLastIndecies = [Int: IndexPath]()
  
  private lazy var categoryPagesCollectionView: CategoryPagesCollectionView = {
    let categoryPagesCollectionView = CategoryPagesCollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    categoryPagesCollectionView.parentViewController = self
    return categoryPagesCollectionView
  }()
  
  private var totalMenuHeight: CGFloat {
    return navigationControllerHeight + menuBarHeight + statusBarHeight
  }
  
  private var topLayoutGuideHeight: CGFloat {
    return statusBarHeight + navigationControllerHeight
  }
  
  private var menuBarHeight: CGFloat {
    return 84
  }
  
  private var navigationControllerHeight: CGFloat {
    get {
      guard let navigationControllerHeight = navigationController?.navigationBar.frame.size.height else {
        return 0
      }
      return navigationControllerHeight
    }
  }
  
  private var statusBarHeight: CGFloat {
    return UIApplication.shared.statusBarFrame.size.height
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCollectionView()
    fetchCatalogKeysAndCategories()
    setupMenuBar()
    addCategoryPagesCollectionViewToMenuBarProperty()
    setMenuBarButtonAction()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setNavigationItemTitle()
  }
  
  private func fetchCatalogKeysAndCategories() {
    ApiHandler.shared.checkKeys { (success) in
      if success {
        self.fetchCategories()
      }
    }
  }
  
  // MARK: - Setup menu bar
  
  private func setupMenuBar() {
    addMenuBar()
    addConstraintsForMenuBar()
  }
  
  private func addMenuBar() {
    view.addSubview(menuBar)
  }
  
  private func addConstraintsForMenuBar() {
    menuBar.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuideHeight).isActive = true
    menuBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    menuBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    menuBar.heightAnchor.constraint(equalToConstant: menuBarHeight).isActive = true
  }
  
  private func addStartingMenuBarItemIndexPath() {
    menuBar.selectedItemIndexPath = IndexPath(item: 0, section: 0)
  }
  
  private func addCategoryPagesCollectionViewToMenuBarProperty() {
    menuBar.catalogCollectionView = categoryPagesCollectionView
  }
  
  // MARK: - Setup navigation controller
  
  private func setNavigationItemTitle() {
    navigationItem.title = "0.20g - агрегатор №1"
  }
  
  // MARK: - Setup collection view
  
  private func setupCollectionView() {
    addCategoryPagesCollectionView()
    setupCollectionViewTopConstraint()
  }
  
  private func addCategoryPagesCollectionView() {
    view.addSubview(categoryPagesCollectionView)
  }
  
  private func setupCollectionViewTopConstraint() {
    categoryPagesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    categoryPagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    categoryPagesCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    categoryPagesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -totalMenuHeight).isActive = true
  }
  
  private func fetchCategories() {
    ApiHandler.shared.fetchCatalogCategories() { (success, categories) in
      if success {
        if let categories = categories {
          self.passCategoriesToMenuBar(categories: categories)
          self.passCategoriesToCategoryPagesCollectionView(categories: categories)
        }
      }
    }
  }
  
  private func fetchProducts() {
    
  }
  
  private func passCategoriesToMenuBar(categories: [Category]) {
    menuBar.categories = categories
  }
  
  private func passCategoriesToCategoryPagesCollectionView(categories: [Category]) {
    categoryPagesCollectionView.categories = categories
  }
  
  private func setMenuBarButtonAction() {
    menuBar.pricesButton.addTarget(self, action: #selector(showCatalogTree), for: .touchUpInside)
  }
  
  @objc
  private func showCatalogTree() {
    let catalogTreeController = CatalogTreeTableViewController()
    show(catalogTreeController, sender: self)
  }
  
  // MARK: - UICollectionViewDataSource
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return menuBar.categories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellId, for: indexPath) as! CategoryCollectionViewCell
    
    cell.catalogCollectionView.category = menuBar.categories[indexPath.item]
    cell.catalogCollectionView.parentViewController = self
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: view.frame.height - totalMenuHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
