

import SwiftUI

struct EndTurn: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    
    path.move(to: CGPoint(x: rect.width*0.05, y: 0))
    path.addLine(to: CGPoint(x: rect.width*0.8, y: 0))
    path.addLine(to: CGPoint(x: rect.width, y: rect.height*0.5))
    path.addLine(to: CGPoint(x: rect.width*0.8, y: rect.height))
    path.addLine(to: CGPoint(x: rect.width*0.05, y: rect.height))
    path.closeSubpath()
    
    return path
  }
}
