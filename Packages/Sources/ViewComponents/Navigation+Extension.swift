//
//  Navigation+Extension.swift
//  Anime Now!
//
//  Created by ErrorErrorError on 9/9/22.
//

import ComposableArchitecture
import Foundation
import SwiftUI

extension View {
    func fullScreenStore<State, Action>(
        store: Store<State?, Action>,
        onDismiss: @escaping () -> Void,
        destination: @escaping (Store<State, Action>) -> some View
    ) -> some View {
        WithViewStore(store.scope { $0 != nil }) { viewStore in
            #if os(iOS)
            self.fullScreenCover(
                isPresented: .init(
                    get: { viewStore.state },
                    set: { $0 ? () : onDismiss() }
                )
            ) {
                IfLetStore(
                    store
                ) { store in
                    destination(store)
                }
            }
            #else
            self.overlay(
                IfLetStore(
                    store
                ) { store in
                    destination(store)
                }
            )
            #endif
        }
    }

    func sheetStore<State, Action>(
        store: Store<State?, Action>,
        onDismiss: @escaping () -> Void,
        destination: @escaping (Store<State, Action>) -> some View
    ) -> some View {
        WithViewStore(store.scope { $0 != nil }) { viewStore in
            #if os(iOS)
            self.sheet(
                isPresented: .init(
                    get: { viewStore.state },
                    set: { $0 ? () : onDismiss() }
                )
            ) {
                IfLetStore(
                    store
                ) { store in
                    destination(store)
                }
            }
            #else
            self.overlay(
                IfLetStore(
                    store
                ) { store in
                    destination(store)
                }
            )
            #endif
        }
    }
}
