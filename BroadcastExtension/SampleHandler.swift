//
//  SampleHandler.swift
//  BroadcastExtension
//
//  Created by Hanoch Mordkovich on 28/11/2023.
//

import ReplayKit
import TechSeeLiveFramework


class SampleHandler: RPBroadcastSampleHandler{
    
    var techseeHandler: TechSeeHandler?
    
    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        postIsBroadcasting(true)
        let groupDefaults = UserDefaults(suiteName: "group.com.thechsee.SDK-sample-app")
        guard let smsURL = groupDefaults?.value(forKey: Global.UserDefaultsKey.sessionLink.rawValue) as? String,
              let url = URL(string: smsURL) else { return }
        techseeHandler = TechSeeHandler(smsURL: url) { [weak self] result in
            guard let self = self else { return }
            let defaults = UserDefaults.standard
            defaults.set(true, forKey: "TOS")
            self.techseeHandler?.broadcastStarted(sampleHandler: self)
        }
        techseeHandler?.connect()
    }
    
    override func broadcastPaused() {
        self.techseeHandler?.broadcastPaused()
    }
    
    override func broadcastResumed() {
        self.techseeHandler?.broadcastResumed()
    }
    
    override func broadcastFinished() {
        postIsBroadcasting(false)
        self.techseeHandler?.broadcastFinished()
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        switch sampleBufferType {
        case RPSampleBufferType.video:
            self.techseeHandler?.processSampleBuffer(sampleBuffer: sampleBuffer, type: sampleBufferType)
            break
        case RPSampleBufferType.audioApp:
            // Handle audio sample buffer for app audio
            break
        case RPSampleBufferType.audioMic:
            // Handle audio sample buffer for mic audio
            break
        @unknown default:
            // Handle other sample buffer types
            fatalError("Unknown type of sample buffer")
        }
    }
    
    override func finishBroadcastWithError(_ error: Error) {
        super.finishBroadcastWithError(error)
        postIsBroadcasting(false)
    }
    
    private func postIsBroadcasting(_ isBroadcasting: Bool) {
        UserDefaults(suiteName: "group.com.thechsee.SDK-sample-app")?.isBroadcasting = isBroadcasting
    }

}
