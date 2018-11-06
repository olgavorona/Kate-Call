//
//  ProgressHud.swift
//  TinderCall
//
//  Created by Olga Vorona on 30/10/2018.
//  Copyright © 2018 Olga Vorona. All rights reserved.
//

import UIKit

class ProgressHUD: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    
    init(text: String) {
        self.text = text
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        super.init(coder: aDecoder)
        self.setup()
        
    }
    
    func setup() {
        contentView.addSubview(activityIndictor)
        contentView.addSubview(label)
        activityIndictor.startAnimating()
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width / 2.3
            let height: CGFloat = 50.0
            self.frame = CGRect(
                x:superview.frame.size.width / 2 - width / 2,
                y: superview.frame.height / 2 - height / 2,
                width: width,
                height: height)
            
            let activityIndicatorSize: CGFloat = 40
            activityIndictor.frame = CGRect(
                x:5,
                y: height / 2 - activityIndicatorSize / 2,
                width: activityIndicatorSize,
                height: activityIndicatorSize)
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            label.text = text
            label.textAlignment = NSTextAlignment.center
            label.frame = CGRect(
                x: activityIndicatorSize + 5,
                y: 0,
                width: width - activityIndicatorSize - 15,
                height: height)
            label.textColor = UIColor.gray
            label.font = UIFont.boldSystemFont(ofSize: 16)
        }
    }
    
    func show() {
        self.isHidden = false
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func hide() {
        self.isHidden = true
        UIApplication.shared.endIgnoringInteractionEvents()
    }
}
