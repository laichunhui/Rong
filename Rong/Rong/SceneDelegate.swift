//
//  SceneDelegate.swift
//  Anime Now! (iOS)
//
//  Created by ErrorErrorError on 10/9/22.
//

#if os(iOS)
import AppFeature
import ComposableArchitecture
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        window = (scene as? UIWindowScene).map { UIWindow(windowScene: $0) }
        window?.rootViewController = AnimeNowHostingController(
            wrappedView:
            AppView(
                store: store
            )
        )
        window?.makeKeyAndVisible()
    }

    func sceneWillResignActive(_: UIScene) {
        store.send(.appDelegate(.appDidEnterBackground))
    }

    func sceneDidDisconnect(_: UIScene) {
        store.send(.appDelegate(.appWillTerminate))
    }

    func sceneDidEnterBackground(_: UIScene) {
        store.send(.appDelegate(.appDidEnterBackground))
    }
}
#endif
