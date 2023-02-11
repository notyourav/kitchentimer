//
//  ContentView.swift
//  KitchenTimer
//
//  Created by Theo on 4/5/22.
//

import SwiftUI

struct ContentView : View {
//    @State private var timers: Array<KTimer> = Array<KTimer>()
    @State private var showCreateView = false
    
    var body: some View {
        ZStack(alignment: .top) {
            TimelineView(.periodic(from: .now, by: 0.035)) { timeline in
                KTimerStack(now: timeline.date)
            }.popover(isPresented: $showCreateView, content: {KCreateView()})
            
            HStack {
                Button(action: {}) {
                    Image(systemName: "slider.horizontal.3")
                }.padding().font(.title2)
                Spacer()
//                Button(action: {}) {
//                    Image(systemName: "star.fill")
//                }.padding().font(.title2)
                Button(action: {showCreateView = true}) {
                    Image(systemName: "plus")
                }.padding().font(.title2)
            }.frame(maxWidth: .infinity, alignment: .trailing).background(.ultraThinMaterial)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Previews_ContentView_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
