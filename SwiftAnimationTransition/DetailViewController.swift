//
//  DetailViewController.swift
//  SwiftAnimationTransition
//
//  Created by Jashion on 2017/2/8.
//  Copyright © 2017年 BMu. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var topImage: UIImage?
    var topImageView: UIImageView?
    var detailTableView: UITableView?
    var names: [String] {
        return ["morgan", "Jashion", "Kevin Burr", "Sean Furr", "Marry", "Stan", "Sulian", "Sheet"]
    }
    var contents: [String] {
        return ["Awesome atmosphere.I like it!Can i get your contact?", "Love it!You are very excellent!God bless you,AMEN.", "Great!Something like you.I want to learn!Hehe,can you teach me?", "like it to much.I painted it as you.", "Nice :)", "Sweet Lord.This is gorgeous,great job guys!", "Supernice! Can i have it printed on poster please? :)", "Whoa!This is amazing."]
    }
    var avatars: [String] {
        return ["morgan", "Jashion", "Kevin Burr", "Sean Furr", "Marry", "Stan", "Sulian", "Sheet"]
    }
    var titles: [String] {
        return ["Roma Datsyuk", "Balkan Brothers", "Shamsuddin", "Jakub Nespor", "Thomas Meijer", "Stan", "Sulian", "Sheet"]
    }
    
    init(title: String, image: UIImage) {
       super.init(nibName: nil, bundle: nil)
       self.navigationItem.title = title
       self.topImage = image
       self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        
        let backButton = UIButton.init(type: .system)
        backButton.frame = CGRect.init(x: 0, y: 0, width: 40, height: 44)
        backButton.setImage(UIImage.init(named: "BackIcon")!, for: .normal)
        backButton.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0)
        backButton.addTarget(self, action: #selector(DetailViewController.back), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: backButton)
        
        self.topImageView = UIImageView.init(image: topImage!)
        self.topImageView?.frame = CGRect.init(x: 0, y: 64, width: kRect.size.width, height: kRect.size.width*3/4)
        self.topImageView?.contentMode = .scaleToFill
        self.view.addSubview(self.topImageView!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white
    }

    @objc private func back() {
        _ = self.navigationController?.popViewController(animated: true)
    }
}
