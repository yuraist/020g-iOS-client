//
//  MainTableViewController.swift
//  020g
//
//  Created by Юрий Истомин on 21/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
  
  var delegate: CenterViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationItem.title = "0.20g - агрегатор №1"
    setupNavigationItem()
  }
  
  // Setup items of the navigation bar
  private func setupNavigationItem() {
    let loginButton = UIButton()
    loginButton.setImage(#imageLiteral(resourceName: "signIn").withRenderingMode(.alwaysTemplate), for: .normal)
    loginButton.tintColor = ApplicationColor.white
    loginButton.addTarget(self, action: #selector(showAuthorizationViewController), for: .touchUpInside)
    
    let searchButton = UIButton()
    searchButton.setImage(#imageLiteral(resourceName: "search").withRenderingMode(.alwaysTemplate), for: .normal)
    searchButton.tintColor = ApplicationColor.white
    searchButton.addTarget(self, action: #selector(showSearchCollectionViewController), for: .touchUpInside)
    
    let menuButton = UIButton()
    menuButton.setImage(#imageLiteral(resourceName: "menu").withRenderingMode(.alwaysTemplate), for: .normal)
    menuButton.tintColor = ApplicationColor.white
    menuButton.addTarget(self, action: #selector(showMenu), for: .touchUpInside)
    
    loginButton.translatesAutoresizingMaskIntoConstraints = false
    searchButton.translatesAutoresizingMaskIntoConstraints = false
    menuButton.translatesAutoresizingMaskIntoConstraints = false
    
    let loginBarButtonItem = UIBarButtonItem(customView: loginButton)
    let searchBarButtonItem = UIBarButtonItem(customView: searchButton)
    let menuBarButtonItem = UIBarButtonItem(customView: menuButton)
    
    setupBarButtonConstraints(forBarItem: loginBarButtonItem)
    setupBarButtonConstraints(forBarItem: searchBarButtonItem)
    setupBarButtonConstraints(forBarItem: menuBarButtonItem)
    
    navigationItem.rightBarButtonItems = [loginBarButtonItem, searchBarButtonItem]
    navigationItem.leftBarButtonItem = menuBarButtonItem
  }
  
  private func setupBarButtonConstraints(forBarItem item: UIBarButtonItem) {
    item.customView?.widthAnchor.constraint(equalToConstant: 22).isActive = true
    item.customView?.heightAnchor.constraint(equalToConstant: 22).isActive = true
  }
  
  @objc private func showAuthorizationViewController() {
    present(UINavigationController(rootViewController: AuthorizationViewController()), animated: true, completion: nil)
  }
  
  @objc private func showSearchCollectionViewController() {
    
  }
  
  @objc private func showMenu() {
    delegate?.toggleLeftPanel?()
  }
  
  private func slideInMenuView() {
    
  }
  
  private func slideOutMenuView() {
    
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    // #warning Incomplete implementation, return the number of sections
    return 0
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete implementation, return the number of rows
    return 0
  }
  
  /*
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
   let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
   
   // Configure the cell...
   
   return cell
   }
   */
  
  /*
   // Override to support conditional editing of the table view.
   override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the specified item to be editable.
   return true
   }
   */
  
  /*
   // Override to support editing the table view.
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
   if editingStyle == .delete {
   // Delete the row from the data source
   tableView.deleteRows(at: [indexPath], with: .fade)
   } else if editingStyle == .insert {
   // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
   }
   }
   */
  
  /*
   // Override to support rearranging the table view.
   override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
   
   }
   */
  
  /*
   // Override to support conditional rearranging of the table view.
   override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
   // Return false if you do not want the item to be re-orderable.
   return true
   }
   */
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destination.
   // Pass the selected object to the new view controller.
   }
   */
  
}
