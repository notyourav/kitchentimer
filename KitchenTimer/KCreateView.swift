//
//  KCreateView.swift
//  KitchenTimer
//
//  Created by Theo on 4/6/22.
//

import SwiftUI

// This is a fix for the broken Picker touch area in iOS 15.1
extension UIPickerView {   open override var intrinsicContentSize: CGSize {     return CGSize(width: UIView.noIntrinsicMetric, height: super.intrinsicContentSize.height)   } }

extension View {
    @ViewBuilder func `if`<TrueContent: View>(
       _ condition: Bool,
       then trueContent: (Self) -> TrueContent
   ) -> some View {
       if condition {
           trueContent(self)
       } else {
           self
       }
   }

   @ViewBuilder func `if`<TrueContent: View, FalseContent: View>(
       _ condition: Bool,
       then trueContent: (Self) -> TrueContent,
       else falseContent: (Self) -> FalseContent
   ) -> some View {
       if condition {
           trueContent(self)
       } else {
           falseContent(self)
       }
   }
}

// Extension for supporting "clear" button on text field
extension TextField where Label == Text {
    init<S>(_ title: S, text: Binding<String>, clearButtonMode: UITextField.ViewMode) where S : StringProtocol {
        UITextField.appearance().clearButtonMode = .whileEditing
        self.init(title, text: text)
        UITextField.appearance().clearButtonMode = .never
    }
}

let secondsInMinute = 60
let secondsInHour = 3600
let secondsInDay = 86400

func secondsToDHMS(seconds: Int) -> (Int, Int, Int, Int) {
    return (seconds / secondsInDay,
            (seconds % secondsInDay) / secondsInHour,
            (seconds % secondsInHour) / secondsInMinute,
            seconds % secondsInMinute)
}

func DHMSToSeconds(days: Int, hours: Int, minutes: Int, seconds: Int) -> Int {
    return days * secondsInDay + hours * secondsInHour + minutes * secondsInMinute + seconds
}

struct PickerView: View {
    @Binding public var seconds: Int
    
    var extended = false
    var numPickers: Int { get { return extended ? 4 : 2 } }

    var daysArray = [Int](0...365)
    var hoursArray = [Int](0...23)
    var minutesArray = [Int](0...59)
    var secondsArray = [Int](0...59)
    
    @State private var daySelection = 0
    @State private var hourSelection = 0
    @State private var minuteSelection = 1
    @State private var secondSelection = 0
    
    private let frameHeight: CGFloat = 160

    var totalInSeconds: Int { get { return DHMSToSeconds(days: daySelection, hours: hourSelection, minutes: minuteSelection, seconds: secondSelection) } }
    
    var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                if (extended) {
                    Picker(selection: self.$daySelection, label: Text("")) {
                        ForEach(0 ..< self.daysArray.count, id:\.self) { index in
                            Text("\(self.daysArray[index]) d").tag(index)
                        }
                    }
                    .onChange(of: self.daySelection) { newValue in
                        seconds = totalInSeconds
                    }
                    .labelsHidden()
                    .frame(width: geometry.size.width/CGFloat(numPickers), height: frameHeight, alignment: .center)
                    .clipped()
    //                .contentShape(Rectangle())
                    .font(.title3)
                    .pickerStyle(.wheel)
                    .compositingGroup()

                    Picker(selection: self.$hourSelection, label: Text("")) {
                        ForEach(0 ..< self.hoursArray.count, id:\.self) { index in
                            Text("\(self.hoursArray[index]) h").tag(index)
                        }
                    }
                    .onChange(of: self.hourSelection) { newValue in
                        seconds = totalInSeconds
                    }
                    .labelsHidden()
                    .frame(width: geometry.size.width/CGFloat(numPickers), height: frameHeight, alignment: .center)
                    .clipped()
    //                .contentShape(Rectangle())
                    .font(.title3)
                    .pickerStyle(.wheel)
                    .compositingGroup()
                }
                
                Picker(selection: self.$minuteSelection, label: Text("")) {
                    ForEach(0 ..< self.minutesArray.count, id:\.self) { index in
                        Text("\(self.minutesArray[index]) m").tag(index)
                    }
                }
                .onChange(of: self.minuteSelection) { newValue in
                    seconds = totalInSeconds
                }
                .labelsHidden()
                .frame(width: geometry.size.width/CGFloat(numPickers), height: frameHeight, alignment: .center)
                .clipped()
//                .contentShape(Rectangle())
                .font(.title3)
                .pickerStyle(.wheel)
                .compositingGroup()
                
                Picker(selection: self.$secondSelection, label: Text("")) {
                    ForEach(0 ..< self.secondsArray.count, id:\.self) { index in
                        Text("\(self.secondsArray[index]) s").tag(index)
                    }
                }
                .onChange(of: self.secondSelection) { newValue in
                    seconds = totalInSeconds
                }
                .labelsHidden()
                .frame(width: geometry.size.width/CGFloat(numPickers), height: frameHeight, alignment: .center)
                .clipped()
//                .contentShape(Rectangle())
                .font(.title3)
                .pickerStyle(.wheel)
                .compositingGroup()
            }
        }
        .onAppear(perform: {
            // set initial picker values
            (daySelection, hourSelection, minuteSelection, secondSelection) = secondsToDHMS(seconds: seconds)
        })
    }
}

struct KCreateView : View {
    // User supplied parameters
    @State var secs: Int = 0
    @State var name: String = "New Timer"
    @State var isExtended: Bool = false

    // Internal to the view
    enum FocusField: Hashable {
      case nameField
    }
    
    @FocusState private var focusedField: FocusField?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        HStack {
            Button(action: { dismiss() }) { Text("Cancel") }.padding()
            Spacer()
            Button(action: {
                let timer = KTimer(secs, index: timers.count, name: name)
                timers.append(timer)
                print("Timer with length \(secs)")
                KitchenTimerApp.dispatchSingleTimer(timer)
                dismiss()
            }) { Text("OK") }.padding().disabled(secs == 0)
        }
        
        Form {
            TextField("Name", text: $name, clearButtonMode: .whileEditing).focused($focusedField, equals: .nameField).onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                    // become focused on view appear
                    self.focusedField = .nameField
                }
            }
            HStack {
                Toggle(isOn: $isExtended) {
                    Text("Extended")
                }
            }
        }
        
        PickerView(seconds: $secs, extended: isExtended)
    }
}
