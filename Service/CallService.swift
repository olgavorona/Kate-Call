//
//  CallService.swift
//  TinderCall
//
//  Created by Olga Vorona on 11/10/2018.
//  Copyright © 2018 Olga Vorona. All rights reserved.
//

import CallKit
import AVFoundation



class CallService: NSObject, CXProviderDelegate {
   
    // MARK: - Constants
    private let nameKey = "name"
    private let callKey = "madeCall"
    private let selectedKey = "selectedKey"
    private let dateKey = "dateKey"
    private let lagConstant = -3

    private  let defaults = UserDefaults.standard

    // MARK: - Variables
    var name: String {
        set {
            defaults.set(newValue, forKey: nameKey)
        }
        get {
            let saved = defaults.string(forKey: nameKey)
            return saved ?? NSLocalizedString("Kate", comment: "")
        }
    }
    
    var selected: Int {
        set {
            defaults.set(newValue, forKey: selectedKey)
        }
        get {
            let saved = defaults.integer(forKey: selectedKey)
            return saved
        }
    }
    
    var shouldMakeCall: Bool {
        set {
            defaults.set(newValue, forKey: callKey)
        }
        get {
            let call = defaults.bool(forKey: callKey)
            return call
        }
    }
    
    var callDate: Date {
        set {
            defaults.set(newValue, forKey: dateKey)
        }
        get {
            let date = defaults.object(forKey: dateKey) as? Date
            return date ?? Date.init(timeIntervalSinceNow: 0)
        }
    }


    // MARK: - Instance

    static let shared = CallService()
    
    private override init() {}
    
    // MARK: - CXProviderDelegate delegate methods
    
    func providerDidReset(_ provider: CXProvider) {
        provider.invalidate()
    }
    
    func provider(_ provider: CXProvider,
                  perform action: CXAnswerCallAction) {
        action.fulfill()
    }
    
    func provider(_ provider: CXProvider,
                  perform action: CXEndCallAction) {
        action.fulfill()
    }
    
    
    func provider(_ provider: CXProvider,
                  didActivate audioSession: AVAudioSession) {
    }
    
    
    // MARK: - Actions

    func cancelCall() {
        shouldMakeCall = false
    }
    
    func makeCall() {
        guard shouldMakeCall else {
            return
        }
        
        shouldMakeCall = false
        let provider = CXProvider(
            configuration: CXProviderConfiguration(localizedName: "Tele"))
        provider.setDelegate(self, queue: nil)
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(
            type: .generic,
            value: name)
        provider.reportNewIncomingCall(
            with: UUID(),
            update: update,
            completion: { error in })
    }
    
    func scheduleCall(with viewModel: TimeViewModel,
                      name: String,
                      selected: Int,
                      success: @escaping CompletionBlock,
                      failure: @escaping FailureBlock) {
        self.name = name
        self.selected = selected
        shouldMakeCall = true
        callDate = Date.init(timeIntervalSinceNow: viewModel.timeInterval)
        PushService.shared.postNotification(
            for: callDate,
            success: success,
            failure: failure)
    }
    
    func checkMakeCall() -> Bool {
        var result = false
        let totalTime = Int(CallService.shared.callDate.timeIntervalSince(Date()))
        if totalTime < lagConstant {
            result = false
            shouldMakeCall = false
        } else {
            result = shouldMakeCall
        }
        return result
    }

}
