//
//  AnalyticsService.swift
//  TinderCall
//
//  Created by Olga Vorona on 27/10/2018.
//  Copyright © 2018 Olga Vorona. All rights reserved.
//

import Firebase

final class AnalyticsService {
  
    fileprivate enum CustomParametersName: String {
        case callerName
        case cancelName
        case timeInterval
        case setupCall
        case cancel
        case callNow
    }
    
    fileprivate enum CustomParameters: String {
        case remainingTime
        case callType
    }
    
    fileprivate enum CustomEvents: String {
        case cancel
        case call
    }
    
    enum CallTypes: String {
        case screen
        case push
        case manual
    }
    
    // MARK: - Instance
    
    static let shared = AnalyticsService()
    
    private init() {}
    
    // MARK: - Methods

    func setup() {
        FirebaseApp.configure()
    }
    
    // MARK: - Analytics

    func log(select time: Double) {
        let parameters: [String: Any] =
            [AnalyticsParameterValue: time,
            AnalyticsParameterItemName: CustomParametersName.timeInterval.rawValue]

        Analytics.logEvent(
            AnalyticsEventSelectContent,
            parameters: parameters)
    }
    
    func logAddPressed() {
        let parameters: [String: Any] =
            [AnalyticsParameterItemName: CustomParametersName.callerName.rawValue]
        
        Analytics.logEvent(
            AnalyticsEventViewItem,
            parameters: parameters)
    }
    
    func logCancelNamePressed() {
        let parameters: [String: Any] =
            [AnalyticsParameterItemName: CustomParametersName.callerName.rawValue]
        
        Analytics.logEvent(
            CustomEvents.cancel.rawValue,
            parameters: parameters)
    }
    
    func log(select name: String) {
        let parameters: [String: Any] =
            [AnalyticsParameterItemName: CustomParametersName.callerName,
             AnalyticsParameterItemVariant: name]
        
        Analytics.logEvent(
            AnalyticsEventSelectContent,
            parameters: parameters)
    }
    
    func log(setupCall name: String,
             time: Double) {
        let parameters: [String: Any] =
            [AnalyticsParameterItemName: CustomParametersName.callerName,
             AnalyticsParameterItemVariant: name,
             AnalyticsParameterValue: time
             ]
        
        Analytics.logEvent(
            AnalyticsEventSelectContent,
            parameters: parameters)
    }
    
    
    func logCancelCall( ) {
        let parameters: [String: Any] =
            [AnalyticsParameterItemName: CustomParametersName.callNow]
        
        Analytics.logEvent(
            AnalyticsEventSelectContent,
            parameters: parameters)
    }
    
    func log(call time: Double,
             remainingTime: Double,
             name: String,
             type: CallTypes) {
        let parameters: [String: Any] =
            [AnalyticsParameterItemName: CustomParametersName.callNow,
             AnalyticsParameterValue: time,
             CustomParameters.remainingTime.rawValue: remainingTime,
             AnalyticsParameterItemVariant: name,
             CustomParameters.callType.rawValue: type.rawValue
        ]
        
        Analytics.logEvent(
            CustomEvents.call.rawValue,
            parameters: parameters)
    }
    
    
}
