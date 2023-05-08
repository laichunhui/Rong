//
//  File.swift
//
//
//  Created by ErrorErrorError on 1/7/23.
//
//

import ComposableArchitecture
import Foundation
import SwiftUI
import Utilities

// MARK: - LoadableView

public struct LoadableView<T, Loaded: View, Failed: View, Loading: View, Idle: View>: View {
    let loadable: Loadable<T>
    let loadedView: (T) -> Loaded
    let failedView: () -> Failed
    let loadingView: () -> Loading
    let idleView: () -> Idle

    var asGroup = true

    public init(
        loadable: Loadable<T>,
        @ViewBuilder loadedView: @escaping (T) -> Loaded,
        @ViewBuilder failedView: @escaping () -> Failed,
        @ViewBuilder loadingView: @escaping () -> Loading,
        @ViewBuilder idleView: @escaping () -> Idle
    ) {
        self.loadable = loadable
        self.loadedView = loadedView
        self.failedView = failedView
        self.loadingView = loadingView
        self.idleView = idleView
    }

    public var body: some View {
        if asGroup {
            ZStack {
                buildViews()
            }
        } else {
            buildViews()
        }
    }

    @ViewBuilder
    private func buildViews() -> some View {
        switch loadable {
        case .idle:
            idleView()
        case .loading:
            loadingView()
        case let .success(t):
            loadedView(t)
        case .failed:
            failedView()
        }
    }
}

public extension LoadableView {
    func asGroup(_ group: Bool) -> Self {
        var view = self
        view.asGroup = group
        return view
    }
}

public extension LoadableView {
    init(
        loadable: Loadable<T>,
        @ViewBuilder loadedView: @escaping (T) -> Loaded
    ) where Loading == EmptyView, Failed == EmptyView, Idle == EmptyView {
        self.init(
            loadable: loadable,
            loadedView: loadedView,
            failedView: { EmptyView() },
            loadingView: { EmptyView() },
            idleView: { EmptyView() }
        )
    }

    init(
        loadable: Loadable<T>,
        @ViewBuilder loadedView: @escaping (T) -> Loaded,
        @ViewBuilder failedView: @escaping () -> Failed,
        @ViewBuilder waitingView: @escaping () -> Idle
    ) where Loading == Idle {
        self.init(
            loadable: loadable,
            loadedView: loadedView,
            failedView: failedView,
            loadingView: waitingView,
            idleView: waitingView
        )
    }

    init(
        loadable: Loadable<T>,
        @ViewBuilder loadedView: @escaping (T) -> Loaded,
        @ViewBuilder failedView: @escaping () -> Failed
    ) where Loading == Idle, Idle == EmptyView {
        self.init(
            loadable: loadable,
            loadedView: loadedView,
            failedView: failedView,
            loadingView: { EmptyView() },
            idleView: { EmptyView() }
        )
    }

    init(
        loadable: Loadable<T>,
        @ViewBuilder loadedView: @escaping (T) -> Loaded,
        @ViewBuilder failedView: @escaping () -> Failed,
        @ViewBuilder loadingView: @escaping () -> Loading
    ) where Idle == EmptyView {
        self.init(
            loadable: loadable,
            loadedView: loadedView,
            failedView: failedView,
            loadingView: loadingView
        ) { EmptyView() }
    }
}

// MARK: - LoadableStore

public struct LoadableStore<T: Equatable, Action, Loaded: View, Failed: View, Loading: View, Idle: View>: View {
    let store: Store<Loadable<T>, Action>
    let loadedView: (Store<T, Action>) -> Loaded
    let failedView: (Store<Error, Action>) -> Failed
    let loadingView: (Store<Void, Action>) -> Loading
    let idleView: (Store<Void, Action>) -> Idle

    public init(
        store: Store<Loadable<T>, Action>,
        @ViewBuilder loadedView: @escaping (Store<T, Action>) -> Loaded,
        @ViewBuilder failedView: @escaping (Store<Error, Action>) -> Failed,
        @ViewBuilder loadingView: @escaping (Store<Void, Action>) -> Loading,
        @ViewBuilder idleView: @escaping (Store<Void, Action>) -> Idle
    ) {
        self.store = store
        self.loadedView = loadedView
        self.failedView = failedView
        self.loadingView = loadingView
        self.idleView = idleView
    }

    public var body: some View {
        SwitchStore(store) {
            CaseLet(state: /Loadable<T>.success, then: loadedView)
            CaseLet(state: /Loadable<T>.failed, then: failedView)
            CaseLet(state: /Loadable<T>.loading, then: loadingView)
            CaseLet(state: /Loadable<T>.idle, then: idleView)
        }
    }
}

public extension LoadableStore where Loading == EmptyView, Failed == EmptyView, Idle == EmptyView {
    init(
        store: Store<Loadable<T>, Action>,
        @ViewBuilder loadedView: @escaping (Store<T, Action>) -> Loaded
    ) {
        self.store = store
        self.loadedView = loadedView
        self.failedView = { _ in EmptyView() }
        self.loadingView = { _ in EmptyView() }
        self.idleView = { _ in EmptyView() }
    }
}

public extension LoadableStore where Loading == Idle {
    init(
        store: Store<Loadable<T>, Action>,
        @ViewBuilder loadedView: @escaping (Store<T, Action>) -> Loaded,
        @ViewBuilder failedView: @escaping (Store<Error, Action>) -> Failed,
        @ViewBuilder waitingView: @escaping (Store<Void, Action>) -> Idle
    ) {
        self.store = store
        self.loadedView = loadedView
        self.failedView = failedView
        self.loadingView = waitingView
        self.idleView = waitingView
    }
}

// MARK: - LoadableViewStore

public struct LoadableViewStore<T: Equatable, Action, Loaded: View, Failed: View, Loading: View, Idle: View>: View {
    let store: Store<Loadable<T>, Action>
    let loadedView: (ViewStore<T, Action>) -> Loaded
    let failedView: (ViewStore<Void, Action>) -> Failed
    let loadingView: (ViewStore<Void, Action>) -> Loading
    let idleView: (ViewStore<Void, Action>) -> Idle

    public var body: some View {
        LoadableStore(store: store) { store in
            WithViewStore(
                store,
                observe: { $0 },
                content: loadedView
            )
        } failedView: { store in
            WithViewStore(
                store.stateless,
                content: failedView
            )
        } loadingView: { store in
            WithViewStore(
                store,
                content: loadingView
            )
        } idleView: { store in
            WithViewStore(
                store,
                content: idleView
            )
        }
    }
}

public extension LoadableViewStore where Loading == EmptyView, Failed == EmptyView, Idle == EmptyView {
    init(
        loadable: Store<Loadable<T>, Action>,
        @ViewBuilder loadedView: @escaping (ViewStore<T, Action>) -> Loaded
    ) {
        self.init(
            store: loadable,
            loadedView: loadedView,
            failedView: { _ in EmptyView() },
            loadingView: { _ in EmptyView() },
            idleView: { _ in EmptyView() }
        )
    }
}

public extension LoadableViewStore where Loading == Idle {
    init(
        loadable: Store<Loadable<T>, Action>,
        @ViewBuilder loadedView: @escaping (ViewStore<T, Action>) -> Loaded,
        @ViewBuilder failedView: @escaping (ViewStore<Void, Action>) -> Failed,
        @ViewBuilder waitingView: @escaping (ViewStore<Void, Action>) -> Idle
    ) {
        self.init(
            store: loadable,
            loadedView: loadedView,
            failedView: failedView,
            loadingView: waitingView,
            idleView: waitingView
        )
    }
}
