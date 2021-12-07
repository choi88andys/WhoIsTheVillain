

import SwiftUI

private let horizontalSpacing: CGFloat = SettingConstants.isPhone ? 10 : 20
private let verticalSpacing: CGFloat = SettingConstants.isPhone ? 20 : 40


struct ItemView: View {
    let description: String
    let imageView: Image
    
    var body: some View {
        return HStack(spacing: horizontalSpacing){
            imageView.frame(width: UIScreen.main.bounds.size.width*0.15)
            Text(description)
            Spacer()
        }
    }
}

struct HelpView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    var body: some View {
        return VStack{
            AppLabel()
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        HStack {
                            Image(systemName: "arrowshape.turn.up.backward.fill")
                                .onTapGesture {
                                    presentationMode.wrappedValue.dismiss()
                                }
                        }
                    }
                }
                .font(.system(size: SettingConstants.fontSize))            
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: verticalSpacing) {
                    
                    ItemView(description: "Reset all values.", imageView: Image(systemName: "doc"))
                    ItemView(description: "Store current playing data.",
                             imageView: Image(systemName: "arrow.up.doc"))
                    ItemView(description: "Show scoreboard to check the past records.",
                             imageView: Image(systemName: "chart.bar.xaxis"))
                    ItemView(description: "The timeout counter.\n" +
                             "It will increase when you spend all your time or use the emergency button.\n" +
                             "This is very important because you can catch the villain with it.",
                             imageView: Image(systemName: "clock.badge.exclamationmark"))
                    
                    
                    HStack(spacing: horizontalSpacing){
                        VStack(spacing: 3) {
                            Image(systemName: "pause.circle").foregroundColor(Color.red)
                            Image(systemName: "play.circle").foregroundColor(Color.red)
                        }
                        .frame(width: UIScreen.main.bounds.size.width*0.15)
                        Text("Emergency button to pause the timer.\n" +
                             "You have to press it for \(String(format: "%01.1f", SettingConstants.pressDuration)) second(s).")
                        Spacer()
                    }
                    
                    
                    HStack(spacing: horizontalSpacing){
                        EndTurn()
                            .fill(Color.yellow)
                            .overlay(Text("END")
                                        .font(.system(size: SettingConstants.overlayTextSize*0.25, weight: Font.Weight.heavy, design: Font.Design.rounded))
                                        .foregroundColor(Color.black)
                                        .multilineTextAlignment(.center))
                            .frame(width: UIScreen.main.bounds.size.width*0.15,
                                   height: UIScreen.main.bounds.size.width*0.07)                            
                        Text("End your turn to stop the timer and start next person's timer.\n" +
                             "If your time is less than countdown time, it will set to \(String(format: "%02.0f", SettingConstants.countdownSec)) second(s)." )
                        Spacer()
                    }
                    
                }
            } // end scroll
            .font(.system(size: SettingConstants.fontSize))
            .padding(.bottom, 20)
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct HelpView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HelpView()
                .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
                .previewDisplayName("8")
            
            HelpView()
                .previewDevice(PreviewDevice(rawValue: "iPad (9th generation)"))
                .previewDisplayName("pad 9 gen")
            
        }
    }
}
