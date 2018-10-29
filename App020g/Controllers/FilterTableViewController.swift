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
  private let priceCellId = "priceCell"
  private let parameterCellId = "parameterCell"
  
  var parentController: CatalogCollectionViewController?
  var filter: FilterResponse?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.setWhiteBackgroundColor()
    registerTableViewCells()
    fetchFilterParameters()
  }
  
  private func registerTableViewCells() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    tableView.register(FilterParameterTableViewCell.self, forCellReuseIdentifier: parameterCellId)
  }
  
  private func fetchFilterParameters() {
    guard let category = parentController?.category else {
      return
    }
    
    ApiHandler.shared.fetchFilter(forCategoryId: category.id) { (filterResponse) in
      if let response = filterResponse {
        self.filter = response
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      }
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return filter?.list.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let cell = FilterPriceTableViewCell(style: .default, reuseIdentifier: priceCellId)
      cell.selectionStyle = .none
      if let filter = filter {
        if let minPrice = Int(filter.list[0].cost_min_orig!), let maxPrice = Int(filter.list[0].cost_max_orig!) {
          cell.priceRange = (min: minPrice, max: maxPrice)
        }
      }
      
      return cell
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: parameterCellId, for: indexPath) as! FilterParameterTableViewCell
    cell.selectionStyle = .none
    cell.filterParameter = filter?.list[indexPath.row]
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 94
    }
    
    if let filterOptions = filter?.list[indexPath.row].options {
      return estimateHeight(forOptions: filterOptions)
    }
    
    return 164
  }
  
  private func estimateHeight(forOptions options: [FilterOption]) -> CGFloat {
    var lines = 1
    var maxWidth = CGFloat(292)
    
    for option in options {
      let estimatedOptionWidth = option.name.estimatedWidth() + 15
      if maxWidth - estimatedOptionWidth < 0 {
        lines += 1
        maxWidth = 292
      }
      maxWidth -= estimatedOptionWidth
      
      if options.last!.value == option.value {
        if maxWidth < 0 {
          lines += 1
        }
      }
    }
    
    let height = CGFloat(64 + (lines * 46))
    return height
  }
}
