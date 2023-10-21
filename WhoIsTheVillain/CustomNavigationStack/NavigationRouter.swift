//
//  File.swift
//  WhoIsTheVillain
//
//  Created by Andy on 10/21/23
//

import SwiftUI

/// Inspired by FlowStacks
struct NavigationRouter<Screen, ScreenView: View>: View {
  @Binding var stack: [Screen]
  @ViewBuilder var buildView: (Screen) -> ScreenView
  
  var body: some View {
    render()
  }
  
  private func render(_ index: Int = 0) -> NavigationNode<Screen, ScreenView> {
    guard index < stack.count else { return .end }
    return NavigationNode<Screen, ScreenView>.view(
      buildView(stack[index]),
      pushing: render(index+1),
      stack: $stack,
      index: index
    )
  }
}
