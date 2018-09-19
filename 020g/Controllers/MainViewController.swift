//
//  ViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class MainViewController: UITableViewController {
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  // Set the style for teh navigation bar
  private func setupNavigationControllerStyle() {
    navigationController?.navigationBar.barTintColor = ApplicationColor.darkBlue
    navigationController?.navigationBar.tintColor = ApplicationColor.white
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ApplicationColor.white] as [NSAttributedString.Key: Any]
  }
  
  // Setup items of the navigation bar
  private func setupNavigationItem() {
    navigationItem.title = "0.20g - агрегатор №1"
    
    let loginBarButtonItem = UIBarButtonItem(title: "Войти", style: .plain, target: self, action: #selector(showAuthorizationViewController))
    let searchBarButtonItem = UIBarButtonItem(title: "Поиск", style: .plain, target: self, action: #selector(showSearchCollectionViewController))
    navigationItem.rightBarButtonItems = [loginBarButtonItem, searchBarButtonItem]
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavigationControllerStyle()
    setupNavigationItem()
  }
  
  @objc private func showAuthorizationViewController() {
    present(UINavigationController(rootViewController: AuthorizationViewController()), animated: true, completion: nil)
  }
  
  @objc private func showSearchCollectionViewController() {
    
  }
  
}

