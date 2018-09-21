//
//  ViewController.swift
//  020g
//
//  Created by Юрий Истомин on 17/09/2018.
//  Copyright © 2018 Юрий Истомин. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  var isShowMenu = false
  
  // Add additional controllers
  var centerNavigationController: UINavigationController!
  var mainController: MainTableViewController!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = ApplicationColor.midBlue
    
    // Setup mainViewController
    mainController = MainTableViewController()
    mainController.delegate = self
    
    // Setup navigation controller
    setupNavigationController()
    setupNavigationControllerStyle()
  }
  
  private func setupNavigationController() {
    // Create a new navigation controller
    centerNavigationController = UINavigationController(rootViewController: mainController)
    
    // Setup parent-child relationship
    view.addSubview(centerNavigationController.view)
    addChild(centerNavigationController)
    centerNavigationController.didMove(toParent: self)
  }
  
  // Set the style for teh navigation bar
  private func setupNavigationControllerStyle() {
    centerNavigationController.navigationBar.barTintColor = ApplicationColor.darkBlue
    centerNavigationController.navigationBar.tintColor = ApplicationColor.white
    centerNavigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ApplicationColor.white] as [NSAttributedString.Key: Any]
  }
  
}

// MARK: CenterViewController delegate

extension ContainerViewController: CenterViewControllerDelegate {
  func toggleLeftPanel() {
    show(MenuViewController(), sender: self)
  }
  
  func addLeftPanelViewController() {
    
  }
  
  func animateLeftPanel(shouldExpand: Bool) {
    
  }
}
