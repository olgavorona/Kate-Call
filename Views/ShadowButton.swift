//
//  ShadowButton.swift
//  TinderCall
//
//  Created by Olga Vorona on 27/09/2018.
//  Copyright © 2018 Olga Vorona. All rights reserved.
//

import UIKit

final class ShadowButton: UIButton {

    override func awakeFromNib() {
        backgroundColor = UIColor.callSea
        layer.masksToBounds = false
        layer.shadowColor = UIColor.callSea.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 3
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }

}
