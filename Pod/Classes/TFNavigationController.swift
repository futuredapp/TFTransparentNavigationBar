//
//  TFNavigationController.swift
//  TFTransparentNavigationBar
//
//  Created by Ales Kocur on 10/03/2015.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

import UIKit

@objc public enum TFNavigationBarStyle: Int {
    case Transparent, Solid
}

@objc public protocol TFTransparentNavigationBarProtocol {
    func navigationControllerBarPushStyle() -> TFNavigationBarStyle
}

public class TFNavigationController: UINavigationController, UIViewControllerTransitioningDelegate, UINavigationControllerDelegate, UINavigationBarDelegate {
    
    private var interactionController: UIPercentDrivenInteractiveTransition?
    private var temporaryBackgroundImage: UIImage?
    var navigationBarSnapshots: Dictionary<Int, UIView> = Dictionary()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.translucent = false
        self.navigationBar.shadowImage = UIImage()

        transitioningDelegate = self   // for presenting the original navigation controller
        delegate = self                // for navigation controller custom transitions
        //interactivePopGestureRecognizer?.delegate = nil
        
        let left = UIScreenEdgePanGestureRecognizer(target: self, action: "handleSwipeFromLeft:")
        left.edges = .Left
        self.view.addGestureRecognizer(left);
        
        
    }
    
    func handleSwipeFromLeft(gesture: UIScreenEdgePanGestureRecognizer) {
        let percent = gesture.translationInView(gesture.view!).x / gesture.view!.bounds.size.width
        
        if gesture.state == .Began {
            interactionController = UIPercentDrivenInteractiveTransition()
            
            if viewControllers.count > 1 {
                popViewControllerAnimated(true)
            } else {
                dismissViewControllerAnimated(true, completion: nil)
            }
        } else if gesture.state == .Changed {
            interactionController?.updateInteractiveTransition(percent)
        } else if gesture.state == .Ended || gesture.state == .Cancelled || gesture.state == .Failed {
            
            if percent > 0.5 {
                interactionController?.finishInteractiveTransition()
            } else {
                interactionController?.cancelInteractiveTransition()
            }
            interactionController = nil
        }
    }
    
    
    // MARK: - UIViewControllerTransitioningDelegate

    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return self.forwardAnimator(source, toViewController: presented)
    }
    
    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if (viewControllers.count < 2) {
            return nil
        }
        
        // Last but one controller in stack
        let previousController = self.viewControllers[self.viewControllers.count - 2]
        
        return self.backwardAnimator(dismissed, toViewController: previousController)
    }
    
    public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    // MARK: - UINavigationControllerDelegate
    
    public func navigationController(navigationController: UINavigationController, animationControllerForOperation operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .Push {
            return self.forwardAnimator(fromVC, toViewController: toVC)
        } else if operation == .Pop {
            return self.backwardAnimator(fromVC, toViewController: toVC)
        }
        return nil
    }
    
    public func navigationController(navigationController: UINavigationController, interactionControllerForAnimationController animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactionController
    }
    
    // MARK: - Helpers
    
    func forwardAnimator(fromViewController: UIViewController, toViewController: UIViewController) -> TFForwardAnimator? {
    
        var fromStyle: TFNavigationBarStyle = TFNavigationBarStyle.Solid
        
        if let source = fromViewController as? TFTransparentNavigationBarProtocol {
            fromStyle = source.navigationControllerBarPushStyle()
        }
        
        var toStyle: TFNavigationBarStyle = TFNavigationBarStyle.Solid
        
        if let presented = toViewController as? TFTransparentNavigationBarProtocol {
            toStyle = presented.navigationControllerBarPushStyle()
        }
        
        var styleTransition: TFNavigationBarStyleTransition!
        
        if fromStyle == .Solid && toStyle == .Solid {
            return nil
        } else if (fromStyle == .Transparent && toStyle == .Transparent) {
            return nil
        } else if fromStyle == .Transparent && toStyle == .Solid {
            styleTransition = .toSolid
        } else if fromStyle == .Solid && toStyle == .Transparent {
            styleTransition = .toTransparent
        }
        
        return TFForwardAnimator(navigationController: self, navigationBarStyleTransition: styleTransition, isInteractive: interactionController != nil)
    }
    
    func backwardAnimator(fromViewController: UIViewController, toViewController: UIViewController) -> TFBackwardAnimator? {
        
        var fromStyle: TFNavigationBarStyle = TFNavigationBarStyle.Solid
        
        if let fromViewController = fromViewController as? TFTransparentNavigationBarProtocol {
            fromStyle = fromViewController.navigationControllerBarPushStyle()
        }
        
        var toStyle: TFNavigationBarStyle = TFNavigationBarStyle.Solid
        
        if let toViewController = toViewController as? TFTransparentNavigationBarProtocol {
            toStyle = toViewController.navigationControllerBarPushStyle()
        }
        var styleTransition: TFNavigationBarStyleTransition!
        
        if fromStyle == .Solid && toStyle == .Solid {
            return nil
        } else if (fromStyle == .Transparent && toStyle == .Transparent) {
            return nil
        } else if fromStyle == .Solid && toStyle == .Transparent {
            styleTransition = .toTransparent
        } else if fromStyle == .Transparent && toStyle == .Solid {
            styleTransition = .toSolid
        }
        
        return TFBackwardAnimator(navigationController: self, navigationBarStyleTransition: styleTransition, isInteractive: interactionController != nil)
    }
    
    
    func setupNavigationBarByStyle(transitionStyle: TFNavigationBarStyleTransition) {
        
        if (transitionStyle == .toTransparent) {
            // set navbar to translucent
            self.navigationBar.translucent = true
            // and make it transparent
            self.temporaryBackgroundImage = self.navigationBar.backgroundImageForBarMetrics(.Default)
            self.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
            
        } else if (transitionStyle == .toSolid) {
            
            self.navigationBar.translucent = false
            self.navigationBar.setBackgroundImage(temporaryBackgroundImage, forBarMetrics: UIBarMetrics.Default)
        }
    }
    
}

