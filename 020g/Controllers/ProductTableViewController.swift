//
//  ProductTableViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ProductTableViewController: UITableViewController {
  
  private let cellId = "tableViewCell"
  private let carouselCellId = "carouselCell"
  
  var response: ProductResponse
  
  init(response: ProductResponse) {
    self.response = response
    super.init(style: .grouped)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    registerCells()
    removeSeparatorLine()
  }
  
  private func registerCells() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    tableView.register(ProductImageCarouselTableViewCell.self, forCellReuseIdentifier: carouselCellId)
  }
  
  private func removeSeparatorLine() {
    tableView.separatorColor = .clear
  }
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    return 3
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return getFirstSecionTitle()
    case 1:
      return getSecondSectionTitle()
    case 3:
      return "Детально"
    default:
      return ""
    }
  }
  
  private func getFirstSecionTitle() -> String {
    var firstTitle = ""
    for breadcrumb in response.breadcrumbs {
      firstTitle.append(breadcrumb.name + " > ")
    }
    return String(firstTitle.dropLast(3))
  }
  
  private func getSecondSectionTitle() -> String {
    return "Все цены на \(response.product.name)"
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return 3
    case 1: return response.product.prices.count
    case 2: return response.product.opts.count
    default: return 1
    }
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 0 {
      if indexPath.row == 0 {
        let cell = ProductImageCarouselTableViewCell(style: .default, reuseIdentifier: carouselCellId)
        cell.imageUrls = response.product.images
        return cell
      }
    }
    
    return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
  }

  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath == IndexPath(row: 0, section: 0) {
      return view.frame.size.width
    }
    
    return 44
  }
}
