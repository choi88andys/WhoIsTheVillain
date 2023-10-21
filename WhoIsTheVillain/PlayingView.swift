
import SwiftUI


struct PlayingView: View {
  private let endTurnWidth: CGFloat = Values.isPhone ? 280 : 420
  private let endTurnHeight: CGFloat = Values.isPhone ? 80 : 120
  let dismiss: () -> ()
  let scoreBoardButtonTapped: (Bool) -> ()
  
  @EnvironmentObject var sharedTimer: SharedTimer
  @Environment(\.colorScheme) var colorScheme
  @State private var shouldDismissed = false
  
  struct BackWithAlertView: View {
    @Binding var shouldDismissed: Bool
    @State private var isShowingAlert: Bool = false
    
    var body: some View {
      Image(systemName: "arrowshape.turn.up.backward.fill")
        .onTapGesture {
          isShowingAlert = true
        }
        .alert(isPresented: $isShowingAlert) {
          Alert(
            title: Text(Strings.alertTitle),
            primaryButton: .destructive(Text(Strings.discard), action: { shouldDismissed = true }),
            secondaryButton: .cancel()
          )
        }
    }
  }
  
  var body: some View {
    return VStack {
      BannerView()
        .onChange(of: sharedTimer.urgentCountdownToggle, perform: { _ in
          let generator = UIImpactFeedbackGenerator(style: .light)
          generator.impactOccurred()
        })
        .onChange(of: shouldDismissed, perform: { shouldDismissed in
          if shouldDismissed { dismiss() }
        })
        .toolbar {
          ToolbarItem(placement: .navigationBarLeading) {
            HStack {
              BackWithAlertView(shouldDismissed: $shouldDismissed)
            }
          }
          
          ToolbarItem(placement: .navigationBarTrailing) {
            HStack {
              Button {
                var dateArray = UserDefaults.standard
                  .object(forKey:"dateArray") as? [Date] ?? [Date]()
                dateArray.append(Date())
                UserDefaults.standard.set(dateArray, forKey: "dateArray")
                
                var names: [String] = []
                var times: [Double] = []
                var counters: [Int] = []
                for i in 0..<sharedTimer.users.count {
                  names.append(sharedTimer.users[i].personName)
                  times.append(sharedTimer.users[i].timeCount)
                  counters.append(sharedTimer.users[i].timeoutCounter)
                }
                
                var namesArray = UserDefaults.standard
                  .object(forKey:"namesArray") as? [[String]] ?? [[String]]()
                var timesArray = UserDefaults.standard
                  .object(forKey:"timesArray") as? [[Double]] ?? [[Double]]()
                var countersArray = UserDefaults.standard
                  .object(forKey:"countersArray") as? [[Int]] ?? [[Int]]()
                namesArray.append(names)
                timesArray.append(times)
                countersArray.append(counters)
                
                UserDefaults.standard.set(namesArray, forKey: "namesArray")
                UserDefaults.standard.set(timesArray, forKey: "timesArray")
                UserDefaults.standard.set(countersArray, forKey: "countersArray")
                
                scoreBoardButtonTapped(true)
              } label: {
                Image(systemName: "arrow.up.doc")
                  .foregroundColor(colorScheme == .dark ? Color.white : Color.black)
              }
            }
          }
        }
        .font(.system(size: Values.fontSize))
      Spacer()
      
      HStack {
        if sharedTimer.isPaused {
          Image(systemName: "play.circle")
            .foregroundColor(.red)
            .onTapGesture {
              if !sharedTimer.isPaused {
                sharedTimer.users[sharedTimer.turn].timeoutCounter += 1
              }
              sharedTimer.isPaused.toggle()
            }
        }
        else {
          if sharedTimer.users[sharedTimer.turn].timeCount > 0 {
            Image(systemName: "pause.circle")
              .foregroundColor(.red)
              .onTapGesture {
                if !sharedTimer.isPaused {
                  sharedTimer.users[sharedTimer.turn].timeoutCounter += 1
                }
                sharedTimer.isPaused.toggle()
              }
          }
          else {
            Image(systemName: "pause.circle")
              .hidden()
          }
        }
      }
      .font(.system(size: Values.fontSize*4.2))
      .padding(.bottom, Values.fontSize*0.2)
      
      VStack{
        ForEach(sharedTimer.users){item in
          TableView(item: item)
        }
      }
      .overlay(
        RoundedRectangle(cornerRadius: 15)
          .stroke(Color.gray, lineWidth: 1.5))
      .padding(.horizontal, Values.fontSize*0.2)
      
      
      
      Spacer()
      Divider()
      VStack {
        if !sharedTimer.isPaused {
          Button {
            sharedTimer.users[sharedTimer.turn].isTurnOn = false
            
            // reset countdown
            if sharedTimer.users[sharedTimer.turn].timeCount < sharedTimer.countdownSec {
              sharedTimer.users[sharedTimer.turn].timeCount = sharedTimer.countdownSec
            }
            
            // next turn
            sharedTimer.turn += 1
            if sharedTimer.turn == sharedTimer.users.count {
              sharedTimer.turn = 0
            }
            sharedTimer.users[sharedTimer.turn].isTurnOn = true
          } label: {
            
            if sharedTimer.isClockwise {
              EndTurnClockwise()
                .fill(Color.yellow)
                .overlay(Text(Strings.endTurn)
                  .font(.system(size: Values.overlayTextSize,
                                weight: Font.Weight.heavy, design: Font.Design.rounded))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center))
            } else {
              EndTurn()
                .fill(Color.yellow)
                .overlay(Text(Strings.endTurn)
                  .font(.system(size: Values.overlayTextSize,
                                weight: Font.Weight.heavy, design: Font.Design.rounded))
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center))
            }
          }
        }
      }
      .frame(width: endTurnWidth, height: endTurnHeight)
      .padding()
      
      Spacer()
    } // end VStack
    .navigationBarBackButtonHidden(true)
    .onAppear { UIApplication.shared.isIdleTimerDisabled = true }
    .onDisappear { UIApplication.shared.isIdleTimerDisabled = false }
  }
}


