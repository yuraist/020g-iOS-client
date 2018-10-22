//
//  ProductTableViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit
import SafariServices

class ProductTableViewController: UITableViewController {
  
  var selectedCities = [City]() {
    didSet {
      tableView.reloadData()
    }
  }
  
  var offersForSelectedCities: [Price] {
    if selectedCities.count > 0 {
      let prices = response.product.prices.filter { (price) -> Bool in
        return selectedCities.contains(where: { return $0.name == price.city})
      }
      prices.forEach { (price) in
        print(price.city)
      }
      return prices
    }
    return [Price]()
  }
  
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
    setupNavigationItem()
    registerCells()
    removeSeparatorLine()
  }
  
  private func setupNavigationItem() {
    setNavigationTitle()
    setBackBarButtonItem()
  }
  
  private func setNavigationTitle() {
    navigationItem.title = response.product.name
  }
  
  private func setBackBarButtonItem() {
    navigationController?.navigationBar.backItem?.title = ""
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
  
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch section {
    case 0: return 3
    case 1: return getNumberOfPrices()
    case 2: return response.product.opts.count
    default: return 1
    }
  }
  
  private func getNumberOfPrices() -> Int {
    if offersForSelectedCities.count > 0 {
      return offersForSelectedCities.count
    }
    return response.product.prices.count
  }
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 30
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 {
      let headerView = getBreadcrumbsHeaderView()
      return headerView
    }
    
    let headerView = getDefaultHeaderView()
    
    if section == 1 {
      headerView.text = getSecondSectionTitle()
    } else if section == 2 {
      headerView.text = getThirdSectionTitle()
    }
    
    return headerView
  }
  
  private func getBreadcrumbsHeaderView() -> BreadcrumbsCollectionView {
    let headerView = BreadcrumbsCollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30), collectionViewLayout: UICollectionViewFlowLayout())
    headerView.breadcrumbs = response.breadcrumbs
    return headerView
  }
  
  private func getDefaultHeaderView() -> CustomHeaderView {
    return CustomHeaderView(frame: .zero)
  }
  
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    switch section {
    case 0:
      return getFirstSecionTitle()
    case 1:
      return getSecondSectionTitle()
    case 2:
      return getThirdSectionTitle()
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
    return response.product.name
  }
  
  
  private func getThirdSectionTitle() -> String {
    return "Детально"
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
    
    if offersForSelectedCities.count > 0 {
      cell.price = offersForSelectedCities[indexPath.row]
    } else {
      cell.price = response.product.prices[indexPath.row]
    }
    
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
    let cell = UITableViewCell(style: .value1, reuseIdentifier: citiesCellId)
    cell.textLabel?.text = "Доступные города"
    cell.accessoryType = .disclosureIndicator
    
    if selectedCities.count > 0 {
      cell.detailTextLabel?.text = "[\(selectedCities.count)]"
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath == IndexPath(row: 0, section: 0) {
      return getHeightForImagesCarousel()
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
      showCitiesTableViewController()
    } else if indexPath.section == 1 {
      if offersForSelectedCities.count > 0 {
        let price = offersForSelectedCities[indexPath.row]
        showShopWebview(price)
      } else {
        let price = response.product.prices[indexPath.row]
        showShopWebview(price)
      }
    }
  }
  
  private func showCitiesTableViewController() {
    let citiesTableViewController = CitiesTableViewController()
    citiesTableViewController.cities = getValidCities()
    citiesTableViewController.productController = self
    show(citiesTableViewController, sender: self)
  }
  
  private func showShopWebview(_ price: Price) {
    if let shopUrl = URL(string: "http://020g.ru/go?id=\(price.id)") {
      let safariViewController = SFSafariViewController(url: shopUrl)
      present(safariViewController, animated: true, completion: nil)
    }
  }
  
  private func getValidCities() -> [City] {
    return response.cities.filter({ $0.name != "" && $0.name != "Город" })
  }
}
