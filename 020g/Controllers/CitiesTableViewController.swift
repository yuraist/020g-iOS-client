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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    registerCell()
    setNavigationItemTitle()
  }
  
  private func registerCell() {
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellId)
  }
  
  private func setNavigationItemTitle() {
    navigationItem.title = "Доступные города"
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return cities.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
    let city = cities[indexPath.row]
    cell.textLabel?.text = city.name + " (\(city.count))"
    return cell
  }
}