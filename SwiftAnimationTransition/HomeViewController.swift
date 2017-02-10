//
//  HomeViewController.swift
//  SwiftAnimationTransition
//
//  Created by Jashion on 2017/2/6.
//  Copyright © 2017年 BMu. All rights reserved.
//

import UIKit
import os.log

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    
    var items: [String] {
        return ["Castle", "Web", "Sun", "Chart", "Signal"]
    }
    var myTable: UITableView {
        let table = UITableView.init(frame: UIScreen.main.bounds, style: .plain)
        table.dataSource = self as UITableViewDataSource
        table.delegate = self as UITableViewDelegate
        table.separatorStyle = .none
        table.register(MyTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(MyTableViewCell.self))
        return table
    }
    var selectedCell: MyTableViewCell?
    var snapView: UIView?
    var snapFrame: CGRect?
    
    var transition: BMAnimateTransition?
    var interactive: BMInteractiveTransition?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.navigationItem.title = "Home"
        self.transition = BMAnimateTransition.init()
        self.interactive = BMInteractiveTransition()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        self.view.addSubview(self.myTable)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.delegate = self
        
        let leftButton = UIButton.init(type: .custom)
        leftButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 44)
        leftButton.setImage(UIImage.init(named: "HomeMenu")!, for: .normal)
        leftButton.addTarget(self, action: #selector(HomeViewController.showMenuController), for: .touchUpInside)
        
        let spaceItem = UIBarButtonItem.init(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        spaceItem.width = -8
        let leftItem = UIBarButtonItem.init(customView: leftButton)
        
        self.navigationItem.leftBarButtonItems = [spaceItem, leftItem]
    }

    //MARK: UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NSStringFromClass(MyTableViewCell.self)) as! MyTableViewCell
        cell.setCellImage(image: UIImage.init(named: items[indexPath.row])!)
        return cell
    }
    
    //MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.width*3/4
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCell = tableView.cellForRow(at: indexPath) as? MyTableViewCell
        self.snapView = self.selectedCell?.snapshotView(afterScreenUpdates: false)
        self.snapFrame = self.selectedCell?.convert((self.selectedCell?.contentView.frame)!, to: self.view)
        let detail = DetailViewController.init(title: items[indexPath.row], image: UIImage.init(named: items[indexPath.row])!)
        detail.loadViewIfNeeded()
        self.interactive?.wireToViewController(viewController: detail, operation: .snapViewTransfrom)
        self.navigationController?.pushViewController(detail, animated: true)
    }
    
    @objc private func showMenuController() {
    
    }
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            let detail = toVC as! DetailViewController
            self.transition?.operationType = .snapViewTransformPush
            self.transition?.duration = 0.6
            self.transition?.snapView = self.snapView
            self.transition?.initialView = self.selectedCell
            self.transition?.initialFrame = self.snapFrame
            self.transition?.finalView = detail.topImageView
            self.transition?.finalFrame = CGRect.init(x: 0, y: 64, width: (self.snapFrame?.size.width)!, height: (self.snapFrame?.size.height)!)
            return self.transition
        } else if operation == .pop {
            let detail = fromVC as! DetailViewController
            self.transition?.operationType = .snapViewTransformPop
            self.transition?.duration = 0.6
            self.transition?.snapView = detail.topImageView?.snapshotView(afterScreenUpdates: false)
            self.transition?.initialView = detail.topImageView
            self.transition?.initialFrame = detail.topImageView?.convert((detail.topImageView?.bounds)!, to: detail.view)
            self.transition?.finalView = self.selectedCell
            self.transition?.finalFrame = self.snapFrame!
            return self.transition
        } else {
            return nil
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let isInterative = self.interactive?.interacting else {
            return nil
        }
        
        if (isInterative) {
            return self.interactive
        } else {
            return nil
        }
    }
}
