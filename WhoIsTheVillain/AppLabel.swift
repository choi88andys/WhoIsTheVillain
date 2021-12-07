


import SwiftUI

struct AppLabel: View {
    
    private var labelWidth: CGFloat {
        if SettingConstants.isPhone {
            return UIScreen.main.bounds.width * 0.9
        } else {
            return UIScreen.main.bounds.width * 0.8
        }
    }
    
    private var labelHeight: CGFloat {
        if SettingConstants.isPhone {
            return 50
        } else {
            return 85
        }
    }
    
    private var textSize: CGFloat {
        if SettingConstants.isPhone {
            return 45
        } else {
            return 80
        }
    }
    
    private var textPadding: CGFloat {
        if SettingConstants.isPhone {
            return 15
        } else {
            return 25
        }
    }
    
    
    
    var body: some View {
        return VStack {
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.gray)
                .overlay(Text("Who is villain?")
                            .font(.system(size: textSize, weight: Font.Weight.light, design: Font.Design.serif))
                            .italic()
                            .padding(.top, textPadding)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center))
                .frame(maxWidth: labelWidth, maxHeight: labelHeight)
                .padding(.top, 10)
            .navigationBarTitleDisplayMode(NavigationBarItem.TitleDisplayMode.inline)
            
            Divider()
        }
        .padding(.bottom, SettingConstants.fontSize*0.5)
    }
}

struct AppLabel_Previews: PreviewProvider {
    static var previews: some View {
        AppLabel()
            .previewDevice(PreviewDevice(rawValue: "iPhone 8"))
            .previewDisplayName("8")
        
        AppLabel()
            .previewDevice(PreviewDevice(rawValue: "iPad (9th generation)"))
            .previewDisplayName("pad 9 gen")
    }
}
