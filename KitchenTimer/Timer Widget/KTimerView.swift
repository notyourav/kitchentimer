//
//  TimerView.swift
//  KitchenTimer
//
//  Created by Theo on 4/6/22.
//

import SwiftUI

struct KTimerView : View {
    @State var timer: KTimer
    var dateFormatter = DateFormatter()
    
    @State var nameChangeEnabled = false
    @State var nameChangeResult = "Timer Name"
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                // Header
                HStack {
                    TextField(timer.name, text: $nameChangeResult).padding(10).submitLabel(.done).onSubmit {
                        if (nameChangeResult != "") {
                            timer.name = nameChangeResult
                        } else {
                            nameChangeResult = timer.name
                        }
                    }.onAppear {
                        nameChangeResult = timer.name
                    }
                    Spacer()
                    Button(action: {
                        let impactMed = UIImpactFeedbackGenerator(style: .medium)
                        impactMed.impactOccurred()

                        if let i = timers.firstIndex(of: timer) {
                            timers.remove(at: i)
                        }
                    }) {
                        Image(systemName: "xmark").padding()
                    }
                }.frame(maxWidth:.infinity, alignment: .leading).background(.regularMaterial)

                // Content
                HStack {
                    HStack {
                        KTimerNumber(isFinished: timer.finished, seconds: timer.elapsedTime, finalColor: Color(UIColor.systemPink))
                        Text("/").foregroundStyle(.quaternary)
                        KTimerNumber(seconds: timer.length, initialColor: Color(UIColor.secondaryLabel))
                    }.frame(width: 300, alignment: .leading)
                }
            }
        }.background(.ultraThinMaterial).cornerRadius(10)
    }
}
