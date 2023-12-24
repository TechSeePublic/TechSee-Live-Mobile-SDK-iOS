//
//  MainViewController.swift
//  TSSDKSampleApp
//
//  Created by Hanoch Mordkovich on 17/12/2023.
//

import UIKit
import ReplayKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var broadcastContainer: UIView!
    @IBOutlet weak var broadcastButtonContainer: UIView!
    
    private var broadcastPicker: RPSystemBroadcastPickerView!
    private var transparentBtn: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.broadcastContainer.isHidden = true
        setBroadcastButton()
        
    }
    
    func setContainer() {
        self.broadcastContainer.isHidden = false
    }
    
    private func setBroadcastButton() {
        broadcastContainer.layer.borderWidth = 1
        broadcastContainer.layer.borderColor = UIColor(red: 159/255, green: 173/255, blue: 181/255, alpha: 1).cgColor
        broadcastContainer.layer.cornerRadius = 10
        let broadcastPicker = RPSystemBroadcastPickerView(frame: broadcastButtonContainer.bounds)
//        broadcastPicker.preferredExtension = "com.thechsee.SDK-sample-app.BroadcastExtension"
        broadcastPicker.showsMicrophoneButton = false
        broadcastButtonContainer.addSubview(broadcastPicker)
        self.broadcastPicker = broadcastPicker
        setTransparentButton()
        broadcastPicker.addSubview(transparentBtn)
    }
    
    private func setTransparentButton() {
        transparentBtn = UIButton(frame: broadcastPicker.frame)
        transparentBtn.addTarget(self, action: #selector(transparentButtonPressed), for: .touchUpInside)
    }
    
    @objc private func transparentButtonPressed() {
        sendActionsToBroadcastButton()
    }
    
    private func sendActionsToBroadcastButton() {
        for subview in broadcastPicker.subviews {
            if let button = subview as? UIButton {
                button.sendActions(for: .allTouchEvents)
                break
            }
        }
    }
    
}

