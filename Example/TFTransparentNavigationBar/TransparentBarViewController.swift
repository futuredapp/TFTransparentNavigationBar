//
//  TransparentBarViewController.swift
//  TFTransparentNavigationBar
//
//  Created by Aleš Kocur on 03/10/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import UIKit
import TFTransparentNavigationBar

class TransparentBarViewController: UIViewController, TFTransparentNavigationBarProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - TFTransparentNavigationBarProtocol
    
    func navigationControllerBarPushStyle() -> TFNavigationBarStyle {
        return .Transparent
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
