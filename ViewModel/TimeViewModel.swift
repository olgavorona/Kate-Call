//
//  TimeViewModel.swift
//  TinderCall
//
//  Created by Olga Vorona on 27/09/2018.
//  Copyright © 2018 Olga Vorona. All rights reserved.
//

import UIKit

struct TimeViewModel {
    var selected: Bool
    let timeLabel: String
    let timeInterval: TimeInterval
    
    init(selected: Bool = false,
        timeLabel: String,
        timeInterval: TimeInterval) {
        self.selected = selected
        self.timeLabel = timeLabel
        self.timeInterval = timeInterval
    }
    
}
