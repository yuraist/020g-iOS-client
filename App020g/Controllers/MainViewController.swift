//
//  MainViewController.swift
//  020g
//
//  Created by Юрий Истомин on 21/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class MainViewController: CenterViewController {
  
  static let menuBarHeight: CGFloat = 84
  
  private let itemCellId = "cellId"
  private let menuBar = BarView()
  
  var lastPages = [Int: Int]()
  var products = [Int: [Product]]()
  var contentOffsets = [Int: CGPoint]()
  var catalogLastIndecies = [Int: IndexPath]()
  
  private lazy var categoryPagesCollectionView: CategoryPagesCollectionView = {
    let collectionViewLayout = UICollectionViewFlowLayout()
    let collectionView = CategoryPagesCollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
    collectionView.parentViewController = self
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    addCategoryPagesCollectionView()
    setCollectionViewConstraints()
    
    addMenuBar()
    setMenuBarConstraints()
    setMenuBarButtonAction()
    
    fetchCatalogKeysAndCategories()
    addCategoryPagesCollectionViewToMenuBarProperty()
    
  }
  
  private func addCategoryPagesCollectionView() {
    view.addSubview(categoryPagesCollectionView)
  }
  
  private func setCollectionViewConstraints() {
    categoryPagesCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    categoryPagesCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    categoryPagesCollectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    categoryPagesCollectionView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -getTotalMenuHeight()).isActive = true
  }
  
  private func getTotalMenuHeight() -> CGFloat {
    return getNavigationControllerHeight() + MainViewController.menuBarHeight + UIViewController.statusBarHeight
  }
  
  private func getNavigationControllerHeight() -> CGFloat {
    return navigationController?.navigationBar.frame.size.height ?? 0
  }
  
  private func addMenuBar() {
    view.addSubview(menuBar)
  }
  
  private func setMenuBarConstraints() {
    menuBar.topAnchor.constraint(equalTo: view.topAnchor, constant: getTopLayoutGuideHeight()).isActive = true
    menuBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    menuBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    menuBar.heightAnchor.constraint(equalToConstant: MainViewController.menuBarHeight).isActive = true
  }
  
  private func getTopLayoutGuideHeight() -> CGFloat {
    return UIViewController.statusBarHeight + getNavigationControllerHeight()
  }
  
  private func setMenuBarButtonAction() {
    menuBar.pricesButton.addTarget(self, action: #selector(showCatalogTree), for: .touchUpInside)
  }
  
  @objc
  private func showCatalogTree() {
    let catalogTreeController = CatalogTreeTableViewController()
    show(catalogTreeController, sender: self)
  }
  
  private func fetchCatalogKeysAndCategories() {
    ServerManager.shared.checkKeys { (success) in
      if success {
        self.fetchCategories()
      }
    }
  }
  
  private func fetchCategories() {
    ServerManager.shared.fetchCatalogCategories() { (success, categories) in
      if success {
        if let categories = categories {
          self.passCategoriesToMenuBar(categories: categories)
          self.passCategoriesToCategoryPagesCollectionView(categories: categories)
        }
      }
    }
  }
  
  private func passCategoriesToMenuBar(categories: [Category]) {
    menuBar.categories = categories
  }
  
  private func passCategoriesToCategoryPagesCollectionView(categories: [Category]) {
    categoryPagesCollectionView.categories = categories
  }
  
  private func addCategoryPagesCollectionViewToMenuBarProperty() {
    menuBar.catalogCollectionView = categoryPagesCollectionView
  }
  
  override func viewWillAppear(_ animated: Bool) {
    setNavigationItemTitle()
  }
  
  private func setNavigationItemTitle() {
    navigationItem.title = "0.20g - агрегатор №1"
  }
  
  private func addStartingMenuBarItemIndexPath() {
    menuBar.selectedItemIndexPath = IndexPath(item: 0, section: 0)
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
    return CGSize(width: view.frame.width, height: view.frame.height - getTotalMenuHeight())
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
