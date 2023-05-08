//
//  File.swift
//  
//
//  Created by laichunhui on 2023/5/4.
//

import SwiftUI
import ComposableArchitecture

public struct SettingView: View {
    let store: StoreOf<SettingReducer>

    public init(store: StoreOf<SettingReducer>) {
        self.store = store
    }

    private struct ViewState: Equatable {
        let isLoading: Bool

        init(_ state: SettingReducer.State) {
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
