//
//  ShopListTableViewController.swift
//  020g
//
//  Created by Юрий Истомин on 25/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ShopListTableViewController: UITableViewController {
  
  private let cellId = "shopListCellId"
  
  var delegate: CenterViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Страйкбольные магазины"
    setupNavigationItem()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
  }
  
  // MARK: - Setup navigation controller
  
  // Setup items of the navigation bar
  private func setupNavigationItem() {
    let loginButton = UIButton()
    loginButton.setImage(#imageLiteral(resourceName: "signIn").withRenderingMode(.alwaysTemplate), for: .normal)
    loginButton.tintColor = ApplicationColor.white
    loginButton.addTarget(self, action: #selector(showAuthorizationViewController), for: .touchUpInside)
    
    let searchButton = UIButton()
    searchButton.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate), for: .normal)
    searchButton.tintColor = ApplicationColor.white
    searchButton.addTarget(self, action: #selector(showSearchCollectionViewController), for: .touchUpInside)
    
    let menuButton = UIButton()
    menuButton.setImage(#imageLiteral(resourceName: "menu").withRenderingMode(.alwaysTemplate), for: .normal)
    menuButton.tintColor = ApplicationColor.white
    menuButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
    
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    searchButton.translatesAutoresizingMaskIntoConstraints = false
    menuButton.translatesAutoresizingMaskIntoConstraints = false
    
    let loginBarButtonItem = UIBarButtonItem(customView: loginButton)
    let searchBarButtonItem = UIBarButtonItem(customView: searchButton)
    let menuBarButtonItem = UIBarButtonItem(customView: menuButton)
    
    setupBarButtonConstraints(forBarItem: loginBarButtonItem)
    setupBarButtonConstraints(forBarItem: searchBarButtonItem)
    setupBarButtonConstraints(forBarItem: menuBarButtonItem)
    
    navigationItem.rightBarButtonItems = [loginBarButtonItem, searchBarButtonItem]
    navigationItem.leftBarButtonItem = menuBarButtonItem
  }
  
  private func setupBarButtonConstraints(forBarItem item: UIBarButtonItem) {
    item.customView?.widthAnchor.constraint(equalToConstant: 20).isActive = true
    item.customView?.heightAnchor.constraint(equalToConstant: 20).isActive = true
  }
  
  @objc private func showAuthorizationViewController() {
    present(UINavigationController(rootViewController: AuthorizationViewController()), animated: true, completion: nil)
  }
  
  @objc private func showSearchCollectionViewController() {
    
  }
  
  @objc private func showMenu() {
    delegate?.toggleLeftPanel?()
  }
  
  // MARK: - Table view data source
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    
    return cell
  }
  
}
