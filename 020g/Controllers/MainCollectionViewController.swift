//
//  MainTableViewController.swift
//  020g
//
//  Created by Юрий Истомин on 21/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class MainCollectionViewController: UICollectionViewController {
  
  private let itemCellId = "cellId"
  var delegate: CenterViewControllerDelegate?
  
  let menuBar = MenuBarView()
  
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
  
  private var menuBarHeight: CGFloat { return 84 }
  
  private var navigationControllerHeight: CGFloat {
    get {
      guard let navigationControllerHeight = navigationController?.navigationBar.frame.size.height else { return 0 }
      return navigationControllerHeight
    }
  }
  
  private var statusBarHeight: CGFloat {
    return UIApplication.shared.statusBarFrame.size.height
  }
  
  private lazy var loginButton: BarButton = {
    let loginButton = BarButton(image: #imageLiteral(resourceName: "signIn"))
    loginButton.addTarget(self, action: #selector(showAuthorizationViewController), for: .touchUpInside)
    return loginButton
  }()
  
  private lazy var searchButton: BarButton = {
    let searchButton = BarButton(image: #imageLiteral(resourceName: "search"))
    searchButton.addTarget(self, action: #selector(showSearchCollectionViewController), for: .touchUpInside)
    return searchButton
  }()
  
  private lazy var menuButton: BarButton = {
    let menuButton = BarButton(image: #imageLiteral(resourceName: "menu"))
    menuButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
    return menuButton
  }()
  
  private lazy var loginBarButtonItem = CustomBarButtonItem(button: loginButton)
  private lazy var searchBarButtonItem = CustomBarButtonItem(button: searchButton)
  private lazy var menuBarButtonItem = CustomBarButtonItem(button: menuButton)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupMenuBar()
    setNavigationItemTitle()
    setupNavigationItemContent()
    setupCollectionView()
    fetchCategories()
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
  
  // MARK: - Setup navigation controller
  
  private func setNavigationItemTitle() {
    navigationItem.title = "0.20g - агрегатор №1"
  }
  
  private func setupNavigationItemContent() {
    addButtonItemsToBar()
  }
  
  private func addButtonItemsToBar() {
    navigationItem.rightBarButtonItems = [loginBarButtonItem, searchBarButtonItem]
    navigationItem.leftBarButtonItem = menuBarButtonItem
  }
  
  @objc private func showAuthorizationViewController() {
    present(UINavigationController(rootViewController: AuthorizationViewController()), animated: true, completion: nil)
  }
  
  @objc private func showSearchCollectionViewController() {
    
  }
  
  @objc private func showMenu() {
    delegate?.toggleLeftPanel?()
  }
  
  // MARK: - Setup collection view
  
  private func setupCollectionView() {
    setCollectionViewTranslatesAutoresizingMaskIntoConstraintsFalse()
    setupCollectionViewTopConstraint()
    setWhiteBackgroundColorForCollectionView()
    setupCollectionViewScrollDirection()
    setCollectionViewPagingEnabled()
    registerCollectionViewCell()
  }
  
  private func setCollectionViewTranslatesAutoresizingMaskIntoConstraintsFalse() {
    collectionView.translatesAutoresizingMaskIntoConstraints = false
  }
  
  private func setupCollectionViewTopConstraint() {
    collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -totalMenuHeight).isActive = true
  }
  
  private func setWhiteBackgroundColorForCollectionView() {
    collectionView.backgroundColor = ApplicationColors.white
  }
  
  private func setupCollectionViewScrollDirection() {
    if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
  }
  
  private func setCollectionViewPagingEnabled() {
    collectionView.isPagingEnabled = true
  }
  
  private func registerCollectionViewCell() {
    collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: itemCellId)
  }
  
  private func fetchCategories() {
    guard let token = ApiKeys.token else {
      return
    }
    
    ApiHandler.shared.fetchCatalogCategories(token: token) { (success, categories) in
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
    if ApiKeys.token != nil {
      ApiHandler.shared.fetchProducts(ofCategory: category, page: page) { (success, products) in
        if let products = products {
          self.products = [products]
        }
      }
    }
  }
  
  func reloadCollectionView() {
    DispatchQueue.main.async {
      self.collectionView.reloadData()
    }
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return menuBar.categories.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellId, for: indexPath) as! CategoryCollectionViewCell
    menuBar.catalogCollectionView = cell.catalogCollectionView
    cell.catalogCollectionView.category = menuBar.categories[indexPath.item]
    return cell
  }
  
}

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
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
