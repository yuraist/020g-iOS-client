//
//  SecondCatalogTreeViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class SecondCatalogTreeViewController: UITableViewController {
  
  private let secondCell = "second"
  private let baseCell = "base"
  
  var parentCategory: CatalogCategory
  
  var catalogTree: CatalogTree?
  
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
    registerCells()
    fetchCategoriesTree()
  }
  
  private func setNavagationTitle() {
    navigationItem.title = parentCategory.name
  }
  
  private func removeBackButtonTitle() {
    navigationController?.navigationBar.backItem?.title = ""
  }
  
  private func registerCells() {
    tableView.register(SecondCatalogTreeCell.self, forCellReuseIdentifier: secondCell)
    tableView.register(CatalogTreeBaseCell.self, forCellReuseIdentifier: baseCell)
  }
  
  private func fetchCategoriesTree() {
    ServerManager.shared.fetchCatalogTree(byCategory: parentCategory.id) { [unowned self] (success, tree) in
      if let tree = tree {
        self.catalogTree = tree
        self.showAllCategories()
      }
    }
  }
  
  private func showAllCategories() {
    if let tree = catalogTree?.tree {
      var newTree = [CatalogTreeChildCategory]()
      
      for var item in tree {
        if let subtree = item.tree {
          if !item.isShowingTree {
            item.isShowingTree = true
            newTree.append(item)
            newTree.append(contentsOf: subtree)
          }
        } else {
          newTree.append(item)
        }
        
        catalogTree!.tree = newTree
        reloadTableViewAsync()
      }
    }
  }
  
  private func reloadTableViewAsync() {
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
        showTree(withCategory: category, after: indexPath.row)
      } else if category.hasTree && category.isShowingTree {
        hideTree(withCategory: category, after: indexPath.row)
      } else {
        showCatalog(withCategory: category)
      }
      
      reloadTableViewAsync()
    }
  }
  
  private func deselectRow(at indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
  
  private func showTree(withCategory category: CatalogTreeChildCategory, after index: Int) {
    let newIndex = index + 1
    catalogTree?.tree[index].isShowingTree = true
    catalogTree?.tree.insert(contentsOf: category.tree!, at: newIndex)
  }
  
  private func hideTree(withCategory category: CatalogTreeChildCategory, after index: Int) {
    catalogTree!.tree[index].isShowingTree = false
    removeCategories(forParent: category)
  }
  
  private func removeCategories(forParent category: CatalogTreeChildCategory) {
    for child in catalogTree!.tree {
      if category.tree!.contains(where: { return $0.name == child.name }) {
        if let index = catalogTree!.tree.firstIndex(where: { return $0.name == child.name }) {
          catalogTree!.tree.remove(at: index)
        }
      }
    }
  }
  
  private func showCatalog(withCategory category: CatalogTreeChildCategory) {
    let filterRequest = FilterRequest(category: String(category.id), page: "1", cost: nil, options: nil, sort: nil)
    let catalogViewModel = CatalogViewModel(filterRequest, categoryName: category.name)
    let catalogViewController = CatalogViewController(catalogViewModel)
    show(catalogViewController, sender: self)
  }
}
