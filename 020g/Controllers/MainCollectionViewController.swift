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
  
  var categories = [Category]()
  var productItems = [[Product]]()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavigationItemTitle()
    setupNavigationItemContent()
    setupMenuBar()
    setupCollectionView()
    getCategories()
  }
  
  // MARK: - Setup navigation controller
  
  private func setNavigationItemTitle() {
    navigationItem.title = "0.20g - агрегатор №1"
  }
  
  class BarButton: UIButton {
    
    init(image: UIImage) {
      super.init(frame: .zero)
      setTranslatesAutoresizingMaskIntoConstraintsFalse()
      setTintColorWhite()
      setNormalImage(image)
    }
    
    private func setTranslatesAutoresizingMaskIntoConstraintsFalse() {
      translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setTintColorWhite() {
      tintColor = ApplicationColors.white
    }
    
    private func setNormalImage(_ image: UIImage) {
      setImage(image.withRenderingMode(.alwaysTemplate), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }
  
  class CustomBarButtonItem: UIBarButtonItem {
    
    override var customView: UIView? {
      didSet {
        setupConstraintsForCustomView()
      }
    }
    
    init(button: BarButton) {
      super.init()
      customView = button
    }
    
    private func setupConstraintsForCustomView() {
      customView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
      customView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
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
  
  // MARK: - Setup menu bar
  
  private func setupMenuBar() {
    view.addSubview(menuBar)
    if let navigationBarHeight = navigationController?.navigationBar.frame.size.height {
      let topLayoutGuideHeight = navigationBarHeight + UIApplication.shared.statusBarFrame.size.height
      menuBar.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuideHeight).isActive = true
    }
    menuBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    menuBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    menuBar.heightAnchor.constraint(equalToConstant: 84).isActive = true
  }
  
  private func setupCollectionView() {
    collectionView.backgroundColor = ApplicationColors.white
    collectionView.register(CatalogueItemCollectionViewCell.self, forCellWithReuseIdentifier: itemCellId)
    
    if let navigationControllerHeight = navigationController?.navigationBar.frame.size.height {
      let insetHeight = navigationControllerHeight + UIApplication.shared.statusBarFrame.height + menuBar.frame.size.height
      collectionView.contentInset = UIEdgeInsets(top: insetHeight, left: 0, bottom: 0, right: 0)
    }
    
  }
  
  private func getCategories() {
    if ApiKeys.token != nil {
      ApiHandler.shared.fetchCatalogCategories(token: ApiKeys.token!) { (success, categories) in
        if success {
          if let categories = categories {
            self.menuBar.categories = categories
            self.menuBar.reloadCollectionView()
            self.getProductList(forCategory: categories[0].cat, page: 1)
          }
        } else {
          print("No success")
        }
      }
    } else {
      print("No token")
    }
  }
  
  private func getProductList(forCategory category: Int, page: Int) {
    if ApiKeys.token != nil {
      ApiHandler.shared.getProducts(ofCategory: category, page: page) { (success, products) in
        if let products = products {
          self.productItems = [products]
          self.reloadCollectionView()
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
    return productItems.count > 0 ? productItems[0].count : productItems.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellId, for: indexPath) as! CatalogueItemCollectionViewCell
    cell.item = productItems[0][indexPath.item]
    return cell
  }
  
}

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.size.width/2 - 2, height: view.frame.size.width/2 - 4)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 2
  }
}
