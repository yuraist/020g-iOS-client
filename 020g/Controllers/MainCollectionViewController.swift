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
  
  let menuBar: MenuBarView = {
    let mb = MenuBarView()
    return mb
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "0.20g - агрегатор №1"
    setupNavigationItem()
    setupMenuBar()
    
    collectionView.backgroundColor = ApplicationColor.white
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: itemCellId)
  }
  
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
  
  private func setupMenuBar() {
    view.addSubview(menuBar)
    if let navigationBarHeight = navigationController?.navigationBar.frame.size.height {
      let topLayoutGuideHeight = navigationBarHeight + UIApplication.shared.statusBarFrame.size.height
      menuBar.topAnchor.constraint(equalTo: view.topAnchor, constant: topLayoutGuideHeight).isActive = true
    }
    menuBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    menuBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    menuBar.heightAnchor.constraint(equalToConstant: 80).isActive = true
  }
  
  private func setupBarButtonConstraints(forBarItem item: UIBarButtonItem) {
    item.customView?.widthAnchor.constraint(equalToConstant: 22).isActive = true
    item.customView?.heightAnchor.constraint(equalToConstant: 22).isActive = true
  }
  
  @objc private func showAuthorizationViewController() {
    present(UINavigationController(rootViewController: AuthorizationViewController()), animated: true, completion: nil)
  }
  
  @objc private func showSearchCollectionViewController() {
    
  }
  
  @objc private func showMenu() {
    delegate?.toggleLeftPanel?()
  }
  
  private func slideInMenuView() {
    
  }
  
  private func slideOutMenuView() {
    
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: itemCellId, for: indexPath)
    cell.backgroundColor = ApplicationColor.buttonBlue
    return cell
  }
  
}

extension MainCollectionViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.size.width/2, height: view.frame.size.width/2)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
