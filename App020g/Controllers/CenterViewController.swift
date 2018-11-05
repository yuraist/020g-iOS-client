//
//  CenterViewController.swift
//  App020g
//
//  Created by Юрий Истомин on 12/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class CenterViewController: UIViewController {
  var delegate: CenterViewControllerDelegate?
  
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
    setupNavigationItemContent()
  }
  
  private func setupNavigationItemContent() {
    addButtonItemsToBar()
  }
  
  private func addButtonItemsToBar() {
    navigationItem.rightBarButtonItems = [loginBarButtonItem, searchBarButtonItem]
    navigationItem.leftBarButtonItem = menuBarButtonItem
  }
  
  @objc private func showAuthorizationViewController() {
    let authViewModel = AuthorizationViewModel(manager: ServerManager())
    let authController = AuthorizationViewController(viewModel: authViewModel)
    present(UINavigationController(rootViewController: authController), animated: true, completion: nil)
  }
  
  @objc private func showSearchCollectionViewController() {
    let searchViewController = SearchCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
    show(searchViewController, sender: self)
  }
  
  @objc private func showMenu() {
    delegate?.toggleLeftPanel?()
  }
}

