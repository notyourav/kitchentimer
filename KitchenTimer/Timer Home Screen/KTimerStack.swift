//
//  KTimerStack.swift
//  KitchenTimer
//
//  Created by Theo on 4/7/22.
//

import SwiftUI

struct KTimerStack : View {
    var now: Date

    var body : some View {
        ScrollView {
            Spacer().padding(.bottom, 50)
            VStack {
                ForEach(timers) { timer in
                    KTimerView(timer: timer)
                }
            }
        }

        if timers.count == 0 {
            Text("No timers active.").foregroundColor(Color(UIColor.systemFill))
        }
    }
}
