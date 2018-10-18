//
//  SecondCatalogTreeTableViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class SecondCatalogTreeTableViewController: UITableViewController {

  private let secondCell = "second"
  private let baseCell = "base"
  
  var parentCategory: CatalogCategory
  
  var catalogTree: CatalogTree? {
    didSet {
      reloadTableView()
    }
  }
  
  init(withCategory category: CatalogCategory) {
    self.parentCategory = category
    super.init(style: .plain)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setNavagationTitle()
    removeBackButtonTitle()
    registerCell()
    fetchCategoriesTree()
  }
  
  private func setNavagationTitle() {
    navigationItem.title = parentCategory.name
  }
  
  private func removeBackButtonTitle() {
    navigationController?.navigationBar.backItem?.title = ""
  }
  
  private func registerCell() {
    tableView.register(SecondCatalogTreeCell.self, forCellReuseIdentifier: secondCell)
    tableView.register(CatalogTreeBaseCell.self, forCellReuseIdentifier: baseCell)
  }
  
  private func fetchCategoriesTree() {
    ApiHandler.shared.fetchCatalogTree(byCategory: parentCategory.id) { (success, tree) in
      if let tree = tree {
        self.catalogTree = tree
      }
    }
  }
  
  private func reloadTableView() {
    DispatchQueue.main.async {
      self.tableView.reloadData()
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return catalogTree?.tree.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if let category = catalogTree?.tree[indexPath.row] {
      if category.level == 0 {
        let cell = tableView.dequeueReusableCell(withIdentifier: secondCell, for: indexPath) as! SecondCatalogTreeCell
        cell.category = category
        return cell
      }
      
      let cell = tableView.dequeueReusableCell(withIdentifier: baseCell, for: indexPath) as! CatalogTreeBaseCell
      cell.childCategory = category
      return cell
    }

    return UITableViewCell(style: .default, reuseIdentifier: baseCell)
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    deselectRow(at: indexPath)
    
    if let category = catalogTree?.tree[indexPath.row] {
      if category.hasTree && !category.isShowingTree {
        showTree()
      } else if category.hasTree && category.isShowingTree {
        hideTree()
      } else {
        showCatalog(withCategory: category)
      }
    }
  }
  
  private func deselectRow(at indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  private func showTree() {
    print("showTree")
  }
  
  private func hideTree() {
    print("hideTree")
  }
  
  private func showCatalog(withCategory category: CatalogTreeChildCategory) {
    print("showCatalog with the \(category.name) category")
  }
}
