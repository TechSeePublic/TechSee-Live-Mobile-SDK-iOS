//
//  Global.swift
//  TSSDKSampleApp
//
//  Created by Hanoch Mordkovich on 17/12/2023.
//

import Foundation

import Foundation

struct Global {
    static let suitName = ""
    enum UserDefaultsKey: String {
        case isBroadcasting
        case sessionLink
        case cursorCoords
    }
    
    private init() {}
}


extension UserDefaults {
    @objc dynamic var isBroadcasting: Bool {
        get {
            bool(forKey: Global.UserDefaultsKey.isBroadcasting.rawValue)
        }
        set {
            set(newValue, forKey: Global.UserDefaultsKey.isBroadcasting.rawValue)
        }
    }
    
    @objc dynamic var cursorCoords: CGRect {
        get {
            guard let coordsString = string(forKey: Global.UserDefaultsKey.cursorCoords.rawValue) else {
                return .zero
            }
            return NSCoder.cgRect(for: coordsString)
        }
        set {
            set(NSCoder.string(for: newValue), forKey: Global.UserDefaultsKey.cursorCoords.rawValue)
        }
    }
}
