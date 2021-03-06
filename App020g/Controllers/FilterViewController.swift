//
//  FilterViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class FilterViewController: UITableViewController {
  
  private let cellId = "cell"
  private let priceCellId = "priceCell"
  private let parameterCellId = "parameterCell"

  var viewModel: FilterViewModel

  let acceptFilterView = AcceptFilterView(frame: .zero)
  var parentController: CatalogViewController?

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
    setContentInsetForTableView()
    registerTableViewCells()
    
    addAcceptFilterView()
    setConstraintsForAcceptFilterView()
    setActionsForAcceptFilterViewButtons()
    setupAcceptFilterViewButtons()
    
    setupViewModelObserving()
  }
  
  private func setContentInsetForTableView() {
    tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0)
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
    viewModel.selectedParameters.removeAll()
    viewModel.selectedCost = nil
    
    tableView.reloadRows(at: tableView.indexPathsForVisibleRows ?? [], with: .none)
    acceptFilterView.showOnlyAcceptView()
  }
  
  @objc
  func acceptFilterParameters() {
    parentController?.update(filter: viewModel.filterRequest)
    navigationController?.popViewController(animated: true)
  }
  
  @objc
  private func clearSelectedOptions(_ sender: UIButton) {
    guard let cell = sender.superview as? FilterParameterTableViewCell, let indexPath = tableView.indexPath(for: cell) else {
      return
    }
    
    if let id = cell.filterParameter?.id {
      viewModel.selectedParameters.removeValue(forKey: id)
      tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    if viewModel.selectedParameters.count == 0 {
      acceptFilterView.showOnlyAcceptView()
    }
  }
  
  private func setupAcceptFilterViewButtons() {
    if viewModel.filterRequest.options != nil && viewModel.filterRequest.options?.count != 0 {
      acceptFilterView.showTwoButtons()
    }
  }
  
  private func setupViewModelObserving() {
    viewModel.filterCount.bind { [unowned self] (count) in
      DispatchQueue.main.async {
        self.updateNavigationTitle(withCount: count)
      }
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
    
    let filterParameter = viewModel.filterResponse.list[indexPath.row]
    cell.filterParameter = filterParameter
    
    if viewModel.selectedParameters[filterParameter.id] == nil {
      cell.clearButton.isHidden = true
    } else {
      cell.clearButton.isHidden = false
    }
    
    cell.clearButton.addTarget(self, action: #selector(clearSelectedOptions(_:)), for: .touchUpInside)
    
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
    let bottom = 16
    let lineHeight = 32
    let interlineOffset = 8
    
    let viewWidth = CGFloat(tableView.frame.width - 32)
    var width = viewWidth
    var lines = 1
    
    for option in options {
      let estimatedOptionWidth = option.name.estimatedWidth() + 16
      if width - estimatedOptionWidth < 0 {
        lines += 1
        width = viewWidth - estimatedOptionWidth
      } else {
        width -= (estimatedOptionWidth + 8)
      }
    }
    
    let estimatedHeight = CGFloat(lineHeight * lines + interlineOffset * (lines - 1) + top + bottom)
    return estimatedHeight
  }
}

extension FilterViewController: UITextFieldDelegate {
  
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
