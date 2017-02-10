//
//  BMAnimateTransition.swift
//  SwiftAnimationTransition
//
//  Created by Jashion on 2017/2/8.
//  Copyright © 2017年 BMu. All rights reserved.
//

import UIKit

class BMAnimateTransition: NSObject, UIViewControllerAnimatedTransitioning, CAAnimationDelegate{
    enum BMAnimateTransitionOperationType {
        case custom
        case snapViewTransformPush
        case snapViewTransformPop
        case circleLayerPush
        case circleLayerPop
        case tabBarCircleLayer
    }
    
    var operationType: BMAnimateTransitionOperationType = .custom
    var duration: TimeInterval = 0.1
    
    var snapView: UIView?
    var initialView: UIView?
    var initialFrame: CGRect?
    var finalView: UIView?
    var finalFrame: CGRect?
    
    var transitionContext: UIViewControllerContextTransitioning?
    
    override init() {
        self.duration = 0.4
        self.operationType = .custom
        super.init()
    }
    
    init(duration: TimeInterval, operation: BMAnimateTransitionOperationType) {
        self.duration = duration
        self.operationType = operation
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let container = transitionContext.containerView
        let fromVC = transitionContext.viewController(forKey: .from)
        let toVC = transitionContext.viewController(forKey: .to)
        
        if self.operationType == .custom {
            return
        }
        
        if self.operationType == .snapViewTransformPush {
            container.addSubview((toVC?.view)!)
            
            self.finalView?.isHidden = true
            toVC?.view.alpha = 0
            
            self.snapView?.frame = self.initialFrame!
            container.addSubview(self.snapView!)
            
            UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { 
                self.snapView?.frame = self.finalFrame!
                toVC?.view.alpha = 1.0
            }, completion: { (true) in
                self.finalView?.isHidden = false
                self.snapView?.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            return
        }
        
        if self.operationType == .snapViewTransformPop {
            container.addSubview((toVC?.view)!)
            container.addSubview((fromVC?.view)!)
            
            self.initialView?.isHidden = true
            self.finalView?.isHidden = true
            toVC?.view.alpha = 0
            
            self.snapView?.frame = self.initialFrame!
            container.addSubview(self.snapView!)
            
            UIView.animate(withDuration: self.duration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: { 
                self.snapView?.frame = self.finalFrame!
                toVC?.view.alpha = 1.0
                fromVC?.view.alpha = 0
            }, completion: { (true) in
                self.finalView?.isHidden = false
                self.initialView?.isHidden = !transitionContext.transitionWasCancelled
                self.snapView?.removeFromSuperview()
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            
            return
        }
    }
}
