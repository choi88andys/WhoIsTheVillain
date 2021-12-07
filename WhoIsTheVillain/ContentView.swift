//
//  ContentView.swift
//  WhoIsTheVillain
//
//  Created by MacAndys on 2021/12/05.
//


import SwiftUI

struct ContentView: View {
    private let startImageHeight: CGFloat = SettingConstants.isPhone ? 70 : 105
    private let startImageWidth: CGFloat = SettingConstants.isPhone ? 220 : 330
    
    @State var isClockwise: Bool = true
    @State var timeMin: Int = 0
    @State var timeSec: Int = 0
    @State var numUsers: Int = 2
    @State var nameArray: [String] = []
    @StateObject var sharedTimer: SharedTimer = SharedTimer()
    
    @State var isActivePlayingView: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    
    var body: some View {
        return NavigationView {
            ZStack {
                VStack {
                    AppLabel()
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                HStack {
                                    Image(systemName: "doc")
                                        .onTapGesture {
                                            isClockwise = true
                                            timeSec = 0
                                            timeMin = 0
                                            numUsers = 2
                                            for i in 0..<nameArray.count {
                                                nameArray[i] = "Player\(i+1)"
                                            }
                                        }
                                }
                            }
                            
                            ToolbarItem(placement: .navigationBarTrailing) {
                                HStack {
                                    NavigationLink(destination: ScoreboardView(isActivePlayingView: $isActivePlayingView)) {
                                        Image(systemName: "chart.bar.xaxis")
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    }
                                    NavigationLink(destination: HelpView()) {
                                        Image(systemName: "questionmark")
                                            .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
                                    }
                                }
                            }
                        }
                        .font(.system(size: SettingConstants.fontSize))
                    Spacer()
                                                            
                        
                    ScrollView {
                        VStack(spacing: SettingConstants.fontSize*0.4) {
                            HStack(spacing: 0) {
                                Spacer()
                                Text("Personal time limit :")
                                    .lineLimit(1)
                                    .padding(.trailing, SettingConstants.fontSize*0.6)
                                
                                Menu {
                                    Picker("", selection: $timeMin) {
                                        ForEach(0..<60) { i in
                                            Text("\(i) min")
                                        }
                                    }
                                    .labelsHidden()
                                    .pickerStyle(.inline)
                                } label: {
                                    Text("\(timeMin)min")
                                        .fixedSize()
                                        .padding(.trailing, SettingConstants.fontSize*0.3)
                                }
                                
                                Menu {
                                    Picker("", selection: $timeSec) {
                                        ForEach(0..<60) { j in
                                            Text("\(j) sec")
                                        }
                                    }
                                    .labelsHidden()
                                    .pickerStyle(.inline)
                                } label: {
                                    Text("\(timeSec)sec")
                                        .fixedSize()
                                }
                                
                                Spacer()
                            }
                            .font(.system(size: SettingConstants.fontSize))
                            
                            
                            
                            HStack(spacing: 0) {
                                Spacer()
                                
                                Text("Number of users :")
                                    .lineLimit(1)
                                    .padding(.trailing, SettingConstants.fontSize*0.6)
                                
                                Menu {
                                    Picker("", selection: $numUsers) {
                                        ForEach(SettingConstants.minUsers..<SettingConstants.maxUsers+1,
                                                id: \.self) { i in
                                            Text("\(i) users")
                                        }
                                    }
                                    .labelsHidden()
                                    .pickerStyle(InlinePickerStyle())
                                } label: {
                                    Text("\(numUsers) users")
                                        .fixedSize()
                                }
                                
                                Spacer()
                            }
                            .font(.system(size: SettingConstants.fontSize))
                            
                            HStack(spacing: 0) {
                                Spacer()
                                
                                HStack {
                                    if isClockwise {
                                        Text("Rotate clockwise")
                                            .truncationMode(.head)
                                    } else {
                                        Text("Rotate counter-clockwise")
                                            .truncationMode(.head)
                                    }
                                }
                                
                                Toggle("", isOn: $isClockwise)
                                    .frame(width: UIScreen.main.bounds.size.width*0.001)
                                    .padding(.trailing, UIScreen.main.bounds.size.width*0.27)
                                    .padding(.leading, UIScreen.main.bounds.size.width*0.08)
                            }
                            .font(.system(size: SettingConstants.fontSize))
                            
                        }
                        
                        
                        
                        InputNameView(numUsers: $numUsers, nameArray: $nameArray)
                    }
                    
                    
                    Spacer()
                    Divider()
                    NavigationLink(destination: PlayingView(
                        isActivePlayingView: $isActivePlayingView).onAppear(){
                            sharedTimer.reset()
                            
                            
                            sharedTimer.isClockwise = isClockwise
                            let time = Double(timeMin*60 + timeSec) > SettingConstants.countdownSec ?
                            Double(timeMin*60 + timeSec) : SettingConstants.countdownSec
                            
                            for i in 0..<numUsers {
                                let name = nameArray[i]
                                sharedTimer.users.append(PersonalData(
                                    timeCount: time,
                                    personName: name)
                                )
                            }
                            
                            sharedTimer.users[0].isTurnOn = true
                            
                            UIApplication.shared.isIdleTimerDisabled = true
                        }.onDisappear() {
                            UIApplication.shared.isIdleTimerDisabled = false
                        }, isActive: $isActivePlayingView)
                    {
                        Ellipse()
                            .fill(Color.green)
                            .overlay(Text("START")
                                        .font(.system(size: SettingConstants.overlayTextSize, weight: Font.Weight.heavy, design: Font.Design.rounded))
                                        .foregroundColor(Color.black)
                                        .multilineTextAlignment(.center))
                            .frame(width:startImageWidth, height: startImageHeight)
                    }
                    .isDetailLink(false)
                    .padding()
                }
                .onAppear() {
                    if nameArray.count == 0 {
                        for i in 0..<SettingConstants.maxUsers {
                            nameArray.append("Player\(i+1)")
                        }
                    }
                } // end V
                
            } // end Z
            .contentShape(Rectangle())
            .onTapGesture {
                hideKeyboard()
            }
            
        } // end Navi
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .environmentObject(sharedTimer)
    }
}


struct InputNameView: View {
    @Binding var numUsers: Int
    @Binding var nameArray: [String]
    
    var body: some View {
        VStack {
            if nameArray.count > 0 {
                ForEach(0..<numUsers, id: \.self) { index in
                    HStack(spacing: 5){
                        Spacer()
                        Image(systemName: "person.crop.square")
                            .font(.system(size: SettingConstants.fontSize*1.5))
                        Spacer()
                        
                        TextField("", text: $nameArray[index])
                            .font(.system(size: SettingConstants.fontSize*1.3))
                            .multilineTextAlignment(.leading)
                            .disableAutocorrection(true)
                    }
                    .padding(.bottom, SettingConstants.fontSize*0.4)
                }
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("8")
            
            ContentView()
                .previewDevice(PreviewDevice(rawValue: "iPad (9th generation)"))
                .previewDisplayName("pad 9 gen")
            
        }
    }
}
