//
//  SecondCatalogTreeTableViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class SecondCatalogTreeTableViewController: UITableViewController {

  private let cellId = "cell"
  
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
  }
  
  private func setNavagationTitle() {
    navigationItem.title = parentCategory.name
  }
  
  private func removeBackButtonTitle() {
    navigationController?.navigationBar.backItem?.title = ""
  }
  
  private func registerCell() {
    
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
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    return cell
  }
  
}
