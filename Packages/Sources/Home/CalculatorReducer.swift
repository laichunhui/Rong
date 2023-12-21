//
//  File.swift
//  
//
//  Created by laichunhui on 2023/5/10.
//

import Foundation
import ComposableArchitecture
import Utilities
import SharedModels

public struct CalculatorReducer: Reducer {
    public struct State: Equatable {
        var heroPosition = 0
        var price: String = "10000"
        var isBuy: Bool = true
        var planList: [PlanModel] = []
        public init() {}
    }
    public enum Action: Equatable, BindableAction {
        case onAppear
        case onCalculatorTapped
        case riseTextChanged(String)
        case wealthTextChanged(String)
        case binding(BindingAction<HomeReducer.State>)
    }
    
    public init() {}

    public var body: some Reducer<State, Action> {
//        BindingReducer()
        Reduce(self.core)
    }
}

extension CalculatorReducer {
    func core(state: inout State, action: Action) -> Effect<Action> {
        return .none
    }
}

extension CalculatorReducer {
    private func planList(with price: String, isBuy: Bool = true) -> [PlanModel] {
        if isBuy {
            return [
                PlanModel(title: "↗", rate: "0.5%", value: price.multiply(1.0055)),
                PlanModel(title: "↗", rate: "1%", value: price.multiply(1.0105)),
                PlanModel(title: "↗", rate: "2%", value: price.multiply(1.0205)),
                PlanModel(title: "↗", rate: "3%", value: price.multiply(1.0305)),
                PlanModel(title: "↗", rate: "4%", value: price.multiply(1.0405)),
                PlanModel(title: "↗", rate: "5%", value: price.multiply(1.0505)),
                PlanModel(title: "↗", rate: "6%", value: price.multiply(1.0605)),
                PlanModel(title: "↗", rate: "7%", value: price.multiply(1.0705)),
                PlanModel(title: "↑", rate: "10%", value: price.multiply(1.105)),
                PlanModel(title: "↑", rate: "15%", value: price.multiply(1.155)),
                PlanModel(title: "↑", rate: "20%", value: price.multiply(1.205)),
                PlanModel(title: "↑", rate: "25%", value: price.multiply(1.255)),
                PlanModel(title: "↑", rate: "30%", value: price.multiply(1.305)),
                PlanModel(title: "↑", rate: "35%", value: price.multiply(1.355)),
                PlanModel(title: "↑", rate: "40%", value: price.multiply(1.405)),
                PlanModel(title: "↑", rate: "50%", value: price.multiply(1.505)),
                PlanModel(title: "↑", rate: "60%", value: price.multiply(1.605)),
                PlanModel(title: "↑", rate: "80%", value: price.multiply(1.805)),
            ]
        } else {
            return [
                PlanModel(title: "↘", rate: "0.5%", value: price.multiply(0.9945)),
                PlanModel(title: "↘", rate: "1%", value: price.multiply(0.9895)),
                PlanModel(title: "↘", rate: "2%", value: price.multiply(0.9795)),
                PlanModel(title: "↘", rate: "3%", value: price.multiply(0.9695)),
                PlanModel(title: "↘", rate: "4%", value: price.multiply(0.9595)),
                PlanModel(title: "↘", rate: "5%", value: price.multiply(0.9495)),
                PlanModel(title: "↘", rate: "6%", value: price.multiply(0.9395)),
                PlanModel(title: "↘", rate: "8%", value: price.multiply(0.9395)),
                PlanModel(title: "↓", rate: "10%", value: price.multiply(0.8995)),
                PlanModel(title: "↓", rate: "15%", value: price.multiply(0.8495)),
                PlanModel(title: "↓", rate: "20%", value: price.multiply(0.7995)),
                PlanModel(title: "↓", rate: "25%", value: price.multiply(0.7495)),
                PlanModel(title: "↓", rate: "30%", value: price.multiply(0.6995)),
                PlanModel(title: "↓", rate: "40%", value: price.multiply(0.5995)),
                PlanModel(title: "↓", rate: "50%", value: price.multiply(0.4995)),
                PlanModel(title: "↓", rate: "60%", value: price.multiply(0.3995)),
                ].map({ model in
                    var model = model
                    model.isRaise = false
                    return model
                })
        }
    }
}

struct PlanModel: Identifiable, Equatable {
    var id = UUID()
    
    var title: String
    var rate: String
    var value: String
    
    var isRaise: Bool = true
}

extension String {
    func multiply(_ multiplier: Double) -> String {
        guard let value = Double(self) else { return self }
        let result = value * multiplier
        return String(format:"%.3f", result)
    }
}
