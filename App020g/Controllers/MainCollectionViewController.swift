//
//  MainTableViewController.swift
//  020g
//
//  Created by Юрий Истомин on 21/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class MainCollectionViewController: CenterViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  
  private let itemCellId = "cellId"
  private let menuBar = MenuBarView()
  
  var collectionView: UICollectionView?
  
  var products = [[Product]]() {
    didSet {
      reloadCollectionView()
    }
  }
  
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
    menuBar.selectedItemIndexPath = getCurrentCellIndexPath()
  }
  
  // MARK: - Setup navigation controller
  
  private func setNavigationItemTitle() {
    navigationItem.title = "0.20g - агрегатор №1"
  }
  
  // MARK: - Setup collection view
  
  private func setupCollectionView() {
    createAndAddCollectionView()
    setCollectionViewDelegateAndDataSource()
    setCollectionViewTranslatesAutoresizingMaskIntoConstraintsFalse()
    setupCollectionViewTopConstraint()
    setWhiteBackgroundColorForCollectionView()
    setupCollectionViewScrollDirection()
    setCollectionViewPagingEnabled()
    registerCollectionViewCell()
  }
  
  private func createAndAddCollectionView() {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    view.addSubview(collectionView!)
  }
  
  private func setCollectionViewDelegateAndDataSource() {
    collectionView?.delegate = self
    collectionView?.dataSource = self
  }
  
  private func setCollectionViewTranslatesAutoresizingMaskIntoConstraintsFalse() {
    collectionView!.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func setupCollectionViewTopConstraint() {
    collectionView!.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    collectionView!.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    collectionView!.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    collectionView!.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -totalMenuHeight).isActive = true
  }
  
  private func setWhiteBackgroundColorForCollectionView() {
    collectionView!.backgroundColor = ApplicationColors.white
  }
  
  private func setupCollectionViewScrollDirection() {
    if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
  }
  
  private func setCollectionViewPagingEnabled() {
    collectionView?.isPagingEnabled = true
  }
  
  private func registerCollectionViewCell() {
    collectionView?.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: itemCellId)
  }
  
  private func fetchCategories() {
    ApiHandler.shared.fetchCatalogCategories() { (success, categories) in
      if success {
        if let categories = categories {
          self.passCategoriesToMenuBar(categories: categories)
          self.fetchProducts(forCategory: categories[0].cat, page: 1)
        }
      }
    }
  }
  
  private func passCategoriesToMenuBar(categories: [Category]) {
    menuBar.categories = categories
  }
  
  private func fetchProducts(forCategory category: Int, page: Int) {
    ApiHandler.shared.fetchProducts(ofCategory: category, page: page) { (success, products) in
      if let products = products {
        self.products = [products]
      }
    }
  }
  
  func reloadCollectionView() {
    DispatchQueue.main.async {
      self.collectionView?.reloadData()
    }
  }
  
  func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
    changeMenuBarSelectedItem()
  }
  
  private func changeMenuBarSelectedItem() {
    menuBar.selectedItemIndexPath = getCurrentCellIndexPath()
  }
  
  private func getCurrentCellIndexPath() -> IndexPath {
    if let cell = collectionView?.visibleCells.first, let indexPath = collectionView?.indexPath(for: cell) {
      return indexPath
    } else {
      return IndexPath(item: 0, section: 0)
    }
  }
  
  // MARK: - UICollectionViewDataSource
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return menuBar.categories.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellId, for: indexPath) as! CategoryCollectionViewCell
    menuBar.catalogCollectionView = collectionView
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
