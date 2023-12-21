//
//  AppDelegate.swift
//  Anime Now! (iOS)
//
//  Created by ErrorErrorError on 10/9/22.
//

import AppFeature
import ComposableArchitecture
import Foundation

#if os(iOS)
import UIKit

let store = Store(
    initialState: AppReducer.State(),
    reducer: { AppReducer() }
)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _: UIApplication,
        didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        store.send(.appDelegate(.appDidFinishLaunching))
        return true
    }

    func application(
        _: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        let configuration = UISceneConfiguration(
            name: connectingSceneSession.configuration.name,
            sessionRole: connectingSceneSession.role
        )

        configuration.delegateClass = SceneDelegate.self

        return configuration
    }

    func application(_: UIApplication, didDiscardSceneSessions _: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after
        // application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func application(
        _: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        guard let hostingController = window?.rootViewController as? AnimeNowHostingController else {
            return .portrait
        }

        return hostingController.supportedInterfaceOrientations
    }
}
#else
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    let store = Store(
        initialState: AppReducer.State(),
        reducer: AppReducer()
    )

    func applicationDidFinishLaunching(_: Notification) {
        ViewStore(store).send(.appDelegate(.appDidFinishLaunching))
    }

    func applicationShouldTerminate(_: NSApplication) -> NSApplication.TerminateReply {
        let viewStore = ViewStore(store)

        if viewStore.hasPendingChanges {
            viewStore.send(.appDelegate(.appWillTerminate))
            return .terminateLater
        }

        return .terminateNow
    }
}
#endif
