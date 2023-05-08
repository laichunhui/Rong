//
//  Popover+ViewStore.swift
//  Anime Now! (macOS)
//
//  Created by ErrorErrorError on 10/31/22.
//
//

#if os(macOS)
import ComposableArchitecture
import SwiftUI

public extension View {
    func popover<Action>(
        _ store: Store<Bool, Action>,
        onDismiss: @escaping () -> Action,
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        WithViewStore(store) { viewStore in
            self.popover(
                isPresented: viewStore.binding { viewState in
                    viewState.self
                } send: { _ in
                    onDismiss()
                }
            ) {
                content()
            }
        }
    }
}
#endif
