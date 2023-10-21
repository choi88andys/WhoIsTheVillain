//
//  File.swift
//  WhoIsTheVillain
//
//  Created by Andy on 10/21/23
//

import SwiftUI

/// Inspired by FlowStacks
indirect enum NavigationNode<Screen, ScreenView: View>: View {
  case view(ScreenView, pushing: NavigationNode<Screen, ScreenView>, stack: Binding<[Screen]>, index: Int)
  case end
  
  var body: some View {
    if case let .view(view, pushedNode, stack, index) = self {
      view.background(
        NavigationLink(
          destination: pushedNode,
          isActive: Binding(
            get: {
              stack.wrappedValue.count > index + 1
            },
            set: { _ in
              stack.wrappedValue = Array(stack.wrappedValue.prefix(index + 1))
            }
          ),
          label: EmptyView.init
        )
        .hidden()
      )
    } else {
      EmptyView()
    }
  }
}
