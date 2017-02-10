//
//  MyTableViewCell.swift
//  SwiftAnimationTransition
//
//  Created by Jashion on 2017/2/7.
//  Copyright © 2017年 BMu. All rights reserved.
//

import UIKit

class MyTableViewCell: UITableViewCell {
    
    var cellImageView: UIImageView?

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.build()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Public Method
    
     func setCellImage(image: UIImage) {
        self.cellImageView?.image = image
    }
    
    //Private Method
    
    func build() {
        self.cellImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width*3/4))
        self.cellImageView?.isUserInteractionEnabled = true
        let longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(MyTableViewCell.handleLongPressGesture(longPress:)))
        self.cellImageView?.addGestureRecognizer(longPress)
        self.contentView.addSubview(self.cellImageView!)
    }
    
    func handleLongPressGesture(longPress: UILongPressGestureRecognizer) {
        
    }
}
