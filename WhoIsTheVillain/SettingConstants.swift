

import SwiftUI

struct SettingConstants {
  static let minUsers: Int = 2
  static let maxUsers: Int = 6
  
  static let timerInterval: Double = 0.2
  static let countdownSec: Double = 30
  
  static let pressDuration: Double = 0.3
  static let pressDistance: CGFloat = 300
  
  static let safeMargin: CGFloat = 10
  
  
  static let isPhone = (UIDevice.current.userInterfaceIdiom == .phone)
  static let fontSize: CGFloat = (UIDevice.current.userInterfaceIdiom == .phone) ? 20 : 40
  static let overlayTextSize: CGFloat = (UIDevice.current.userInterfaceIdiom == .phone) ? 40 : 60
  
  
  
  
}
