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
    let cell = tableView.dequeueReusableCell(withIdentifier: secondCell, for: indexPath) as! SecondCatalogTreeCell
    cell.category = catalogTree?.tree[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    if let cell = tableView.cellForRow(at: indexPath) as? SecondCatalogTreeCell {
      cell.isExpanded = !cell.isExpanded
    }
  }
}
