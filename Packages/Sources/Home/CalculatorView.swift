//
//  File.swift
//  
//
//  Created by laichunhui on 2023/5/10.
//

import SwiftUI
import ComposableArchitecture

public struct CalculatorView: View {
    let store: StoreOf<CalculatorReducer>

    public init(store: StoreOf<CalculatorReducer>) {
        self.store = store
    }

    private struct ViewState: Equatable {
        init(_ state: CalculatorReducer.State) {
         
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
