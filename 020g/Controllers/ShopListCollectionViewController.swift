//
//  ShopListCollectionViewController.swift
//  020g
//
//  Created by Юрий Истомин on 25/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit
import SafariServices

class ShopListCollectionViewController: UICollectionViewController {
  
  private let cellId = "shopListCellId"
  var delegate: CenterViewControllerDelegate?
  
  var shops = [Shop]() {
    didSet {
      DispatchQueue.main.async {
        self.reloadCollectionView()
        self.updateCollectionViewLayout()
      }
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavigationTitle()
    setupNavigationItemContent()
    setCollectionViewDelegate()
    registerCollectionViewCell()
    fetchShops()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
  }
  
  private func fetchShops() {
    ApiHandler.shared.fetchShops { (success, shops) in
      if let shops = shops {
          self.shops = shops
      }
    }
  }
  
  private func reloadCollectionView() {
    updateCollectionViewData()
  }
  
  private func updateCollectionViewData() {
    collectionView.reloadData()
  }
  
  private func updateCollectionViewLayout() {
    collectionView.collectionViewLayout.invalidateLayout()
  }
  
  // MARK: - Setup navigation controller
  
  private func setNavigationTitle() {
    navigationItem.title = "Страйкбольные магазины"
  }
  
  private func setupNavigationItemContent() {
    addButtonItemsToBar()
  }
  
  private func addButtonItemsToBar() {
    navigationItem.rightBarButtonItems = [loginBarButtonItem, searchBarButtonItem]
    navigationItem.leftBarButtonItem = menuBarButtonItem
  }
  
  private func registerCollectionViewCell() {
    collectionView.register(ShopCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  @objc private func showAuthorizationViewController() {
    present(UINavigationController(rootViewController: AuthorizationViewController()), animated: true, completion: nil)
  }
  
  @objc private func showSearchCollectionViewController() {
    
  }
  
  @objc private func showMenu() {
    delegate?.toggleLeftPanel?()
  }
  
  private func setCollectionViewDelegate() {
    collectionView.delegate = self
  }
  
  // MARK: - Collection view data source

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return shops.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ShopCollectionViewCell
    cell.shop = shops[indexPath.item]
    cell.contactButton.addTarget(self, action: #selector(openContactInSafari(sender:)), for: .touchUpInside)
    if cell.shop?.vkGroup != nil {
      cell.vkGroupButton.addTarget(self, action: #selector(openContactInSafari(sender:)), for: .touchUpInside)
    }
    return cell
  }
  
  @objc private func openContactInSafari(sender: ContactButton) {
    if let contactUrl = sender.contactUrl {
      let safariViewController = SFSafariViewController(url: contactUrl)
      present(safariViewController, animated: true, completion: nil)
    }
  }
}

extension ShopListCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellHeight = shops[indexPath.item].cellHeight
    return CGSize(width: view.frame.width, height: cellHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
