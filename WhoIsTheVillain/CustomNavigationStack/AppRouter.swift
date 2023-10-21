//
//  AppRouter.swift
//  WhoIsTheVillain
//
//  Created by Andy on 10/21/23
//

import SwiftUI

struct AppRouter: View {
  enum Screen {
    case contentView
    case playingView
    case scoreboardView(isActivePlayingView: Bool)
    case helpView
  }
  
  @State var stack: [Screen] = [.contentView]
  @StateObject var sharedTimer: SharedTimer = SharedTimer()
  
  var body: some View {
    NavigationView {
      NavigationRouter(stack: $stack) { screen in
        switch screen {
        case .contentView:
          ContentView(
            startButtonTapped: pushPlayingView,
            helpButtonTapped: pushHelpView,
            scoreboardButtonTapped: pushScoreboardView
          )
          
        case .playingView:
          PlayingView(
            dismiss: dismiss,
            scoreBoardButtonTapped: pushScoreboardView
          )
          
        case let .scoreboardView(isActivePlayingView):
          ScoreboardView(
            dismiss: dismiss,
            homeButtonTapped: popToRoot, 
            isActivePlayingView: isActivePlayingView
          )
          
        case .helpView:
          HelpView(dismiss: dismiss)
        }
      }
    }
    .navigationViewStyle(.stack)
    .environmentObject(sharedTimer)
  }

  private func dismiss() {
    stack.removeLast()
  }
  private func popToRoot() {
    stack = [stack.first!]
  }
  private func pushPlayingView() {
    stack.append(.playingView)
  }
  private func pushHelpView() {
    stack.append(.helpView)
  }
  private func pushScoreboardView(isActivePlayingView: Bool) {
    stack.append(.scoreboardView(isActivePlayingView: isActivePlayingView))
  }
}
