//
//  TimerFormatter.swift
//  TinderCall
//
//  Created by Olga Vorona on 15/10/2018.
//  Copyright © 2018 Olga Vorona. All rights reserved.
//

import UIKit

final class TimerFormatter {
  
    // MARK: - Constants

    private static let format = "yyyy-MM-dd HH:mm:ss Z"
    
    // MARK: - Methods

    static func string(for interval: Int) -> String {
        let seconds: Int = interval % 60
        let minutes: Int = (interval / 60) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    static func requestTime(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: date)
    
    }

}
