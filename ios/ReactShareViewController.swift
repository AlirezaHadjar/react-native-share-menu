//
//  ReactShareViewController.swift
//  RNShareMenu
//
//  DO NOT EDIT THIS FILE. IT WILL BE OVERRIDEN BY NPM OR YARN.
//
//  Created by Gustavo Parreira on 29/07/2020.
//

import RNShareMenu

class ReactShareViewController: ShareViewController, RCTBridgeDelegate, ReactShareViewDelegate {
  func sourceURL(for bridge: RCTBridge!) -> URL! {
#if DEBUG
    return RCTBundleURLProvider.sharedSettings()?
      .jsBundleURL(forBundleRoot: "index.share", fallbackResource: nil)
#else
    return Bundle.main.url(forResource: "main", withExtension: "jsbundle")
#endif
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let bridge: RCTBridge! = RCTBridge(delegate: self, launchOptions: nil)
    let rootView = RCTRootView(
      bridge: bridge,
      moduleName: "ShareMenuModuleComponent",
      initialProperties: nil
    )

    rootView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    backgroundColorSetup: if let backgroundColorConfig = Bundle.main.infoDictionary?[REACT_SHARE_VIEW_BACKGROUND_COLOR_KEY] as? [String:Any] {
      if let transparent = backgroundColorConfig[COLOR_TRANSPARENT_KEY] as? Bool, transparent {
        rootView.backgroundColor = nil
        break backgroundColorSetup
      }

      let red = backgroundColorConfig[COLOR_RED_KEY] as? Float ?? 1
      let green = backgroundColorConfig[COLOR_GREEN_KEY] as? Float ?? 1
      let blue = backgroundColorConfig[COLOR_BLUE_KEY] as? Float ?? 1
      let alpha = backgroundColorConfig[COLOR_ALPHA_KEY] as? Float ?? 1

      rootView.backgroundColor = UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }

    self.view = rootView

    ShareMenuReactView.attachViewDelegate(self)
  }

  override func viewDidDisappear(_ animated: Bool) {
    cancel()
    ShareMenuReactView.detachViewDelegate()
  }

  func loadExtensionContext() -> NSExtensionContext {
    return extensionContext!
  }

  func openApp() {
    self.openHostApp()
  }

  func continueInApp(with items: [NSExtensionItem], and extraData: [String:Any]?) {
    handlePost(items, extraData: extraData)
  }
}