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
  private let averagePriceCellId = "averagePriceCell"
  private let citiesCellId = "citiesCell"
  private let priceCellId = "priceCell"
  private let detailCellId = "detailCell"
  
  private var showExpandedCitiesCell = false
  
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
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: averagePriceCellId)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: citiesCellId)
    tableView.register(ProductPriceCell.self, forCellReuseIdentifier: priceCellId)
    tableView.register(ProductDetailCell.self, forCellReuseIdentifier: detailCellId)
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
    case 2:
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
      return cellForFirstSection(row: indexPath.row)
    } else if indexPath.section == 1 {
      return cellForSecondSection(indexPath: indexPath)
    } else if indexPath.section == 2 {
      return cellForThirdSection(indexPath: indexPath)
    }
    
    return tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
  }

  private func cellForFirstSection(row: Int) -> UITableViewCell {
    switch row {
    case 0:
      return getProducImageCarouselTableViewCell()
    case 1:
      return getPriceTableViewCell()
    case 2:
      return getCitiesTableViewCell()
    default:
      return tableView.dequeueReusableCell(withIdentifier: cellId)!
    }
  }
  
  private func cellForSecondSection(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: priceCellId, for: indexPath) as! ProductPriceCell
    cell.price = response.product.prices[indexPath.row]
    return cell
  }
  
  private func cellForThirdSection(indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: detailCellId, for: indexPath) as! ProductDetailCell
    cell.option = response.product.opts[indexPath.row]
    return cell
  }
  
  private func getProducImageCarouselTableViewCell() -> ProductImageCarouselTableViewCell {
    let cell = ProductImageCarouselTableViewCell(style: .default, reuseIdentifier: carouselCellId)
    cell.imageUrls = response.product.images
    return cell
  }
  
  private func getPriceTableViewCell() -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: averagePriceCellId)
    cell.backgroundColor = ApplicationColors.buttonBlue
    cell.textLabel?.textColor = ApplicationColors.white
    cell.textLabel?.text = response.product.costs
    return cell
  }
  
  private func getCitiesTableViewCell() ->UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: citiesCellId)
    cell.backgroundColor = ApplicationColors.gray
    
    let textLabelString = getCitiesText()
    cell.textLabel?.numberOfLines = 0
    cell.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .light)
    cell.textLabel?.text = textLabelString
    return cell
  }
  
  private func getCitiesText() -> String {
    var text = ""
    var suffix = ""
    var cities = [City]()
    if showExpandedCitiesCell {
      cities = response.cities
    } else {
      if response.cities.count > 4 {
        suffix = "все..."
      }
      cities = Array(response.cities.prefix(4))
    }
    
    for city in cities {
      if city.name != "" {
        text += "\(city.name)(\(city.count))    "
      }
    }
    
    text += suffix
    print(text)
    return text
  }
  
  private func getCitiesCellHeight(forText text: String) -> CGFloat {
    let size = CGSize(width: 300, height: 1000)
    let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
    let textRect = NSString(string: text).boundingRect(with: size, options: options, attributes: [.font: UIFont.systemFont(ofSize: 18)], context: nil)
    return textRect.height + 24
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath == IndexPath(row: 0, section: 0) {
      return getHeightForImagesCarousel()
    } else if indexPath == IndexPath(row: 2, section: 0) {
      return getCitiesCellHeight(forText: getCitiesText())
    } else if indexPath.section == 1 {
      return 64
    }
    
    return 44
  }
  
  private func getHeightForImagesCarousel() -> CGFloat {
    return view.frame.size.width
  }
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if indexPath == IndexPath(row: 2, section: 0) {
      showExpandedCitiesCell = !showExpandedCitiesCell
      
      UIView.setAnimationsEnabled(false)
      tableView.beginUpdates()
      tableView.reloadRows(at: [indexPath], with: .none)
      tableView.endUpdates()
    }
  }
}
