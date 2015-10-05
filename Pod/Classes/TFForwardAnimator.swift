//
//  TFForwardAnimator.swift
//  TFTransparentNavigationBar
//
//  Created by Ales Kocur on 10/03/2015.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

import UIKit

class TFForwardAnimator: TFNavigationBarAnimator, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.33
    }
    
    func animateTransition(context: UIViewControllerContextTransitioning) {
        
        let containerView = context.containerView()!
        let fromViewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        let toView = context.viewForKey(UITransitionContextToViewKey)!
        let fromView = context.viewForKey(UITransitionContextFromViewKey)!
        let duration = self.transitionDuration(context)
        
        // Create snapshot from navigation controller content
        let fromViewSnapshot = fromViewController.navigationController!.view.snapshotViewAfterScreenUpdates(false)
        
        // Insert toView above from view
        containerView.insertSubview(toView, aboveSubview: fromView)
        
        // Insert fromView snapshot above fromView
        containerView.insertSubview(fromViewSnapshot, belowSubview: toView)
        
        // hide fromView and use snapshot instead
        fromView.hidden = true
        
        self.navigationController.setupNavigationBarByStyle(self.navigationBarStyleTransition)
        
        let navigationControllerFrame = navigationController.view.frame
        
        if self.navigationBarStyleTransition == .toSolid {
            
            let shiftedFrame = navigationControllerFrame.additiveRect(-64, direction: .Top)
            // Move toView to the right
            toView.frame = CGRectOffset(shiftedFrame, shiftedFrame.width, 0)
            
        } else if (self.navigationBarStyleTransition == .toTransparent) {
            // Move toView to the right
            toView.frame = CGRectOffset(navigationControllerFrame, navigationControllerFrame.width, 0)
        }
        
        let toViewFinalFrame: CGRect = CGRectOffset(toView.frame, -toView.frame.width, 0)
        
        // Calculate final frame for fromView and fromViewSnapshot
        let fromViewFinalFrame = CGRectOffset(navigationControllerFrame, -(navigationControllerFrame.width * 0.3), 0)
        
        // Save origin navigation bar frame
        let navigationBarFrame = self.navigationController.navigationBar.frame
        // Shift bar
        self.navigationController.navigationBar.frame = CGRectOffset(navigationBarFrame, navigationBarFrame.width, 0)
        
        
        UIView.animateWithDuration(duration, delay: 0.0, options: [.CurveEaseOut], animations: { () -> Void in
            
            // Shift toView to the left
            toView.frame = toViewFinalFrame
            // Shift fromView to the left
            fromViewSnapshot.frame = fromViewFinalFrame
            // Shift navigation bar
            self.navigationController.navigationBar.frame = navigationBarFrame
            
            }, completion: { (completed) -> Void in
                // Show fromView
                fromView.frame = fromViewFinalFrame
                fromView.hidden = false
                // Remove snapshot
                fromViewSnapshot.removeFromSuperview()
                // Inform about transaction completion state
                context.completeTransition(!context.transitionWasCancelled())
        })
    }
}
