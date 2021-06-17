//
//  BaseNavigationController.swift
//  PopkonAir
//
//  Created by Steven on 20/10/2016.
//  Copyright © 2016 roy. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {

    let customBar : BaseNavigationBar = BaseNavigationBar.instanceFromNib()
    var defaultStatusHeight : CGFloat = 20.0
    let defaultBarHeight : CGFloat = 64.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // iPhoneX statusbar Height
        let safeAreaTop : CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0.0
        let difference = safeAreaTop - defaultStatusHeight
        customBar.frame = CGRect(x: 0, y: -1 * safeAreaTop, width: UIScreen.main.bounds.width, height: defaultBarHeight + difference)
    
        self.navigationBar.addSubview(customBar)
 
        // deprecated in IOS 9.0
        //UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        
        /*
        if let baseBar = self.navigationBar as? CustomNavigationBar {
            //Important!
            if #available(iOS 11.0, *) {
                //Default NavigationBar Height is 44. Custom NavigationBar Height is 66. So We should set additionalSafeAreaInsets to 66-44 = 22
                self.additionalSafeAreaInsets.top = baseBar.customHeight - 44
                
            }
        }
        */
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let presentingVC = self.viewControllers.last {
            return presentingVC.supportedInterfaceOrientations
        }
        return .portrait
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        if let presentingVC = self.viewControllers.last {
            return presentingVC.preferredInterfaceOrientationForPresentation
        }
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        if let presentingVC = self.viewControllers.last {
            return presentingVC.shouldAutorotate
        }
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
