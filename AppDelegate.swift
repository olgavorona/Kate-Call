//
//  AppDelegate.swift
//  TinderCall
//
//  Created by Olga Vorona on 19/09/2018.
//  Copyright © 2018 Olga Vorona. All rights reserved.
//

import UIKit
import Crashlytics


@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        PushService.shared.voipRegistration()
        AnalyticsService.shared.setup()

        return true
    }
}

