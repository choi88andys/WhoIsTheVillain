//
//  WhoIsTheVillainApp.swift
//  WhoIsTheVillain
//
//  Created by MacAndys on 2021/12/05.
//

import SwiftUI
import GoogleMobileAds

@main
struct WhoIsTheVillainApp: App {
  
  init() {
    GADMobileAds.sharedInstance().start(completionHandler: nil)
  }
  
  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
