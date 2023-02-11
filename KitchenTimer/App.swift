//
//  KitchenTimerApp.swift
//  KitchenTimer
//
//  Created by Theo on 4/5/22.
//

import SwiftUI
import AudioToolbox
import AVFoundation

@main
struct KitchenTimerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView().onAppear {
                KitchenTimerApp.setupTimerResponse()
            }
        }
    }

    static func setupTimerResponse() {
        for i in 0..<timers.count {
            dispatchSingleTimer(timers[i])
        }
    }
    
    static func dispatchSingleTimer(_ timer: KTimer) {
        DispatchQueue.main.asyncAfter(deadline: .now() + timer.timeRemaining) {
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) {}
        }
    }
}
