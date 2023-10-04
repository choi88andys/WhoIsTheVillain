//
//  File.swift
//  WhoIsTheVillain
//
//  Created by Andy on 2023/09/23
//

import SwiftUI
import GoogleMobileAds
import Combine
import UserMessagingPlatform

// TODO: - GDPR
struct BannerView: View {
  @State private var isFailed = false
  @State private var width: CGFloat = 0
  @State private var height: CGFloat = 0
  
  var body: some View {
    ZStack {
      if isFailed {
        AppLabel()
      } else {
        ProgressView()
        BannerViewController(isFailed: $isFailed, width: $width, height: $height)
          .frame(width: width, height: height)
          .padding(.bottom, SettingConstants.fontSize*0.4)
      }
    }
  }
  
  private struct BannerViewController: UIViewControllerRepresentable {
    @Binding var isFailed: Bool
    @Binding var width: CGFloat
    @Binding var height: CGFloat
    
    func makeCoordinator() -> Coordinator { Coordinator() }
    class Coordinator { var cancelBag: Set<AnyCancellable> = [] }
    
    class UIBannerViewController: UIViewController, GADBannerViewDelegate {
      @Published var adReceived: Bool = false
      @Published var requestFailed: Bool = false
      
      func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        adReceived = true
      }
      
      func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
        requestFailed = true
      }
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
      let bannerViewController = UIBannerViewController(nibName: nil, bundle: nil)
      let bannerView = GADBannerView()
      let containerView = UIView()
      
      // Config
      bannerViewController.$requestFailed
        .sink { requestFailed in
          DispatchQueue.main.async {
            isFailed = requestFailed
          }
        }
        .store(in: &context.coordinator.cancelBag)
      
      bannerView.adSize = GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width)
      bannerView.translatesAutoresizingMaskIntoConstraints = false
#if DEBUG
      bannerView.adUnitID = Bundle.main.infoDictionary?["TestAdaptiveBannerID"] as? String ?? ""
#else
      bannerView.adUnitID = Bundle.main.infoDictionary?["TopBannerID"] as? String ?? ""
#endif
      bannerView.rootViewController = bannerViewController
      bannerView.delegate = bannerViewController
      containerView.backgroundColor = .clear
      
      // Set constraints
      containerView.addSubview(bannerView)
      bannerViewController.view = containerView
      let constraints: [NSLayoutConstraint] = [
        bannerView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
        bannerView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
      ]
      NSLayoutConstraint.activate(constraints)
      
      return bannerViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
      guard let bannerView = uiViewController.view.subviews.first as? GADBannerView else { return }
      let parameters = UMPRequestParameters()
      // Must set true if we don't know.
      let underAge = UserDefaults.standard.object(forKey: "overSeventeenYearsOld") as? Bool ?? true
      parameters.tagForUnderAgeOfConsent = underAge
      
      UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters) {
        if let consentError = $0 {
          print("Error: \(consentError.localizedDescription)")
          return
        }
        
        UMPConsentForm.loadAndPresentIfRequired(from: uiViewController) {
          if let consentError = $0 {
            print("Error: \(consentError.localizedDescription)")
            return
          }

          DispatchQueue.main.async {
            GADMobileAds.sharedInstance().start()
            
            width = bannerView.frame.width
            height = bannerView.frame.height
            uiViewController.view.frame = .init(
              x: 0,
              y: 0,
              width: bannerView.frame.width,
              height: bannerView.frame.height
            )
            
            bannerView.load(GADRequest())
          }
        }
      }
    }
  }
}
