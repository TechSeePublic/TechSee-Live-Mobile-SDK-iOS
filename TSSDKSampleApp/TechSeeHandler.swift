//
//  TechSeeHandler.swift
//  TechSee Instant Mirroring
//
//  Created by Shlomi Sharon on 08/12/2019.
//  Copyright © 2019 TechSee. All rights reserved.
//

import Foundation
import TechSeeLiveFramework


let techSeeApiKey = "sdkDemo"
let techSeeApiSecret = "123456Ts"


class TechSeeHandler: NSObject, AuthenticationProtocol, JoinSessionProtocol, ScreenTOS, Cursor, TranslationStatusProtocol, SessionEventsDelegate {
    
    func tosApproval(_ isApprove: Bool) {
      print("tosApproval")
    }
    
    func move(_ frame: CGRect) {
        print("move frame \(frame)")
    }
    
    func hide() {
        print("hide")
    }
    
    
    // MARK: Properties
    
    private var techseeURL: URL
    private(set) var currentSessionMode: TechSeeLiveFramework.SessionMode = .unknown
    private var connectCompletion: ((Bool) -> Void)?
    
    // MARK: Initializer
    
    init(smsURL: URL, connectCompletion: ((Bool) -> Void)? = nil) {
        techseeURL = smsURL
        super.init()
        TechSee.shared().delegate = self
    }
    
    
    // MARK: privates
    
    private func broadcastNotification(name: CFString) {
        let notificationName = CFNotificationName(name)
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        
        CFNotificationCenterPostNotification(notificationCenter, notificationName, nil, nil, false)
    }
    
    private func postCursorCoords(coords: CGRect) {
        UserDefaults(suiteName: "group.com.thechsee.SDK-sample-app")?.cursorCoords = coords
    }
    
    
    // MARK: TechSee API methods
    
    func connect() {
        UserDefaults.standard.set(techseeURL.absoluteString, forKey: "sessionLink")
        let env = "staging"
        TechSee.shared().configure(apiKey: techSeeApiKey, apiSecret: techSeeApiSecret, environment: env)
    }
    
    func joinSession() {
        TechSee.shared().joinSession(techseeURL)
    }
    
    func openChat() {
        TechSee.shared().openChat()
    }
    
    
    // MARK:- TechSee Protocols
    
    func authenticateSuccessful() {
        TechSee.shared().delegateJoinSession = self
        TechSee.shared().screenTOS = self
        TechSee.shared().cursor = self
        TechSee.shared().sessionEventsDelegate = self
        joinSession()
        TechSee.shared().translationStatusProtocol = self
    }
    
    func authenticateFailure(_ error: String?, internalError: String?) {
       print("authenticateFailure")
    }
    
    func joinSessionSuccessful(_ sdkVersionStatus: String?, newSDKVersion: String?, sessionInitialMode mode: TechSeeLiveFramework.SessionMode) {
        connectCompletion?(true)
    }
    
    func joinSessionFailure(_ error: String, sdkVersionStatus: String?, newSDKVersion: String?) {
        print("joinSessionFailure")
    }
    
    func sessionModeChanged(_ sessionMode: TechSeeLiveFramework.SessionMode) {
        let prevMode = currentSessionMode
        currentSessionMode = sessionMode
    }
    
    // MARK:- TechSee broadcast extension
    
    func broadcastStarted(sampleHandler: RPBroadcastSampleHandler) {
        TechSee.shared().broadcastStarted(sampleHandler)
    }
    
    func broadcastPaused() {
        TechSee.shared().broadcastPaused()
    }
    
    func broadcastResumed() {
        TechSee.shared().broadcastResumed()
    }
    
    func broadcastFinished() {
        TechSee.shared().broadcastFinished()
    }
    
    func processSampleBuffer(sampleBuffer: CMSampleBuffer, type: RPSampleBufferType) {
        TechSee.shared().processSampleBuffer(sampleBuffer, with: type)
    }
}


