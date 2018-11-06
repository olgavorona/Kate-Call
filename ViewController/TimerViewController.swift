//
//  TimerViewController.swift
//  TinderCall
//
//  Created by Olga Vorona on 14/10/2018.
//  Copyright © 2018 Olga Vorona. All rights reserved.
//

import UIKit

final class TimerViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var timerLabel: UILabel!
    private var countdownTimer: Timer!
    private var totalTime: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalTime = Int(CallService.shared.callDate.timeIntervalSince(Date()))
        timerLabel.text = NSLocalizedString("TimerText", comment: "") + " \(TimerFormatter.string(for: totalTime))"
        startTimer()
    }
    
    // MARK: - Actions
    
    @IBAction func callNow(_ sender: Any) {
        CallService.shared.makeCall()
        cancelCall(_:self)
    }
    
    @IBAction func cancelCall(_ sender: Any) {
        CallService.shared.cancelCall()
        dismiss(animated: true) {}
    }
    
    
    // MARK: - Timer

    private func startTimer() {
        countdownTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let `self` = self else {return}
            self.updateTime()
        }
    }
    
    private func updateTime() {
        timerLabel.text = NSLocalizedString("TimerText", comment: "") + " \(TimerFormatter.string(for: totalTime))"
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            endTimer()
        }
    }
    
    private func endTimer() {
        countdownTimer.invalidate()
        CallService.shared.makeCall()
        dismiss(animated: true) {}
    }
}
