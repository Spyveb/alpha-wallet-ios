//
//  CustomTabViewController.swift
//  STTabbar_Example
//
//  Created by Shraddha Sojitra on 19/06/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

class CustomTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let myTabbar = tabBar as? STTabbar {
            myTabbar.centerButtonActionHandler = {
                print("Center Button Tapped")
                
                let vc = (self.viewControllers![0] as! UINavigationController).viewControllers[0] as! TokensViewController
                
                if vc.config.development.shouldReadClipboardForWalletConnectUrl {
                    if let s = UIPasteboard.general.string ?? UIPasteboard.general.url?.absoluteString, let url = AlphaWallet.WalletConnect.ConnectionUrl(s) {
                        vc.walletConnectCoordinator.openSession(url: url)
                    }
                } else {
                    vc.delegate?.launchUniversalScanner(fromSource: Analytics.ScanQRCodeSource.quickAction)
                }
            }
        }
    }
}
