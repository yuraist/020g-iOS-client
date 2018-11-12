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
  
  let acceptFilterView = AcceptFilterView(frame: .zero)
  
  var parentController: CatalogCollectionViewController?
  var filter: FilterResponse?
  
  var selectedCost: (min: Int, max: Int)? {
    didSet {
      if selectedCost != nil {
        acceptFilterView.showTwoButtons()
      } else {
        acceptFilterView.showOnlyAcceptView()
      }
      
      if let newFilterRequest = createNewFilterRequest() {
        getFilterCount(forFilterRequest: newFilterRequest)
      }
    }
  }
  
  var selectedParameters = [Int: [Int]]() {
    didSet {
      if let newFilterRequest = createNewFilterRequest() {
        getFilterCount(forFilterRequest: newFilterRequest)
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.setWhiteBackgroundColor()
    registerTableViewCells()
    fetchFilterParameters()
    
    addAcceptFilterView()
    setConstraintsForAcceptFilterView()
    setActionsForAcceptFilterViewButtons()
    
    if let filterRequest = createNewFilterRequest() {
      getFilterCount(forFilterRequest: filterRequest)
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    acceptFilterView.removeFromSuperview()
  }
  
  private func addAcceptFilterView() {
    navigationController?.view.addSubview(acceptFilterView)
  }
  
  private func setConstraintsForAcceptFilterView() {
    if let view = navigationController?.view {
      acceptFilterView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
      acceptFilterView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
      acceptFilterView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
      acceptFilterView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
  }
  
  func setActionsForAcceptFilterViewButtons() {
    let acceptGesture = UITapGestureRecognizer(target: self, action: #selector(acceptFilterParameters))
    let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(clearFilter))
    
    acceptFilterView.acceptView.addGestureRecognizer(acceptGesture)
    acceptFilterView.cancelView.addGestureRecognizer(cancelGesture)
  }
  
  @objc
  func clearFilter() {
    selectedParameters.removeAll()
    selectedCost = nil
    
    tableView.reloadRows(at: tableView.indexPathsForVisibleRows ?? [], with: .none)
    acceptFilterView.showOnlyAcceptView()
  }
  
  @objc
  func acceptFilterParameters() {
    if let filterRequest = createNewFilterRequest() {
      parentController?.update(filter: filterRequest)
      navigationController?.popViewController(animated: true)
    }
  }
  
  private func registerTableViewCells() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    tableView.register(FilterParameterTableViewCell.self, forCellReuseIdentifier: parameterCellId)
  }
  
  private func createNewFilterRequest() -> FilterRequest? {
    guard let category = parentController?.category else {
      return nil
    }
    
    let filterRequest = FilterRequest(category: "\(category.id)", page: "1", cost: selectedCost, options: selectedParameters, sort: nil)
    return filterRequest
  }
  
  private func getFilterCount(forFilterRequest filter: FilterRequest) {
    ServerManager.shared.getFilterCount(filter: filter) { (count) in
      DispatchQueue.main.async {
        self.updateNavigationTitle(withCount: count)
      }
    }
  }
  
  private func updateNavigationTitle(withCount count: Int) {
    navigationItem.title = "Фильтр - \(count) товаров"
  }
  
  private func fetchFilterParameters() {
    guard let category = parentController?.category else {
      return
    }
    
    ServerManager.shared.fetchFilter(forCategoryId: category.id) { (filterResponse) in
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
      cell.priceFromTextField.delegate = self
      cell.priceToTextField.delegate = self
      
      if filter != nil {
        cell.priceRange = (min: getOriginalMinPrice(), max: getOriginalMaxPrice())
      }
      
      if let selectedCost = selectedCost {
        cell.priceFromTextField.text = String(selectedCost.min)
        cell.priceToTextField.text = String(selectedCost.max)
      }
      
      return cell
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: parameterCellId, for: indexPath) as! FilterParameterTableViewCell
    cell.selectionStyle = .none
    cell.parentController = self
    cell.filterParameter = filter?.list[indexPath.row]
    return cell
  }
  
  private func getOriginalMinPrice() -> Int {
    return Int(filter?.list[0].cost_min_orig ?? "0") ?? 0
  }
  
  private func getOriginalMaxPrice() -> Int {
    return Int(filter?.list[0].cost_max_orig ?? "0") ?? 0
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

extension FilterTableViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return Int(string) != nil || range.length > 0
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    if selectedCost == nil {
      selectedCost = (min: getOriginalMinPrice(), max: getOriginalMaxPrice())
    }
    
    if textField.placeholder == "\(getOriginalMinPrice())" {
      if let selectedMin = Int(textField.text!) {
        selectedCost?.min = selectedMin
      }
    } else {
      if let selectedMax = Int(textField.text!) {
        selectedCost?.max = selectedMax
      }
    }
    
    return true
  }
}
