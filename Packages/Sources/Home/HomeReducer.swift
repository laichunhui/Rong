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

public struct NavigationRoutes {
    static let calculator = "calculator"
}

@Reducer
public struct Router {
    public enum State: Equatable {
      case calculator(CalculatorReducer.State)
    }
    public enum Action: Equatable {
      case calculator(CalculatorReducer.Action)
    }
    public var body: some ReducerOf<Self> {
      Scope(state: \.calculator, action: \.calculator) { CalculatorReducer() }
    }
}

@Reducer
public struct HomeReducer {
    public struct State: Equatable {
        var path = StackState<Router.State>()
        @PresentationState var navigationDestination: String?
        var heroPosition = 0
        var isLoading = false
        @BindingState
        var wealth: String = "700"
        var riseRate: String = "0.03"
        var aimList: [AimModel] = []
        public init() {}
    }
    public enum Action: Equatable, BindableAction {
        case onAppear
        case path(StackAction<Router.State, Router.Action>)
        case navigationDestination(PresentationAction<Never>)
        case onCalculatorTapped
        case riseTextChanged(String)
        case wealthTextChanged(String)
        case binding(BindingAction<State>)
    }
    
    public init() {}

    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce(self.core)
            .forEach(\.path, action: /Action.path) {
                Router()
            }
//            .ifLet(\.$navigationDestination, action: \.navigationDestination) {
//              EmptyReducer()
//            }
    }
    
}

extension HomeReducer {
    func core(state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .onAppear:
            if let wealth = Double(state.wealth), let riseRate = Double(state.riseRate) {
                state.aimList = aims(with: wealth, riseRate: riseRate)
            }
            return .none
            
        case let .riseTextChanged(text):
            guard text.count < 7 else { return .none }
            state.riseRate = text
            if let wealth = Double(state.wealth), let riseRate = Double(state.riseRate) {
                state.aimList = aims(with: wealth, riseRate: riseRate)
            }
            return .none
        case let .wealthTextChanged(text):
            guard text.count < 9 else { return .none }
            state.wealth = text
            if let wealth = Double(state.wealth), let riseRate = Double(state.riseRate) {
                state.aimList = aims(with: wealth, riseRate: riseRate)
            }
            return .none
        case .onCalculatorTapped:
            state.path.append(.calculator(CalculatorReducer.State()))
        default:
            break
        }
        return .none
    }
    
    private func aims(with wealth: Double, riseRate: Double) -> [AimModel] {
        var list = [AimModel]()
        if var date = "2024-12-03".transToDate() {
            var value: Double = wealth
            let rate: Double = 1 + riseRate
            let timeGap: TimeInterval = TimeInterval(24 * 3600)
            for _ in 0..<100 {
                value *= rate
                date.addTimeInterval(timeGap)
                list.append(AimModel(date: date, value: value))
            }
        }
        return list
    }
}
