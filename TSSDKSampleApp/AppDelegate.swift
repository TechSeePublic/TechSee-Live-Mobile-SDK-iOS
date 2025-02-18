//
//  AppDelegate.swift
//  SDK_Demo_webrtc
//
//  Created by Hanoch Mordkovich on 10/07/2023.
//

import UIKit
import TechSeeLiveFramework


@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var techseeToken = ""
    let kApiKey = ""
    let kApiSecret = ""
    let kEnv = ""
    var smsUrl: URL?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard let url = userActivity.webpageURL else { return false }
        self.smsUrl = url
        let groupDefaults = UserDefaults(suiteName: "group.com.thechsee.SDK-sample-app")
        groupDefaults?.set(url.absoluteString, forKey: Global.UserDefaultsKey.sessionLink.rawValue)
        TechSee.shared().delegate = self
        TechSee.shared().configure(apiKey: kApiKey, apiSecret: kApiSecret, environment: kEnv)
        return true
    }
}


extension AppDelegate: AuthenticationProtocol
{
    
    public func authenticateSuccessful() {
        
        guard let url = self.smsUrl else { return }
        
        UserDefaults(suiteName: "com.thechsee.SDK-sample-app")?.set(url, forKey: "sessionLink")
        
        TechSee.shared().delegateJoinSession = self
        TechSee.shared().joinSession(url)
    }
    
    public func authenticateFailure(_ error: String?, internalError: String?) {
        print("Authenticate Failure")
    }
    
}

extension AppDelegate: JoinSessionProtocol {
    
    public func joinSessionSuccessful(_ sdkVersionStatus: String?, newSDKVersion: String?, sessionInitialMode mode: SessionMode) {
        print("Join Session Successful with mode \(mode.rawValue)")
        let vc = self.window?.rootViewController?.children.first as? MainViewController
        vc?.setContainer()
        
    }
    
    public func joinSessionFailure(_ error: String, sdkVersionStatus: String?, newSDKVersion: String?) {
        print("Join Session Failure")
    }
}

