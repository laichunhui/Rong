//
//  File.swift
//  
//
//  Created by laichunhui on 2023/5/4.
//

import SwiftUI
import Charts
import ComposableArchitecture
import Utilities
import ImageDatabaseClient

public struct ChartView: View {
    let store: StoreOf<ChartReducer>
    @StateObject private var imageCache = ImagesCache()
    @State private var selectedChartType: ExileGoodsType?
    public init(store: StoreOf<ChartReducer>) {
        self.store = store
    }

    private struct ViewState: Equatable {
        let isLoading: Bool

        init(_ state: ChartReducer.State) {
            self.isLoading = state.isLoading
        }
    }
    
    public var body: some View {
        WithViewStore(
            store,
            observe: ViewState.init
        ) { viewStore in
            NavigationSplitView {
                List(selection: $selectedChartType) {
                    ForEach(displayedCategories) { category in
                        switch category {
                        case .exile:
                            Section {
                                ForEach(ExileGoodsType.allCases) { chart in
                                    NavigationLink(value: chart) {
                                        preview(chart: chart)
                                    }
                                }
                            } header: {
                                Text("\(category.rawValue)")
                            }
                        case .coin:
                            Section {
                                Text("Comming")
                            } header: {
                                Text("\(category.rawValue)")
                            }
                        }
                    }
                }
                #if os(macOS)
                .listStyle(.bordered)
                #else
                .listStyle(.insetGrouped)
                #endif
                .navigationTitle("Charts")

            } detail: {
                NavigationStack {
                    if let selectedChartType {
                        selectedChartType.detailView
                    } else {
                        Text("Select a chart")
                    }
                }
            }
        }
    }
    
    private var displayedCategories: [ChartsContentType] {
        return ChartsContentType.allCases
    }

    private func preview(chart: ExileGoodsType) -> some View {
        VStack(alignment: .leading) {
            Text(chart.title)

            // causes UI to hang for several seconds when scrolling
            // from 100% CPU usage when cells are reloaded
    //            chart.view

            // workaround to address hanging UI
            // Reported FB10335209
            if let image = imageCache.images[chart] {
                AccessiblePreviewImage(id: chart.id, image: image)
            }
        }
    }
}

// MARK: - Preview

@MainActor private final class ImagesCache: ObservableObject {
    @Published var images: [ExileGoodsType: PlatformImage] = [:]

    init() {
        ExileGoodsType.allCases.forEach { chart in
            let view = chart.view
                .padding(10)
                .frame(width: 300)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                }
            let renderer = ImageRenderer(content: view)
            #if os(macOS)
            renderer.scale = NSApplication.shared.mainWindow?.backingScaleFactor ?? 1
            if let image = renderer.nsImage {
                images[chart] = image
            }
            #else
            renderer.scale = UIScreen.main.scale
            if let image = renderer.uiImage {
                images[chart] = image
            }
            #endif
        }
    }
}

struct AccessiblePreviewImage: View, AXChartDescriptorRepresentable {
    @State var id: String
    @State var image: PlatformImage
    
    var body: some View {
        Image(image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: 320)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            // Remove the image trait so VoiceOver doesn't attempt to describe image contents
            .accessibilityRemoveTraits(.isImage)
            .accessibilityChartDescriptor(self)
    }
    
    func makeChartDescriptor() -> AXChartDescriptor {
        guard let chartType = ChartsContentType(rawValue: id) else {
            fatalError("Unknown Chart Type")
        }

        if let chartDescriptor = chartType.chartDescriptor {
            return chartDescriptor
        }

        let axis = AXNumericDataAxisDescriptor(title: "", range: 0...0, gridlinePositions: []) { _ in "" }
        return AXChartDescriptor(title: "", summary: nil, xAxis: axis, yAxis: axis, series: [])

        /*
         // TODO: Something like this might be better, but the if always evaluates to false
         if
             let chartType = ChartType(rawValue: id),
             let view = chartType.view as? any View & AXChartDescriptorRepresentable {
             return view.makeChartDescriptor()
         } else {
             let axis = AXNumericDataAxisDescriptor(title: "", range: 0.0...0.0, gridlinePositions: [], valueDescriptionProvider: { _ in
                 return ""
             })
             return AXChartDescriptor(title: "", summary: nil, xAxis: axis, yAxis: axis, series: [])
         }
         */
    }
}
