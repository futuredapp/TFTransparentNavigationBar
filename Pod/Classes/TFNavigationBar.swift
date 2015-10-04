//
//  TFNavigationBar.swift
//  Pods
//
//  Created by Aleš Kocur on 04/10/15.
//
//

import UIKit

class TFNavigationBar: UINavigationBar {

    override func pushNavigationItem(item: UINavigationItem, animated: Bool) {
        super.pushNavigationItem(item, animated: false)
    }
    
    override func popNavigationItemAnimated(animated: Bool) -> UINavigationItem? {
        return super.popNavigationItemAnimated(false)
    }
    
}
