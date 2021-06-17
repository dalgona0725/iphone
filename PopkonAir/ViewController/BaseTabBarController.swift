//
//  BaseTabBarController.swift
//  PopkonAir
//
//  Created by Steven on 26/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class BaseTabBarController: UITabBarController {

    @IBOutlet weak var myTabBar: UITabBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.delegate = self
        
        // Color
        myTabBar.barTintColor = tabBarTintColor
        myTabBar.tintColor = tabBarSelectedTintColor
        myTabBar.unselectedItemTintColor = tabBarUnselectedTintColor

        NotificationCenter.default.addObserver(self, selector: #selector(didLogOut(_:)), name: NSNotification.Name(rawValue: kUserDidLogOutNoti), object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let presentingVC = self.selectedViewController {
            return presentingVC.supportedInterfaceOrientations
        }
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let presentingVC = self.selectedViewController {
            return presentingVC.preferredInterfaceOrientationForPresentation
        }
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        if let presentingVC = self.selectedViewController {
            return presentingVC.shouldAutorotate
        }
        return false
    }
    
    @objc func didLogOut(_ notification: NSNotification) {
        
    }
    
}

extension BaseTabBarController : UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if let selectedVC = tabBarController.selectedViewController {
            
            if let navigator = selectedVC as? BaseNavigationController {
                if let TopVC = navigator.topViewController {
                    if (TopVC as? NewMainHomeVC) != nil ||
                        (TopVC as? NewLiveViewController) != nil ||
                        (TopVC as? CeluvVodListViewController) != nil ||
                        (TopVC as? WatchVodListViewController) != nil ||
                        (TopVC as? NewsViewController) != nil {
                        
                        if let presentedVC = TopVC.presentedViewController {
                            presentedVC.dismiss(animated: false, completion: nil)
                        }
                    }
                }
            }
        }

        return true
    }
}

