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
    lazy var viewStore = ViewStore(store.stateless)

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
        viewStore.send(.appDelegate(.appDidEnterBackground))
    }

    func sceneDidDisconnect(_: UIScene) {
        viewStore.send(.appDelegate(.appWillTerminate))
    }

    func sceneDidEnterBackground(_: UIScene) {
        viewStore.send(.appDelegate(.appDidEnterBackground))
    }
}
#endif
