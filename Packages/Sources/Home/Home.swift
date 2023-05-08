//
//  File.swift
//  
//
//  Created by laichunhui on 2023/5/4.
//

import ComposableArchitecture
import SharedModels
import SwiftUI
import Utilities
import ViewComponents

// MARK: - HomeView

public struct HomeView: View {
    let store: StoreOf<HomeReducer>
    
    @State
    private var animeHeroColors = [Int: Color]()
    
    public init(store: StoreOf<HomeReducer>) {
        self.store = store
    }
    
    private struct ViewState: Equatable {
        let isLoading: Bool
        
        init(_ state: HomeReducer.State) {
            self.isLoading = state.isLoading
        }
    }
    
    public var body: some View {
        WithViewStore(
            store,
            observe: ViewState.init
        ) { viewStore in
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    ExtraTopSafeAreaInset()
                    
                    editHeaderView()
                    
                    LazyVStack(spacing: 24) {
                        aimItemsRepresentable(
                            title: "Last Watched",
                            isLoading: viewStore.isLoading,
                            store: store.scope(
                                state: \.aimList
                            )
                        )
                    }
                    .placeholder(
                        active: viewStore.isLoading,
                        duration: 2.0
                    )
                    
                    ExtraBottomSafeAreaInset()
                    Spacer(minLength: 32)
                }
            }
            .transition(.opacity)
            .animation(
                .easeInOut(duration: 0.5),
                value: viewStore.isLoading
            )
            .disabled(viewStore.isLoading)
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
//#if os(iOS)
//        .ignoresSafeArea(.container, edges: DeviceUtil.isPhone ? .top : [])
//#endif
        .background(backgroundView)
    }
}

extension HomeView {
    @ViewBuilder
    var backgroundView: some View {
        WithViewStore(
            store,
            observe: \.heroPosition
        ) { viewStore in
            let color = animeHeroColors[viewStore.state] ?? .clear
            LinearGradient(
                stops: [
                    .init(
                        color: color,
                        location: 0.0
                    ),
                    .init(color: .clear, location: 1.0)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            .transition(.opacity)
            .animation(.easeInOut, value: viewStore.state)
        }
        .overlay(BlurView().opacity(0.5).ignoresSafeArea())
    }
}

// MARK: - Aims View
extension HomeView {
    private func editHeaderView() -> some View {
        WithViewStore(store) { viewStore in
            HStack(alignment: .lastTextBaseline, spacing: 20) {
                TextField(
                    "Wealth",
                    text: viewStore.binding(
                        get: \.wealth, send: HomeReducer.Action.wealthTextChanged)
                )
                .keyboardType(.numbersAndPunctuation)
                .font(Font.system(size: 36))
                .foregroundColor(Color.white)
                .textFieldStyle(.plain)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .submitLabel(.done)
    //            .focused($isEditing)
                
                TextField(
                    "Rise",
                    text: viewStore.binding(
                        get: \.riseRate, send: HomeReducer.Action.riseTextChanged)
                )
                .font(Font.system(size: 24))
                .foregroundColor(Color.rongGreen)
                .textFieldStyle(.plain)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.numbersAndPunctuation)
                .submitLabel(.done)
    //            .focused($isEditing)
            }
            .listRowBackground(Color.clear)
            .padding(.all, 18)
        }
    }
    
    @ViewBuilder
    func aimItemsRepresentable(
        title: String,
        isLoading: Bool,
        store: Store<Loadable<[AimModel]>, HomeReducer.Action>
    ) -> some View {
        WithViewStore(store) { state in
            state
        } content: { viewStore in
            if let items = viewStore.value,
               !items.isEmpty {
                ForEach(items) { model in
                    HStack(alignment: .center) {
                        Text(model.date.standardDateFormatString)
                            .foregroundColor(.white)
                            .font(Font.system(size: 16))
                        Spacer()
                        Text(String(format: "%0.0f", model.value))
                            .foregroundColor(Color.gold)
                            .font(Font.system(size: 16, weight: Font.Weight.bold))
                            .shimmering()
                    }
                    .contentShape(Rectangle())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .listRowBackground(Color.clear)
                    .padding(.all, 16)
                }
            }
        }
    }
}
