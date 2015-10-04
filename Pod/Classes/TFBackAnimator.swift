//
//  TFBackwardAnimator.swift
//  TFTransparentNavigationBar
//
//  Created by Ales Kocur on 10/03/2015.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

import UIKit

class TFBackwardAnimator: TFNavigationBarAnimator, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return 0.5
    }
    
    func removeAnimationsForViews(views: [UIView]) {
        for view in views {
            view.layer.removeAllAnimations()
            removeAnimationsForViews(view.subviews)
        }
    }
    
    func animateTransition(context: UIViewControllerContextTransitioning) {
        
        let containerView = context.containerView()!
        let fromViewController = context.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        let toView = context.viewForKey(UITransitionContextToViewKey)!
        let fromView = context.viewForKey(UITransitionContextFromViewKey)!
        let duration = self.transitionDuration(context)

        let fromFrame = context.initialFrameForViewController(fromViewController)
        
        // Create snapshot from navigation controller content
        let fromViewSnapshot = fromViewController.navigationController!.view.snapshotViewAfterScreenUpdates(false)
        
        self.navigationController.setupNavigationBarByStyle(self.navigationBarStyleTransition)
        
        fromView.hidden = true

        // Insert toView below fromView
        containerView.insertSubview(toView, belowSubview: fromView)
        
        // Insert fromView snapshot
        containerView.insertSubview(fromViewSnapshot, aboveSubview: fromView)
        
        let navigationControllerFrame = navigationController.view.frame
        var toFrame: CGRect = CGRectOffset(fromFrame, -(fromFrame.width * 0.3), 0)
        var fromViewFinalFrame: CGRect = CGRectOffset(fromView.frame, fromView.frame.width, 0)
        
        if self.navigationBarStyleTransition == .toSolid {
            // Set move toView to the left about 30% of its width
            toView.frame = CGRectOffset(fromFrame, -(fromFrame.width * 0.3), 0)
            toFrame = fromFrame
            // Final frame for fromView and fromViewSnapshot
            fromViewFinalFrame = CGRectOffset(fromView.frame, fromView.frame.width, 0)
            
        } else if (self.navigationBarStyleTransition == .toTransparent) {
            // Set move toView to the left about 30% of its width
            toView.frame = CGRectOffset(navigationControllerFrame, -(navigationControllerFrame.width * 0.3), 0)
            toFrame = navigationControllerFrame
            // Final frame for fromView and fromViewSnapshot
            fromViewFinalFrame = CGRectOffset(navigationControllerFrame, navigationControllerFrame.width, 0)
        }
        
        // Save origin navigation bar frame
        let navigationBarFrame = self.navigationController.navigationBar.frame
        // Shift bar
        self.navigationController.navigationBar.frame = CGRectOffset(navigationBarFrame, -navigationBarFrame.width, 0)
        
        if self.isInteractive {
//            let navbar = UINavigationBar(frame: navigationBarFrame)
//            self.navigationController.view.insertSubview(navbar, aboveSubview: toView)
//            
//            if let items = self.navigationController.navigationBar.items {
//                navbar.setItems([items[items.count-2]], animated: false)
//            }
        }
        
        UIView.animateWithDuration(duration, delay: 0.0, options: [.CurveEaseOut, .AllowUserInteraction], animations: { () -> Void in
            
            
            // Shift fromView to the right
            fromViewSnapshot.frame = fromViewFinalFrame
            // Shift fromView to the right
            toView.frame = toFrame
            
            self.navigationController.navigationBar.frame = navigationBarFrame
            
            if self.isInteractive {
                self.navigationController.navigationBar.alpha = 1.0
            }
            
            }, completion: { (completed) -> Void in
                fromViewSnapshot.removeFromSuperview()
                
                self.navigationController.navigationBar.alpha = 1.0
                
                if context.transitionWasCancelled() {
                    
                    self.navigationController.setupNavigationBarByStyle(self.navigationBarStyleTransition.reverse())
                    
                    self.navigationController.navigationBar.frame = navigationBarFrame
                    
                    fromView.hidden = false
                    
                }
                
                context.completeTransition(!context.transitionWasCancelled())
        })
    }

    
}
