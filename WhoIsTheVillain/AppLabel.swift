


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
    
    
    var body: some View {
        return VStack {
            RoundedRectangle(cornerRadius: SettingConstants.fontSize*1.5)
                .fill(Color.gray)
                .overlay(Text(Strings.appLabel)
                    .font(.system(size: SettingConstants.fontSize*1.9, weight: Font.Weight.light, design: Font.Design.serif))
                    // .italic()
                    .padding(.top, SettingConstants.fontSize*0.8)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center))
                .frame(maxWidth: labelWidth, maxHeight: labelHeight)
                .padding(.top, SettingConstants.fontSize*0.5)
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
