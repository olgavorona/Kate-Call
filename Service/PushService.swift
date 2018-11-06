//
//  PushService.swift
//  TinderCall
//
//  Created by Olga Vorona on 04/10/2018.
//  Copyright © 2018 Olga Vorona. All rights reserved.
//

import UIKit
import OneSignal
import PushKit
import Reachability

final class PushService: NSObject, PKPushRegistryDelegate {
    
    // MARK: - Constants
    private  let tokenKey = "token"
    private  let defaults = UserDefaults.standard

    // MARK: - Variables
    
    var deviceId: String = ""
    var token: String {
        set {
            defaults.set(newValue, forKey: tokenKey)
        }
        get {
            let saved = defaults.string(forKey: tokenKey)
            return saved ?? ""
        }
    }
    // MARK: - Instance
    
    static let shared = PushService()
    
    private override init() {}
    
    
    // Register for VoIP notifications
    func voipRegistration() {
        let mainQueue = DispatchQueue.main
        let voipRegistry: PKPushRegistry = PKPushRegistry(queue: mainQueue)
        voipRegistry.delegate = self
        voipRegistry.desiredPushTypes = [PKPushType.voIP]
    }
    
    // MARK: - PKPushRegistryDelegate
    
    func pushRegistry(_ registry: PKPushRegistry,
                      didReceiveIncomingPushWith payload: PKPushPayload,
                      for type: PKPushType) {
        if type == PKPushType.voIP {
            CallService.shared.makeCall()
        }
        
    }
    // Registry token
    func pushRegistry(_ registry: PKPushRegistry,
                      didUpdate pushCredentials: PKPushCredentials,
                      for type: PKPushType) {
        if type == PKPushType.voIP {
            let token = pushCredentials.token.map { String(format: "%02.2hhx", $0) }.joined()
            self.token = token
            sendToken()
        }
    }
    
    func pushRegistry(_ registry: PKPushRegistry,
                      didReceiveIncomingPushWith payload: PKPushPayload,
                      for type: PKPushType,
                      completion: @escaping () -> Void) {
        CallService.shared.makeCall()
    }
    
    // MARK: - Network
    
    
    // Send token method
    private func sendToken() {
        let parameters: [String: Any] = [
            "app_id" : APIKeys.pushKey,
            "device_type": 0,
            "identifier": token,
//            "test_type": 1
        ]
        let url = URL(string: "https://onesignal.com/api/v1/players")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        do {
            request.httpBody = try JSONSerialization.data(
                withJSONObject: parameters,
                options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        
        request.addValue(
            "application/json",
            forHTTPHeaderField: "Content-Type")
        request.addValue(
            "application/json",
            forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(
            with: request as URLRequest,
            completionHandler: { data, response, error in
                
                guard error == nil else {
                    return
                }
                
                guard let data = data else {
                    return
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(
                        with: data,
                        options: .mutableContainers) as? [String: Any] {
                        if let id = json["id"] as? String {
                            self.deviceId = id
                        }
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
        })
        task.resume()
    }
    
    func postNotification(for date: Date,
                          success: @escaping CompletionBlock,
                          failure: @escaping FailureBlock) {
        guard let r = Reachability(),
            r.connection != .none else {
                failure("")
                return
        }
        let params: [String: Any] = [
            "include_player_ids": [deviceId],
            "app_id": APIKeys.pushKey,
            "content_available": true,
            "send_after": TimerFormatter.requestTime(for: date)]
        OneSignal.postNotification(
            params,
            onSuccess:{result in
                success()
        },
            onFailure: {error in
                failure(error?.localizedDescription)
        })
    }
}
