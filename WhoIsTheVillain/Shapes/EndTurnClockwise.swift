

import SwiftUI

struct EndTurnClockwise: Shape {
  
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: rect.width*0.95, y: 0))
    path.addLine(to: CGPoint(x: rect.width*0.2, y: 0))
    path.addLine(to: CGPoint(x: 0, y: rect.height*0.5))
    path.addLine(to: CGPoint(x: rect.width*0.2, y: rect.height))
    path.addLine(to: CGPoint(x: rect.width*0.95, y: rect.height))
    path.closeSubpath()
    
    return path
  }
}

struct EndTurnClockwise_Previews: PreviewProvider {
  static var previews: some View {
    
    Group {
      EndTurn()
        .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
        .previewDisplayName("8")
      
      EndTurnClockwise()
        .previewDevice(PreviewDevice(rawValue: "iPad (9th generation)"))
        .previewDisplayName("pad 9 gen")
    }
  }
}
