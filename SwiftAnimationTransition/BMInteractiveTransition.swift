//
//  BMInteractiveTransition.swift
//  SwiftAnimationTransition
//
//  Created by Jashion on 2017/2/9.
//  Copyright © 2017年 BMu. All rights reserved.
//

import UIKit

class BMInteractiveTransition: UIPercentDrivenInteractiveTransition {
    enum BMInteractiveTransitionType {
        case snapViewTransfrom
        case circleLayer
        case tabBarCircleLayer
    }
    
    public var interacting: Bool?
    
    var controller: UIViewController?
    var shouldComplete: Bool?
    var opertionType: BMInteractiveTransitionType?
    
    public func wireToViewController(viewController: UIViewController, operation: BMInteractiveTransitionType) {
        self.controller = viewController
        self.opertionType = operation
        let screenEdgePan = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(BMInteractiveTransition.handleInteractiveGesture(gesture:)))
        screenEdgePan.edges = UIRectEdge.left
        viewController.view.addGestureRecognizer(screenEdgePan)
    }
    
    @objc private func handleInteractiveGesture(gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: gesture.view?.superview)
        
        switch gesture.state {
        case .began:
            self.interacting = true
            if self.opertionType == .snapViewTransfrom {
                _ = self.controller?.navigationController?.popViewController(animated: true)
            } else {
                self.controller?.dismiss(animated: true, completion: nil)
            }
        case .changed:
            var fraction = translation.x/(kRect.size.width/2)
            fraction = CGFloat(fminf(fmaxf(Float(fraction), 0.0), 1.0))
            self.shouldComplete =  self.opertionType == .snapViewTransfrom ? (fraction > 0.15) : (fraction > 0.5)
            self.update(fraction)
        case .cancelled, .ended:
            self.interacting = false
            if self.shouldComplete! {
                self.finish()
            } else {
                self.cancel()
            }
        default:
            break
        }
    }
}
