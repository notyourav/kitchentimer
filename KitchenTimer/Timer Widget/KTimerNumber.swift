//
//  KTimerNumberView.swift
//  KitchenTimer
//
//  Created by Theo on 4/8/22.
//

import SwiftUI

// Timer number that can display
struct KTimerNumber : View {
    var isFinished: Bool = false
    var seconds: Double
    var initialColor: Color = Color(UIColor.label)
    var finalColor: Color = Color(UIColor.secondaryLabel)

    @State var currentColor: Color = Color.white

    var body: some View {
        let timeString = String(format:"%.0fs", seconds)

        Text(timeString).font(.title).padding().frame(maxWidth:150, alignment: .leading).foregroundColor(.white)
            .colorMultiply(currentColor)
            .onChange(of: isFinished) { _ in
                withAnimation(.easeInOut(duration: 0.5)) {
                    self.currentColor = finalColor
                }
            }.onAppear {
                currentColor = initialColor
            }
    }
}
