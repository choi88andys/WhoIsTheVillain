//
//  File.swift
//  WhoIsTheVillain
//
//  Created by Andy on 2023/09/23
//

import SwiftUI
import GoogleMobileAds
import Combine

struct BannerView: View {
  @State var isFailed = false
  
  var body: some View {
    ZStack {
      if isFailed {
        Image(systemName: "icloud.slash")
          .resizable()
          .scaledToFit()
      } else {
        ProgressView()
        BannerViewController(isFailed: $isFailed)
      }
    }
    .frame(
      width: SettingConstants.isPhone ?
      SettingConstants.screenWidth : GADAdSizeLeaderboard.size.width,
      height: SettingConstants.isPhone ?
      SettingConstants.screenWidth*SettingConstants.gadAdSizeBannerRatio : GADAdSizeLeaderboard.size.height
    )
  }
  
  private struct BannerViewController: UIViewControllerRepresentable {
    @Binding var isFailed: Bool
    
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
      
      if SettingConstants.isPhone {
        bannerView.adSize = GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(
          UIScreen.main.bounds.width
        )
      } else {
        bannerView.adSize = GADAdSizeLeaderboard
      }
      bannerView.translatesAutoresizingMaskIntoConstraints = false
#if DEBUG
      bannerView.adUnitID = Bundle.main.infoDictionary?["TestBannerID"] as? String ?? ""
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
      uiViewController.view.frame = .init(
        x: 0,
        y: 0,
        width: SettingConstants.isPhone ?
        SettingConstants.screenWidth : GADAdSizeLeaderboard.size.width,
        height: SettingConstants.isPhone ?
        SettingConstants.screenWidth*SettingConstants.gadAdSizeBannerRatio : GADAdSizeLeaderboard.size.height
      )
      
      if let bannerView = uiViewController.view.subviews.first as? GADBannerView {
        bannerView.load(GADRequest())
      }
    }
  }
}
