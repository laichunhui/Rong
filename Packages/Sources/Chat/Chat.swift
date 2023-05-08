//
//  File.swift
//  
//
//  Created by laichunhui on 2023/5/4.
//

import SwiftUI
import ComposableArchitecture

public struct ChatView: View {
    let store: StoreOf<ChatReducer>

    public init(store: StoreOf<ChatReducer>) {
        self.store = store
    }

    private struct ViewState: Equatable {
        let isLoading: Bool

        init(_ state: ChatReducer.State) {
            self.isLoading = state.isLoading
        }
    }

    public var body: some View {
        WithViewStore(
            store,
            observe: ViewState.init
        ) { viewStore in
            ZStack {
            }
        }
    }
}

