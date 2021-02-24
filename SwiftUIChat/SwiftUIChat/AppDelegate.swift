//
//  AppDelegate.swift
//  SwiftUIChat
//
//  Created by Matheus Cardoso on 5/11/20.
//  Copyright © 2020 Stream. All rights reserved.
//

import UIKit
import StreamChat

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        /// 1: Create a `ChatClientConfig` with the API key.
        let config = ChatClientConfig(apiKeyString: "74e5enp33qj2")

        /// 2: Set the shared `ChatClient` instance with the config and a temporary token provider.
        ChatClient.shared = ChatClient(config: config, tokenProvider: .anonymous)
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

