//
//  ContentView.swift
//  WhoIsTheVillain
//
//  Created by MacAndys on 2021/12/05.
//


import SwiftUI

struct ContentView: View {
  private let startImageHeight: CGFloat = Values.isPhone ? 70 : 105
  private let startImageWidth: CGFloat = Values.isPhone ? 220 : 330
  
  @State var knowUserAge: Bool = UserDefaults.standard.object(forKey: "overSeventeenYearsOld") != nil
  @State var isClockwise: Bool = true
  @State var timeMin: Int = 0
  @State var timeSec: Int = 0
  @State var countdownSeconds: Int = 30
  @State var numUsers: Int = 2
  @State var nameArray: [String] = []
  @StateObject var sharedTimer: SharedTimer = SharedTimer()
  
  @State var isActivePlayingView: Bool = false
  @Environment(\.colorScheme) var colorScheme
  
  
  var body: some View {
    return NavigationView {
      ZStack {
        contentView
        if !knowUserAge { ageCheckingView }
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
  
  var ageCheckingView: some View {
    ZStack {
      Color.gray.opacity(0.7)
      
      VStack {
        Text(Strings.areYouOverSeventeen)
          .multilineTextAlignment(.center)
          .padding(.bottom, Values.fontSize*2)
        
        HStack(spacing: Values.fontSize*2) {
          Button {
            UserDefaults.standard.setValue(true, forKey: "overSeventeenYearsOld")
            knowUserAge = true
          } label: {
            Text(Strings.yes)
          }
          .buttonStyle(.borderedProminent)
          Button {
            UserDefaults.standard.setValue(false, forKey: "overSeventeenYearsOld")
            knowUserAge = true
          } label: {
            Text(Strings.no)
          }
          .buttonStyle(.bordered)
        }
      }
      .font(.system(size: Values.fontSize*0.9))
      .padding(.vertical, Values.fontSize*1.6)
      .padding(.horizontal, Values.fontSize*1.5)
      .background(
        RoundedRectangle(cornerRadius: Values.fontSize*0.6)
          .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
          .shadow(
            radius: Values.fontSize*0.2,
            x: Values.fontSize*0.1,
            y: Values.fontSize*0.1
          )
      )
      .padding(.horizontal, Values.fontSize*0.8)
    }
    .ignoresSafeArea()
  }
  
  var contentView: some View {
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
                  countdownSeconds = 30
                  numUsers = 2
                  for i in 0..<nameArray.count {
                    nameArray[i] = "\(Strings.player) \(i+1)"
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
        .font(.system(size: Values.fontSize))
      Spacer()
      
      ScrollView {
        VStack(spacing: Values.fontSize*0.4) {
          HStack(spacing: 0) {
            Spacer()
            Text(Strings.personalTimeLimit)
              .lineLimit(1)
              .padding(.trailing, Values.fontSize*0.6)
            
            Menu {
              Picker("", selection: $timeMin) {
                ForEach(0..<60) { i in
                  Text("\(i) \(Strings.minuteShort)")
                }
              }
              .labelsHidden()
              .pickerStyle(.inline)
            } label: {
              Text("\(timeMin)\(Strings.minuteShort)")
                .fixedSize()
                .padding(.trailing, Values.fontSize*0.3)
            }
            
            Menu {
              Picker("", selection: $timeSec) {
                ForEach(0..<60) { j in
                  Text("\(j) \(Strings.secondShort)")
                }
              }
              .labelsHidden()
              .pickerStyle(.inline)
            } label: {
              Text("\(timeSec)\(Strings.secondShort)")
                .fixedSize()
            }
            
            Spacer()
          }
          .font(.system(size: Values.fontSize))
          
          HStack(spacing: 0) {
            Text("Countdown Seconds:")
              .padding(.trailing, Values.fontSize*0.6)
            Menu {
              Picker("", selection: $countdownSeconds) {
                ForEach(10..<61, id: \.self) { j in
                  Text("\(j) \(Strings.secondShort)")
                }
              }
              .labelsHidden()
              .pickerStyle(.inline)
            } label: {
              Text("\(countdownSeconds)\(Strings.secondShort)")
                .fixedSize()
            }
          }
          .font(.system(size: Values.fontSize))

          HStack(spacing: 0) {
            Spacer()
            
            Text(Strings.userCount)
              .lineLimit(1)
              .padding(.trailing, Values.fontSize*0.6)
            
            Menu {
              Picker("", selection: $numUsers) {
                ForEach(Values.minUsers..<Values.maxUsers+1,
                        id: \.self) { i in
                  Text("\(i) \(Strings.users)")
                }
              }
              .labelsHidden()
              .pickerStyle(InlinePickerStyle())
            } label: {
              Text("\(numUsers) \(Strings.users)")
                .fixedSize()
            }
            
            Spacer()
          }
          .font(.system(size: Values.fontSize))
          
          HStack(spacing: 0) {
            Spacer()
            
            HStack {
              if isClockwise {
                Text(Strings.clockwise)
                  .truncationMode(.head)
              } else {
                Text(Strings.counterClockwise)
                  .truncationMode(.head)
              }
            }
            
            Toggle("", isOn: $isClockwise)
              .frame(width: UIScreen.main.bounds.size.width*0.001)
              .padding(.trailing, UIScreen.main.bounds.size.width*0.27)
              .padding(.leading, UIScreen.main.bounds.size.width*0.08)
          }
          .font(.system(size: Values.fontSize))
        }
        InputNameView(numUsers: $numUsers, nameArray: $nameArray)
      }
      
      Spacer()
      Divider()
      NavigationLink(destination: PlayingView(
        isActivePlayingView: $isActivePlayingView).onAppear(){
          Values.countdownSec = Double(countdownSeconds)
          sharedTimer.reset()
          
          sharedTimer.isClockwise = isClockwise
          let time = Double(timeMin*60 + timeSec) > Values.countdownSec ?
          Double(timeMin*60 + timeSec) : Values.countdownSec
          
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
          .overlay(Text(Strings.start)
            .font(.system(size: Values.overlayTextSize, weight: Font.Weight.heavy, design: Font.Design.rounded))
            .foregroundColor(Color.black)
            .multilineTextAlignment(.center)
          )
          .frame(width:startImageWidth, height: startImageHeight)
      }
      .isDetailLink(false)
      .padding()
    }
    .onAppear() {
      if nameArray.count == 0 {
        for i in 0..<Values.maxUsers {
          nameArray.append("\(Strings.player) \(i+1)")
        }
      }
    } // end V
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
            Image(systemName: "person.crop.square")
              .font(.system(size: Values.fontSize*1.5))
              .padding(.horizontal, Values.fontSize*0.7 )
            
            TextField("", text: $nameArray[index])
              .font(.system(size: Values.fontSize*1.3))
              .multilineTextAlignment(.leading)
              .disableAutocorrection(true)
          }
          .padding(Values.fontSize*0.5)
          .overlay(
            RoundedRectangle(cornerRadius: 15)
              .stroke(Color.gray, lineWidth: 1.5))
          .padding(.horizontal, Values.fontSize*0.3)
        }
      }
    }
  }
}
