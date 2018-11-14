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

  var viewModel: FilterViewModel

  let acceptFilterView = AcceptFilterView(frame: .zero)
  var parentController: CatalogCollectionViewController?

  init(viewModel: FilterViewModel) {
    self.viewModel = viewModel
    super.init(style: .plain)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.setWhiteBackgroundColor()
    registerTableViewCells()
    
    addAcceptFilterView()
    setConstraintsForAcceptFilterView()
    setActionsForAcceptFilterViewButtons()
    
    setupViewModelObserving()
  }
  
  private func registerTableViewCells() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
    tableView.register(FilterParameterTableViewCell.self, forCellReuseIdentifier: parameterCellId)
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
    viewModel.selectedParameters = [:]
    viewModel.selectedCost = nil
    
    tableView.reloadRows(at: tableView.indexPathsForVisibleRows ?? [], with: .none)
    acceptFilterView.showOnlyAcceptView()
  }
  
  @objc
  func acceptFilterParameters() {
    parentController?.viewModel.filter = viewModel.filterRequest
    navigationController?.popViewController(animated: true)
  }
  
  private func setupViewModelObserving() {
    viewModel.filterCount.bind { [unowned self] (count) in
      self.updateNavigationTitle(withCount: count)
    }
  }
  
  private func updateNavigationTitle(withCount count: Int) {
    navigationItem.title = "Фильтр - \(count) товаров"
  }
  
  private func reloadTableViewData() {
    tableView.reloadData()
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.filterResponse.list.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.row == 0 {
      let cell = FilterPriceTableViewCell(style: .default, reuseIdentifier: priceCellId)
      
      cell.selectionStyle = .none
      cell.priceFromTextField.delegate = self
      cell.priceToTextField.delegate = self
      
      cell.priceRange = (min: getOriginalMinPrice(), max: getOriginalMaxPrice())
      
      if let selectedCost = viewModel.selectedCost {
        cell.priceFromTextField.text = String(selectedCost.min)
        cell.priceToTextField.text = String(selectedCost.max)
      }
      
      return cell
    }
    
    let cell = tableView.dequeueReusableCell(withIdentifier: parameterCellId, for: indexPath) as! FilterParameterTableViewCell
    cell.selectionStyle = .none
    cell.parentController = self
    cell.filterParameter = viewModel.filterResponse.list[indexPath.row]
    return cell
  }
  
  private func getOriginalMinPrice() -> Int {
    return Int(viewModel.filterResponse.list[0].cost_min_orig ?? "0") ?? 0
  }
  
  private func getOriginalMaxPrice() -> Int {
    return Int(viewModel.filterResponse.list[0].cost_max_orig ?? "0") ?? 0
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.row == 0 {
      return 94
    }
    
    if let filterOptions = viewModel.filterResponse.list[indexPath.row].options {
      return estimateHeight(forOptions: filterOptions)
    }
    
    return 164
  }
  
  private func estimateHeight(forOptions options: [FilterOption]) -> CGFloat {
    let top = 48
    let bottom = 20
    let lineHeight = 32
    let interlineOffset = 10
    
    var width = CGFloat(view.frame.width - 32)
    var lines = 1
    
    for option in options {
      let estimatedOptionWidth = option.name.estimatedWidth() + 15
      if width - estimatedOptionWidth < 0 {
        lines += 1
        width = 304 - estimatedOptionWidth
      } else {
        width -= estimatedOptionWidth
      }
    }
    
    let estimatedHeight = CGFloat(lineHeight * lines + interlineOffset * (lines - 1) + top + bottom)
    return estimatedHeight
  }
}

extension FilterTableViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    return Int(string) != nil || range.length > 0
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    
    if viewModel.selectedCost == nil {
      viewModel.selectedCost = (min: getOriginalMinPrice(), max: getOriginalMaxPrice())
    }
    
    if textField.placeholder == "\(getOriginalMinPrice())" {
      if let selectedMin = Int(textField.text!) {
        viewModel.selectedCost?.min = selectedMin
      }
    } else {
      if let selectedMax = Int(textField.text!) {
        viewModel.selectedCost?.max = selectedMax
      }
    }
    
    return true
  }
}
