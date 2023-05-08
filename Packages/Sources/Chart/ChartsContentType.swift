//
//  File.swift
//  
//
//  Created by laichunhui on 2023/5/6.
//

import SwiftUI

enum ChartsContentType: String, Identifiable, CaseIterable {
    var id: String { self.rawValue }
    
    case exile
    case coin
    var view: some View {
        overviewOrDetailView(isOverview: true)
    }
    
    var title: String {
        switch self {
        case .exile:
            return "Path Of Exile"
        case .coin:
            return "Coin cir"
        }
    }
    
    var detailView: some View {
        overviewOrDetailView(isOverview: false)
    }
    
    var chartDescriptor: AXChartDescriptor? {
        switch self {
        case .exile:
            return ExileCurrencyChartsView(isOverview: true, goodsType: ExileGoodsType.divine).makeChartDescriptor()
        case .coin:
            return nil
        }
    }
    
    @ViewBuilder
    private func overviewOrDetailView(isOverview: Bool) -> some View {
        switch self {
        case .exile:
            ExileCurrencyChartsView(isOverview: isOverview, goodsType: ExileGoodsType.divine)
        case .coin:
            Color(.white)
        }
    }
}
