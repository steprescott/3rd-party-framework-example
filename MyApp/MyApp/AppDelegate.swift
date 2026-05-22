//
//  AppDelegate.swift
//  MyApp
//

import UIKit
import CobrowseSDK

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let cobrowse = CobrowseIO.instance()
        
        cobrowse.license = "ste"
        cobrowse.customData = [
            CBIOUserEmailKey: "myapp@example.com"
        ]
        
        cobrowse.start()
        
        return true
    }
}
