//
//  CatalogTreeTableViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class CatalogTreeTableViewController: UITableViewController {
  private let cellId = "categoryCell"
  
  var categories = [CatalogCategory]() {
    didSet {
      reloadTableView()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavagationTitle()
    removeBackButtonTitle()
    registerCell()
    fetchCatalogOfCategories()
  }
  
  private func setNavagationTitle() {
    navigationItem.title = "Категории"
  }
  
  private func removeBackButtonTitle() {
    navigationItem.backBarButtonItem?.title = ""
  }
  
  private func registerCell() {
    tableView.register(CatalogTreeBaseCell.self, forCellReuseIdentifier: cellId)
  }
  
  private func fetchCatalogOfCategories() {
    ApiHandler.shared.fetchCatalogTreeCategories { (success, catalogCategories) in
      if let catalogCategories = catalogCategories?.categories {
        self.categories = catalogCategories
      }
    }
  }
  
  private func reloadTableView() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return categories.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CatalogTreeBaseCell
    cell.category = categories[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 54
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let destinationContrller = SecondCatalogTreeTableViewController(withCategory: categories[indexPath.row])
    show(destinationContrller, sender: self)
  }
}
