

import SwiftUI

private let horizontalSpacing: CGFloat = Values.isPhone ? 10 : 20
private let verticalSpacing: CGFloat = Values.isPhone ? 20 : 40


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
      BannerView()
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
        .font(.system(size: Values.fontSize))
      
      ScrollView(showsIndicators: false) {
        VStack(spacing: verticalSpacing) {
          
          ItemView(description: Strings.descriptionReset, imageView: Image(systemName: "doc"))
          ItemView(description: Strings.descriptionStore,
                   imageView: Image(systemName: "arrow.up.doc"))
          ItemView(description: Strings.descriptionScoreboard,
                   imageView: Image(systemName: "chart.bar.xaxis"))
          ItemView(description: Strings.descriptionTimeout,
                   imageView: Image(systemName: "clock.badge.exclamationmark"))
          
          
          HStack(spacing: horizontalSpacing){
            VStack(spacing: 3) {
              Image(systemName: "pause.circle").foregroundColor(Color.red)
              Image(systemName: "play.circle").foregroundColor(Color.red)
            }
            .frame(width: UIScreen.main.bounds.size.width*0.15)
            Text(Strings.descriptionEmergency)
            Spacer()
          }
          
          
          HStack(spacing: horizontalSpacing){
            EndTurn()
              .fill(Color.yellow)
              .overlay(Text("END")
                .font(.system(size: Values.overlayTextSize*0.25, weight: Font.Weight.heavy, design: Font.Design.rounded))
                .foregroundColor(Color.black)
                .multilineTextAlignment(.center))
              .frame(width: UIScreen.main.bounds.size.width*0.15,
                     height: UIScreen.main.bounds.size.width*0.07)
            Text(Strings.descriptionEndTurn)
            Spacer()
          }
          
        }
      } // end scroll
      .font(.system(size: Values.fontSize))
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
