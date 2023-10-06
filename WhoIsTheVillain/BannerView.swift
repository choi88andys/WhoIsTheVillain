//
//  File.swift
//  WhoIsTheVillain
//
//  Created by Andy on 2023/09/23
//

import SwiftUI
import GoogleMobileAds
import UserMessagingPlatform

// TODO: - GDPR
struct BannerView: View {
  @StateObject private var delegate: BannerViewDelegate = .init()
  @State private var width: CGFloat = 0
  @State private var height: CGFloat = 0
  @State private var hasViewAppeared = false
  private let formViewController = FormViewController()
  private let viewController = UIViewController(nibName: nil, bundle: nil)
  
  var body: some View {
    ZStack {
      if delegate.isFailed {
        AppLabel()
      } else {
        ProgressView()
        BannerViewController(viewController: viewController, bannerViewDelegate: delegate)
          .frame(width: width, height: height)
          .padding(.bottom, Values.fontSize*0.4)
          .background { formViewController.frame(width: .zero, height: .zero) }
          .task { await bannerViewControllerTask() }
      }
    }
  }
  
  private func bannerViewControllerTask() async {
    guard !hasViewAppeared else { return }
    hasViewAppeared = true
    
    if let frame = viewController.view.subviews.first?.frame {
      width = frame.width
      height = frame.height
    }
    
    let parameters = UMPRequestParameters()
    parameters.tagForUnderAgeOfConsent =
    UserDefaults.standard.object(forKey: "overSeventeenYearsOld") as? Bool ?? true
    do {
      try await UMPConsentInformation.sharedInstance.requestConsentInfoUpdate(with: parameters)
      try await UMPConsentForm.loadAndPresentIfRequired(
        from: formViewController.viewController
      )
      if UMPConsentInformation.sharedInstance.canRequestAds {
        loadAds()
      }
    } catch {
      if UMPConsentInformation.sharedInstance.canRequestAds {
        loadAds()
      }
    }
  }
  
  private func loadAds() {
    GADMobileAds.sharedInstance().start()
    if let bannerView = viewController.view.subviews.first as? GADBannerView {
      bannerView.load(GADRequest())
    }
  }
}

fileprivate struct BannerViewController: UIViewControllerRepresentable {
  let viewController: UIViewController
  let bannerViewDelegate: GADBannerViewDelegate?
  
  init(viewController: UIViewController, bannerViewDelegate: GADBannerViewDelegate?) {
    self.viewController = viewController
    self.bannerViewDelegate = bannerViewDelegate
  }
  
  func makeUIViewController(context: Context) -> some UIViewController {
    let bannerViewController = viewController
    let containerView = UIView()
    let bannerView = GADBannerView()
    
    bannerView.adSize = GADPortraitAnchoredAdaptiveBannerAdSizeWithWidth(UIScreen.main.bounds.width)
    bannerView.translatesAutoresizingMaskIntoConstraints = false
#if DEBUG
    bannerView.adUnitID = Bundle.main.infoDictionary?["TestAdaptiveBannerID"] as? String ?? ""
#else
    bannerView.adUnitID = Bundle.main.infoDictionary?["TopBannerID"] as? String ?? ""
#endif
    bannerView.rootViewController = bannerViewController
    // bannerView.delegate = context.coordinator.parent.bannerViewDelegate
    bannerView.delegate = bannerViewDelegate
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
  
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}

fileprivate class BannerViewDelegate: NSObject, ObservableObject, GADBannerViewDelegate {
  @Published var isFailed = false
  
  func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
    isFailed = true
  }
  
  func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
    isFailed = false
  }
}

fileprivate struct FormViewController: UIViewControllerRepresentable {
  let viewController = UIViewController()
  func makeUIViewController(context: Context) -> some UIViewController { viewController }
  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}
