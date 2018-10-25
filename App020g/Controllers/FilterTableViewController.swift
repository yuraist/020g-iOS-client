//
//  FilterTableViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class FilterTableViewController: UITableViewController {
  
  private let cellId = "cell"
  var parentController: CatalogCollectionViewController?
  var filter: FilterResponse?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.setWhiteBackgroundColor()
    registerTableViewCells()
  }
  
  private func registerTableViewCells() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filter?.list.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    
    return cell
  }
}
