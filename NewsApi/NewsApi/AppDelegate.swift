//
//  AppDelegate.swift
//  NewsApi
//
//  Created by Александр Сибирцев on 29.06.2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let barButton = UIBarButtonItem.appearance()
        barButton.setTitleTextAttributes([.foregroundColor: UIColor.white], for: .highlighted)
        barButton.setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000.0, vertical: 0), for: .default)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }


}

