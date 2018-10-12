//
//  MenuViewController.swift
//  020g
//
//  Created by Юрий Истомин on 21/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit


class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  var delegate: MenuViewControllerDelegate?
  
  private let menuCellId = "menuCell"
  private let menuImageNames = ["list", "signIn", "catalogue", "pen"]
  private let menuTitles = ["Каталог цен", "Авторизация", "Страйкбольные магазины", "Задать вопрос"]
  
  private lazy var menuTableView: UITableView = {
    let tableView = UITableView(frame: .zero, style: .plain)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: menuCellId)
    return tableView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    addAndSetupMenuTableView()
  }
  
  private func addAndSetupMenuTableView() {
    view.addSubview(menuTableView)
    
    // Setup layout constraints for the menuTableView
    menuTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    menuTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    menuTableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    menuTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }
  
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuTitles.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: menuCellId, for: indexPath) as! MenuTableViewCell
    
    cell.imageView?.image = UIImage(named: menuImageNames[indexPath.row])
    
    // Setup the image
    let imageSize = CGSize(width: 22, height: 22)
    UIGraphicsBeginImageContextWithOptions(imageSize, false, UIScreen.main.scale)
    let imageRect = CGRect(origin: CGPoint.zero, size: imageSize)
    cell.imageView?.image!.draw(in: imageRect)
    cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    cell.textLabel?.text = menuTitles[indexPath.row]
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    delegate?.didSelect!(screen: menuTitles[indexPath.row])
  }
}
