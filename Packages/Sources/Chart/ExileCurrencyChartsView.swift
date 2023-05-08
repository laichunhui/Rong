//
//  ExileCurrencyChartsView.swift
//  DieWelle
//
//  Created by laichunhui on 2023/4/23.
//

import SwiftUI
import Charts

enum ExileGoodsType: String, Identifiable, CaseIterable {
    
    case divine
    case chaos
    
    var id: String { self.rawValue }
    
    var data: [ExileSale] {
        switch self {
        case .divine:
            return ExileData.divine
        case .chaos:
            return ExileData.chaos
        }
    }
    
    var title: String {
        switch self {
        case .divine:
            return "Divine"
        case .chaos:
            return "Chaos"
        }
    }
    
    var view: some View {
        overviewOrDetailView(isOverview: true)
    }
    
    var detailView: some View {
        overviewOrDetailView(isOverview: false)
    }

    var chartDescriptor: AXChartDescriptor? {
        return ExileCurrencyChartsView(isOverview: true, goodsType: self).makeChartDescriptor()
    }
    
    private func overviewOrDetailView(isOverview: Bool) -> some View {
        return ExileCurrencyChartsView(isOverview: isOverview, goodsType: self)
    }
}

struct ExileCurrencyChartsView: View {
    var isOverview: Bool
    var goodsType: ExileGoodsType

    @State private var lineWidth = 2.0
    @State private var interpolationMethod: ChartInterpolationMethod = .cardinal
    @State private var chartColor: Color = .blue
    @State private var showSymbols = true
    @State private var selectedElement: ExileSale?
    @State private var showLollipop = true
    var data = ExileData.divine
    
    init(isOverview: Bool, goodsType: ExileGoodsType) {
        self.isOverview = isOverview
        self.goodsType = goodsType
        self.data = goodsType.data
    }

    var body: some View {
        if isOverview {
            chart
                .allowsHitTesting(false)
        } else {
            List {
                Section {
                    chart
                }
            }
            .navigationBarTitle(goodsType.title, displayMode: .inline)
        }
    }

    private var chart: some View {
        Chart(data, id: \.day) {
            LineMark(
                x: .value("Date", $0.day),
                y: .value("Sales", $0.price)
            )
            .accessibilityLabel($0.day.formatted(date: .complete, time: .omitted))
            .accessibilityValue("\($0.price) sold")
            .lineStyle(StrokeStyle(lineWidth: lineWidth))
            .foregroundStyle(chartColor.gradient)
            .interpolationMethod(interpolationMethod.mode)
            .symbol(Circle().strokeBorder(lineWidth: lineWidth))
            .symbolSize(showSymbols ? 60 : 0)
        }
        .chartOverlay { proxy in
            GeometryReader { geo in
                Rectangle().fill(.clear).contentShape(Rectangle())
                    .gesture(
                        SpatialTapGesture()
                            .onEnded { value in
                                let element = findElement(location: value.location, proxy: proxy, geometry: geo)
                                if selectedElement?.day == element?.day {
                                    // If tapping the same element, clear the selection.
                                    selectedElement = nil
                                } else {
                                    selectedElement = element
                                }
                            }
                            .exclusively(
                                before: DragGesture()
                                    .onChanged { value in
                                        selectedElement = findElement(location: value.location, proxy: proxy, geometry: geo)
                                    }
                            )
                    )
            }
        }
        .chartBackground { proxy in
            ZStack(alignment: .topLeading) {
                GeometryReader { geo in
                    if showLollipop,
                       let selectedElement {
                        let dateInterval = Calendar.current.dateInterval(of: .day, for: selectedElement.day)!
                        let startPositionX1 = proxy.position(forX: dateInterval.start) ?? 0

                        let lineX = startPositionX1 + geo[proxy.plotAreaFrame].origin.x
                        let lineHeight = geo[proxy.plotAreaFrame].maxY
                        let boxWidth: CGFloat = 100
                        let boxOffset = max(0, min(geo.size.width - boxWidth, lineX - boxWidth / 2))

                        Rectangle()
                            .fill(.white.opacity(0.6))
                            .frame(width: 0.5, height: lineHeight)
                            .position(x: lineX, y: lineHeight / 2)

                        VStack(alignment: .center) {
                            Text("\(selectedElement.day, format: .dateTime.year().month().day())")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            Text("\(selectedElement.price, format: .number)")
                                .font(.title2.bold())
                                .foregroundColor(.primary)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityHidden(isOverview)
                        .frame(width: boxWidth, alignment: .leading)
                        .background {
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.background)
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(.quaternary.opacity(0.7))
                            }
                            .padding(.horizontal, -8)
                            .padding(.vertical, -4)
                        }
                        .offset(x: boxOffset)
                    }
                }
            }
        }
        .chartXAxis(isOverview ? .hidden : .automatic)
        .chartYAxis(isOverview ? .hidden : .automatic)
        .accessibilityChartDescriptor(self)
//        .frame(height: isOverview ? Constants.previewChartHeight : Constants.detailChartHeight)
    }
    
    private func findElement(location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) -> ExileSale? {
        let relativeXPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        if let date = proxy.value(atX: relativeXPosition) as Date? {
            // Find the closest date element.
            var minDistance: TimeInterval = .infinity
            var index: Int? = nil
            for salesDataIndex in data.indices {
                let nthSalesDataDistance = data[salesDataIndex].day.distance(to: date)
                if abs(nthSalesDataDistance) < minDistance {
                    minDistance = abs(nthSalesDataDistance)
                    index = salesDataIndex
                }
            }
            if let index {
                return data[index]
            }
        }
        return nil
    }
}

// MARK: - Accessibility

extension ExileCurrencyChartsView: AXChartDescriptorRepresentable {
    func makeChartDescriptor() -> AXChartDescriptor {
        AccessibilityHelpers.chartDescriptor(forSalesSeries: data)
    }
}

// MARK: - Preview

struct ExileCurrencyChartsView_Previews: PreviewProvider {
    static var previews: some View {
        ExileCurrencyChartsView(isOverview: true, goodsType: ExileGoodsType.divine)
        ExileCurrencyChartsView(isOverview: false, goodsType: ExileGoodsType.divine)
    }
}

enum AccessibilityHelpers {
    // TODO: This should be a protocol but since the data objects are in flux this will suffice
    static func chartDescriptor(forSalesSeries data: [ExileSale],
                                saleThreshold: Double? = nil,
                                isContinuous: Bool = false) -> AXChartDescriptor {

        // Since we're measuring a tangible quantity,
        // keeping an independant minimum prevents visual scaling in the Rotor Chart Details View
        let min = 0 // data.map(\.sales).min() ??
        let max = data.map(\.price).max() ?? 0

        // A closure that takes a date and converts it to a label for axes
        let dateTupleStringConverter: ((ExileSale) -> (String)) = { dataPoint in

            let dateDescription = dataPoint.day.formatted(date: .complete, time: .omitted)

//            if let threshold = saleThreshold {
//                let isAbove = dataPoint.isAbove(threshold: threshold)
//
//                return "\(dateDescription): \(isAbove ? "Above" : "Below") threshold"
//            }

            return dateDescription
        }

        let xAxis = AXNumericDataAxisDescriptor(
            title: "Date index",
            range: Double(0)...Double(data.count),
            gridlinePositions: []
        ) { "Day \(Int($0) + 1)" }

        let yAxis = AXNumericDataAxisDescriptor(
            title: "Sales",
            range: Double(min)...Double(max),
            gridlinePositions: []
        ) { value in "\(Int(value)) sold" }

        let series = AXDataSeriesDescriptor(
            name: "Daily sale quantity",
            isContinuous: isContinuous,
            dataPoints: data.enumerated().map { (idx, point) in
                    .init(x: Double(idx),
                          y: Double(point.price),
                          label: dateTupleStringConverter(point))
            }
        )

        return AXChartDescriptor(
            title: "Sales per day",
            summary: nil,
            xAxis: xAxis,
            yAxis: yAxis,
            additionalAxes: [],
            series: [series]
        )
    }
}
