//
//  ProductTableViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class BreadcrumbCollectionViewCell: UICollectionViewCell {
  
  var breadcrumb: Breadcrumb? {
    didSet {
      if let breadcrumb = breadcrumb {
        breadcrumbNameLabel.text = breadcrumb.name
        if !isLastCell {
          breadcrumbNameLabel.text = breadcrumb.name + "  >"
        } else {
          breadcrumbNameLabel.textAlignment = .left
        }
      }
    }
  }
  
  var isLastCell = false
  
  private let breadcrumbNameLabel: UILabel = {
    let label = UILabel()
    label.textColor = ApplicationColors.lightGray
    label.font = UIFont.systemFont(ofSize: 14)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    
    addLabel()
    setupLabelConstraints()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func addLabel() {
    addSubview(breadcrumbNameLabel)
  }
  
  private func setupLabelConstraints() {
    breadcrumbNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    breadcrumbNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    breadcrumbNameLabel.widthAnchor.constraint(equalTo: widthAnchor, constant: -4).isActive = true
    breadcrumbNameLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
  }
}

class BreadcrumbsCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  private let cellId = "cellId"
  var breadcrumbs = [Breadcrumb]() {
    didSet {
      reloadData()
      scrollToItem(at: IndexPath(item: breadcrumbs.count - 1, section: 0), at: .left, animated: false)
    }
  }
  
  override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
    super.init(frame: frame, collectionViewLayout: layout)
    setWhiteBackgroundColor()
    setDelegate()
    setDataSource()
    registerCell()
    setupCollectionViewLayout()
    hideCollectionViewScrollIndicator()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setWhiteBackgroundColor() {
    backgroundColor = ApplicationColors.gray
  }
  
  private func setDelegate() {
    delegate = self
  }
  
  private func setDataSource() {
    dataSource = self
  }
  
  private func registerCell() {
    register(BreadcrumbCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  private func setupCollectionViewLayout() {
    if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
      layout.scrollDirection = .horizontal
    }
  }
  
  private func hideCollectionViewScrollIndicator() {
    showsHorizontalScrollIndicator = false
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return breadcrumbs.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let item = indexPath.item
    let breadcrumb = breadcrumbs[item]
    let isLastCell = item == (breadcrumbs.count - 1)
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! BreadcrumbCollectionViewCell
    cell.isLastCell = isLastCell
    cell.breadcrumb = breadcrumb
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let breadcrumbName = breadcrumbs[indexPath.item].name + " >"
    let width = computeBreadcrumbWidth(breadcrumbName: breadcrumbName)
    return CGSize(width: width, height: 30)
  }
  
  private func computeBreadcrumbWidth(breadcrumbName name: String) -> CGFloat {
    let initialStringSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20)
    let size = NSString(string: name).boundingRect(with: initialStringSize, options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 14)], context: nil)
    
    return size.width + 12
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
}

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
    navigationItem.backBarButtonItem?.title = ""
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
  
  override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 30
    } else {
      return super.tableView(tableView, heightForHeaderInSection: section)
    }
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 0 {
      let headerView = BreadcrumbsCollectionView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30), collectionViewLayout: UICollectionViewFlowLayout())
      headerView.breadcrumbs = response.breadcrumbs
      return headerView
    } else {
      return super.tableView(tableView, viewForHeaderInSection: section)
    }
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
    return response.product.name
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
