//
//  CGRect+Tools.swift
//  TFTransparentNavigationBar
//
//  Created by Ales Kocur on 10/03/2015.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

import UIKit

enum Direction {
    case Top, Bottom, Left, Right
}

extension CGRect {
    func additiveRect(value: CGFloat, direction: Direction) -> CGRect {
        
        var rect = self
        
        switch direction {
        case .Top:
            rect.origin.y -= value
            rect.size.height += value
        case .Bottom:
            rect.size.height += value
        case .Left:
            rect.origin.x -= value
            rect.size.width += value
        case .Right:
            rect.size.width += value
        }
        
        return rect
    }
}
