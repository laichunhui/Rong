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
import SFSafeSymbols

// MARK: - HomeView

public struct HomeView: View {
    let store: StoreOf<HomeReducer>
    
    @State
    private var animeHeroColors = [Int: Color]()
    
    public init(store: StoreOf<HomeReducer>) {
        self.store = store
    }
    
    private struct ViewState: Equatable {
        var aimList: [AimModel]
        var isLoading: Bool
        init(_ state: HomeReducer.State) {
            self.aimList = state.aimList
            self.isLoading = state.isLoading
        }
    }
    
    public var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
            NavigationLink(state: Router.State.calculator(CalculatorReducer.State())) {
              Text("Push feature")
            }
        } destination: { store in
            Form {
              Section {
                NavigationLink(state: CalculatorReducer.State()) {
                  Text("Push feature")
                }
              }
            }
        }

//            WithViewStore(
//                store,
//                observe: ViewState.init
//            ) { viewStore in
//                StackNavigation(title: "Path Of Free") {
//                    ZStack {
//                        ScrollView(.vertical, showsIndicators: false) {
//                            ExtraTopSafeAreaInset()
//                            
//                            editHeaderView
//                            
//                            LazyVStack(spacing: 24) {
//                                aimItemsRepresentable(title: "Last Watched", items: viewStore.aimList)
//                            }
//                            .placeholder(
//                                active: viewStore.isLoading,
//                                duration: 2.0
//                            )
//                            
//                            ExtraBottomSafeAreaInset()
//                            Spacer(minLength: 32)
//                        }
//                    }
//                    .transition(.opacity)
//                    .animation(
//                        .easeInOut(duration: 0.5),
//                        value: viewStore.isLoading
//                    )
//                    .disabled(viewStore.isLoading)
//                    .onAppear {
//                        viewStore.send(.onAppear)
//                    }
//                }
//            buttons: {
//                //                NavigationLink(value: 1) {
//                //                    Image(systemSymbol: .keyboardOnehandedRight)
//                //                        .foregroundColor(.white)
//                //                        .font(.title3.bold())
//                //                        .contentShape(Rectangle())
//                //                }
//                Button {
//                    store.send(.onCalculatorTapped)
//                    //                    NavigationLink("Calculator") {
//                    //                        CalculatorView(store: .init(initialState: .init(), reducer: { CalculatorReducer() }))
//                    //                    }
//                } label: {
//                    Image(systemSymbol: .keyboardOnehandedRight)
//                        .foregroundColor(.white)
//                        .font(.title3.bold())
//                        .contentShape(Rectangle())
//                }
//                .buttonStyle(.plain)
//            }
//            .frame(
//                maxWidth: .infinity,
//                maxHeight: .infinity
//            )
//            .background(backgroundView)
//                //            .navigationDestination(
//                //              store: self.store.scope(
//                //                state: \.$navigationDestination, action: { .navigationDestination($0) })
//                //            ) {
//                //              DestinationView(store: $0)
//                //            }
//            }
        
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
    private var editHeaderView: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            HStack(alignment: .lastTextBaseline, spacing: 20) {
                TextField(
                    "Wealth",
                    text: viewStore.binding(get: \.wealth, send: HomeReducer.Action.wealthTextChanged)
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
        items: [AimModel]
    ) -> some View {
        if !items.isEmpty {
            ForEach(items) { model in
                HStack(alignment: .center) {
                    Text(model.date.standardDateFormatString)
                        .foregroundColor(.white)
                        .font(Font.system(size: 16))
                    Spacer()
                    Text(String(format: "%0.0f", model.value))
                        .foregroundColor(Color.yellow)
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


private struct DestinationView: View {
  let store: StoreOf<EmptyReducer<String, Never>>
  var body: some View {
      WithViewStore(store, observe: { $0 }) { viewStore in
          switch viewStore.state {
          case NavigationRoutes.calculator:
              CalculatorView(store: .init(initialState: .init(), reducer: { CalculatorReducer() }))
          default:
              Text("empty Destination")
          }
      }
    
  }
}
