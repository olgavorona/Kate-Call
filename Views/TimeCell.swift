//
//  TimeCell.swift
//  TinderCall
//
//  Created by Olga Vorona on 27/09/2018.
//  Copyright © 2018 Olga Vorona. All rights reserved.
//

import UIKit

final class TimeCell: UICollectionViewCell {
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 3
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.cornerRadius = 4
    }
    
    func setup(with viewModel: TimeViewModel, selected: Bool) {
        timeLabel.text = viewModel.timeLabel
        timeLabel.textColor = selected ? UIColor.callSea : UIColor.darkGray
        layer.shadowColor = selected ? UIColor.callSea.cgColor : UIColor.lightGray.cgColor

        
    }
    
}
