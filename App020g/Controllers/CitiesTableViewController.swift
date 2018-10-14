//
//  CitiesTableViewController.swift
//  020g
//
//  Created by Юрий Истомин on 11/10/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class CitiesTableViewController: UITableViewController {
  
  private let cellId = "cellId"
  var cities = [City]() {
    didSet {
      cities = cities.sorted(by: { return $0.count > $1.count })
    }
  }
  
  var productController: ProductTableViewController?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    registerCell()
    setNavigationItemTitle()
    removeBackBarButtonTitle()
  }
  
  private func registerCell() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
  }
  
  private func setNavigationItemTitle() {
    navigationItem.title = "Доступные города"
  }
  
  private func removeBackBarButtonTitle() {
    navigationController?.navigationBar.backItem?.title = ""
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cities.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    let city = cities[indexPath.row]
    
    if isCitySelected(city) {
      cell.textLabel?.text = "\(city.count) - \(city.name) - выбран"
    } else {
      cell.textLabel?.text = "\(city.count) - \(city.name)"
    }
    
    cell.textLabel?.textColor = textColor(forCity: city)
    cell.backgroundColor = cellColor(forCity: city)
    
    return cell
  }
  
  private func isCitySelected(_ city: City) -> Bool {
    return (productController?.selectedCities.contains(where: { return $0.name == city.name }))!
  }
  
  private func textColor(forCity city: City) -> UIColor {
    return city.aviable ? ApplicationColors.green : ApplicationColors.red
  }
  
  private func cellColor(forCity city: City) -> UIColor {
    return city.aviable ? ApplicationColors.lighterGreen : ApplicationColors.lighterRed
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let city = cities[indexPath.row]
    
    tableView.deselectRow(at: indexPath, animated: true)
    
    if productController?.selectedCities != nil {
      if let index = productController!.selectedCities.firstIndex(where: { return $0.name == city.name }) {
        productController!.selectedCities.remove(at: index)
      } else {
        productController!.selectedCities.append(city)
      }
    }
    
    tableView.reloadRows(at: [indexPath], with: .none)
  }
}
