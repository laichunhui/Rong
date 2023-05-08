//
//  File.swift
//  
//
//  Created by laichunhui on 2023/5/6.
//

import Foundation
import ComposableArchitecture
import Utilities
import SharedModels

public struct HomeReducer: ReducerProtocol {
    public struct State: Equatable {
        @BindableState
        var heroPosition = 0
        var wealth: String = "10000"
        var riseRate: String = "0.03"
        var aimList: Loadable<[AimModel]> = .idle
        public init() {}
    }
    public enum Action: Equatable, BindableAction {
        case onAppear
        case riseTextChanged(String)
        case wealthTextChanged(String)
        case binding(BindingAction<HomeReducer.State>)
    }
    
    public init() {}

    public var body: some ReducerProtocol<State, Action> {
//        BindingReducer()
        Reduce(self.core)
    }
    
}

extension HomeReducer {
    struct FetchTopTrendingCancellable: Hashable {}
    struct FetchTopUpcomingCancellable: Hashable {}
    struct FetchHighestRatedCancellable: Hashable {}
    struct FetchMostPopularCancellable: Hashable {}
    struct FetchLatestUpdatedCancellable: Hashable {}
    
    func core(state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .onAppear:
            guard !state.hasInitialized else {
                break
            }
            state.aimList = .loading
            if let wealth = Double(state.wealth), let riseRate = Double(state.riseRate) {
                state.aimList = .success(aims(with: wealth, riseRate: riseRate))
            }
            return .none
            
        case let .riseTextChanged(text):
            guard text.count < 7 else { return .none }
            state.riseRate = text
            if let wealth = Double(state.wealth), let riseRate = Double(state.riseRate) {
                state.aimList = .success(aims(with: wealth, riseRate: riseRate))
            }
            return .none
        case let .wealthTextChanged(text):
            guard text.count < 9 else { return .none }
            state.wealth = text
            if let wealth = Double(state.wealth), let riseRate = Double(state.riseRate) {
                state.aimList = .success(aims(with: wealth, riseRate: riseRate))
            }
            return .none
        default:
            break
        }
        return .none
    }
    
    private func aims(with wealth: Double, riseRate: Double) -> [AimModel] {
        var list = [AimModel]()
        if var date = "2023-05-01".transToDate() {
            var value: Double = wealth
            let rate: Double = 1 + riseRate
            let timeGap: TimeInterval = TimeInterval(24 * 3600)
            for _ in 0..<150 {
                value *= rate
                date.addTimeInterval(timeGap)
                list.append(AimModel(date: date, value: value))
            }
        }
        return list
    }
}


extension HomeReducer.State {
    var isLoading: Bool {
        return false
    }
    var hasInitialized: Bool {
        aimList.hasInitialized
    }
}
