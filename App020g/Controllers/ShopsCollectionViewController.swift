//
//  ShopsCollectionViewController.swift
//  020g
//
//  Created by Юрий Истомин on 25/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit
import SafariServices

class ShopsCollectionViewController: CenterViewController, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  
  private let cellId = "shopListCellId"
  var collectionView: UICollectionView?
  
  private var viewModel: ShopsViewModel
  
  var shops = [Shop]() {
    didSet {
      DispatchQueue.main.async {
        self.reloadCollectionView()
        self.updateCollectionViewLayout()
      }
    }
  }
  
  private var navigationControllerHeight: CGFloat {
    get {
      if let navigationControllerHeight = navigationController?.navigationBar.frame.size.height {
        return navigationControllerHeight
      }
        return 0
    }
  }
  
  init(viewModel: ShopsViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    createAndAddCollectionView()
    setupCollectionViewConstraints()
    collectionView?.setWhiteBackgroundColor()
    setNavigationTitle()
    setCollectionViewDelegateAndDataSource()
    registerCollectionViewCell()
    
    viewModel.fetch { [unowned self] in
      DispatchQueue.main.async {
        self.reloadCollectionView()
        self.updateCollectionViewLayout()
      }
    }
  }
  
  private func createAndAddCollectionView() {
    collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    view.addSubview(collectionView!)
  }
  
  private func setupCollectionViewConstraints() {
    collectionView?.translatesAutoresizingMaskIntoConstraints = false
    collectionView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    collectionView?.heightAnchor.constraint(equalTo: view.heightAnchor, constant: -navigationControllerHeight).isActive = true
    collectionView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
  
  private func setNavigationTitle() {
    navigationItem.title = "Страйкбольные магазины"
  }
  
  private func setCollectionViewDelegateAndDataSource() {
    collectionView?.delegate = self
    collectionView?.dataSource = self
  }
  
  private func registerCollectionViewCell() {
    collectionView?.register(ShopCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
  }
  
  private func fetchShops() {
    ApiHandler.shared.fetchShops { (success, shops) in
      if let shops = shops {
          self.shops = shops
      }
    }
  }
  
  private func reloadCollectionView() {
    updateCollectionViewData()
  }
  
  private func updateCollectionViewData() {
    collectionView?.reloadData()
  }
  
  private func updateCollectionViewLayout() {
    collectionView?.collectionViewLayout.invalidateLayout()
  }
  
  
  // MARK: - Collection view data source

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return viewModel.shops.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ShopCollectionViewCell
    
    cell.shop = viewModel.shops[indexPath.item]
    cell.contactButton.addTarget(self, action: #selector(openContactInSafari(sender:)), for: .touchUpInside)
    if cell.shop?.vkGroup != nil {
      cell.vkGroupButton.addTarget(self, action: #selector(openContactInSafari(sender:)), for: .touchUpInside)
    }
    
    return cell
  }
  
  @objc private func openContactInSafari(sender: ContactButton) {
    if let contactUrl = sender.contactUrl {
      let safariViewController = SFSafariViewController(url: contactUrl)
      present(safariViewController, animated: true, completion: nil)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let cellHeight = viewModel.shops[indexPath.item].cellHeight
    return CGSize(width: view.frame.width, height: cellHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 0
  }
}
