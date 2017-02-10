//
//  AppDelegate.swift
//  SwiftAnimationTransition
//
//  Created by 黄锦华 on 2017/2/5.
//  Copyright © 2017年 BMu. All rights reserved.
//

import UIKit

let kRect = UIScreen.main.bounds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, CAAnimationDelegate {
    
    var window: UIWindow?
    var container: UIView?
    var maskView: UIImageView?
    var splashView: UIImageView?
    var path: UIBezierPath?
    var tabVC: UITabBarController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        self.tabVC = self.createTabController()
        window?.rootViewController = self.tabVC!
        window?.makeKeyAndVisible()
        self.lanuchSplashAnimation()
        return true
    }
    
    //MARK：Private Method

    func createTabController() -> UITabBarController{
        let home = HomeViewController()
        let homeNav = UINavigationController.init(rootViewController: home)
        homeNav.navigationBar.tintColor = ColorUtils.mainColor()
        homeNav.tabBarItem.title = "Home"
        homeNav.tabBarItem.image = UIImage.init(named: "HomeUnSelect")!
        homeNav.tabBarItem.selectedImage = UIImage.init(named: "HomeSelect")!
        
        let message = MessageViewController()
        let messageNav = UINavigationController.init(rootViewController: message)
        messageNav.navigationBar.tintColor = ColorUtils.mainColor()
        messageNav.tabBarItem.title = "Message"
        messageNav.tabBarItem.image = UIImage.init(named: "MessageUnSelect")
        messageNav.tabBarItem.selectedImage = UIImage.init(named: "MessageSelect")
        
        let setting = SettingViewController()
        let settingNav = UINavigationController.init(rootViewController: setting)
        settingNav.navigationBar.tintColor = ColorUtils.mainColor()
        settingNav.tabBarItem.title = "Setting"
        settingNav.tabBarItem.image = UIImage.init(named: "SettingUnSelect")
        settingNav.tabBarItem.selectedImage = UIImage.init(named: "SettingSelect")
        
        let tabBarController = UITabBarController.init()
        tabBarController.viewControllers = [homeNav, messageNav, settingNav]
        tabBarController.tabBar.tintColor = ColorUtils.mainColor()
        tabBarController.delegate? = self as! UITabBarControllerDelegate
        return tabBarController
    }

    func lanuchSplashAnimation() {
        let rect = UIScreen.main.bounds
        self.container = UIView.init(frame: rect)
        self.container?.backgroundColor = UIColor.white
        self.window?.addSubview(self.container!)
        
        self.splashView = UIImageView.init(frame: rect)
        self.splashView?.image = UIImage.init(named: "LaunchSplashImage")
        self.splashView?.alpha = 0;
        self.container?.addSubview(self.splashView!)
        
        self.maskView = UIImageView.init(image: UIImage.init(named: "WhiteCircleImage")!.imageWithTintColor(tintColor: UIColor.init(colorLiteralRed: 1.0, green: 0.8, blue: 0.0, alpha: 1.0), blendMode: .destinationIn))
        self.maskView?.bounds = CGRect.init(x: 0, y: 0, width: 60, height: 60)
        self.maskView?.center = CGPoint.init(x: 0, y: kRect.size.height/2 + 100)
        self.maskView?.backgroundColor = UIColor.clear
        self.window?.addSubview(self.maskView!)
        
        let path = UIBezierPath.init()
        path.move(to: CGPoint.init(x: 0, y: kRect.size.height/2 + 100))
        path.addQuadCurve(to: CGPoint.init(x: kRect.size.width/6, y: kRect.size.height - 60), controlPoint: CGPoint.init(x: kRect.size.width/6 - 20, y: kRect.size.height/2 + 100))
        
        let keyAnimation = CAKeyframeAnimation.init(keyPath: "position")
        keyAnimation.path = path.cgPath
        
        let basicAnimation = CABasicAnimation.init(keyPath: "transform.scale")
        basicAnimation.toValue = NSValue.init(cgSize:  CGSize.init(width: 0.8, height: 0.8))
        
        let group = CAAnimationGroup.init()
        group.duration = 0.5
        group.fillMode = kCAFillModeForwards
        group.isRemovedOnCompletion = false
        group.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
        group.animations = [keyAnimation, basicAnimation]
        group.delegate = self as CAAnimationDelegate
        group.setValue("firstStep", forKey: "animationName")
        
        self.maskView?.layer.add(group, forKey: "firstStep")
    }
    
    //MARK: CAAnimationDelegate
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        let rect = self.maskView?.frame
        guard let animateName = anim.value(forKey: "animationName")! as? String else {
            return
        }
        
        switch animateName {
        case "firstStep":
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseInOut, animations: {
                self.maskView?.bounds = CGRect.init(x: 0, y: 0, width: (rect?.size.width)!*1.2, height: (rect?.size.height)!*0.8)
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.maskView?.bounds = rect!
                })
                
                let path = UIBezierPath.init()
                path.move(to: CGPoint.init(x: kRect.size.width/6, y: kRect.size.height-60))
                path.addQuadCurve(to: CGPoint.init(x: kRect.size.width/2, y:  kRect.size.height*3/4), controlPoint: CGPoint.init(x: kRect.size.width/2 - 50, y: kRect.size.height*3/4 - 50))
                
                let keyAnimation = CAKeyframeAnimation.init(keyPath: "position")
                keyAnimation.path = path.cgPath
                
                let basicAnimation = CABasicAnimation.init(keyPath: "transform.scale")
                basicAnimation.toValue = NSValue.init(cgSize: CGSize.init(width: 0.5, height: 0.5))
                
                let group = CAAnimationGroup.init()
                group.duration = 0.6
                group.fillMode = kCAFillModeForwards
                group.isRemovedOnCompletion = false
                group.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
                group.animations = [keyAnimation, basicAnimation]
                group.delegate = self as CAAnimationDelegate
                group.setValue("secondStep", forKey: "animationName")
                
                self.maskView?.layer.add(group, forKey: "secondStep")
            })
        case "secondStep":
            UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut, animations: {
                self.maskView?.bounds = CGRect.init(x: 0, y: 0, width: (rect?.size.width)!*1.2, height: (rect?.size.height)!*0.8)
            }, completion: { (finished) in
                UIView.animate(withDuration: 0.1, animations: {
                    self.maskView?.bounds = rect!
                })
                
                let path = UIBezierPath.init()
                path.move(to: CGPoint.init(x: kRect.size.width/2, y: kRect.size.height*3/4))
                path.addLine(to: CGPoint.init(x: kRect.size.width/2, y:  kRect.size.height/2))
                
                let keyAnimation = CAKeyframeAnimation.init(keyPath: "position")
                keyAnimation.path = path.cgPath
                
                let basicAnimation = CABasicAnimation.init(keyPath: "transform.scale")
                basicAnimation.toValue = NSValue.init(cgSize: CGSize.init(width: 0.7, height: 0.7))
                
                let group = CAAnimationGroup.init()
                group.duration = 0.3
                group.fillMode = kCAFillModeForwards
                group.isRemovedOnCompletion = false
                group.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
                group.animations = [keyAnimation, basicAnimation]
                group.delegate = self as CAAnimationDelegate
                group.setValue("finalStep", forKey: "animationName")
                
                self.maskView?.layer.add(group, forKey: "finalStep")
            })
        case "finalStep":
            let radius = sqrtf(powf(Float(kRect.size.width), 2)+powf(Float(kRect.size.height), 2))
            
            let maskContentView = UIView.init()
            maskContentView.bounds = CGRect.init(x: 0, y: 0, width: 42, height: 42)
            maskContentView.center = CGPoint.init(x: kRect.size.width/2, y: kRect.size.height/2)
            maskContentView.backgroundColor = UIColor.init(red: 1.0, green: 0.8, blue: 0.0, alpha: 1.0)
            maskContentView.layer.cornerRadius = 21
            maskContentView.layer.masksToBounds = true
            self.window?.addSubview(maskContentView)
            
            self.maskView?.removeFromSuperview()
            self.splashView?.layer.mask = maskContentView.layer
            UIView.animate(withDuration: 0.4, animations: {
                self.splashView?.alpha = 1
                maskContentView.transform = CGAffineTransform.init(scaleX: CGFloat.init(radius/42), y: CGFloat.init(radius/42))
            }, completion: { (finished) in
                UIView.transition(from: self.container!, to: (self.tabVC?.view)!, duration: 0.6, options: .transitionFlipFromLeft, completion: { (finished) in
                    self.container?.removeFromSuperview()
                })
            })
        default:
            return
        }
    }
}

