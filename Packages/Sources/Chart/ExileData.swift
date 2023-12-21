//
//  ExileData.swift
//  DieWelle
//
//  Created by laichunhui on 2023/4/23.
//

import Foundation

func date(year: Int, month: Int, day: Int = 1, hour: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
    Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minutes, second: seconds)) ?? Date()
}

struct ExileSale {
    let day: Date
    var price: Double
}

/// Data for the sales by location and weekday charts.
enum ExileData {
    static let divine: [ExileSale] = [
            ExileSale(day: date(year: 2023, month: 4, day: 14), price: 12),
            ExileSale(day: date(year: 2023, month: 4, day: 15), price: 10),
            ExileSale(day: date(year: 2023, month: 4, day: 16), price: 9),
            
            ExileSale(day: date(year: 2023, month: 4, day: 17), price: 8),
            ExileSale(day: date(year: 2023, month: 4, day: 18), price: 7.4),
            ExileSale(day: date(year: 2023, month: 4, day: 19), price: 6.5),
            ExileSale(day: date(year: 2023, month: 4, day: 20), price: 6.2),
            ExileSale(day: date(year: 2023, month: 4, day: 21), price: 5.5),
            ExileSale(day: date(year: 2023, month: 4, day: 22), price: 5),
            ExileSale(day: date(year: 2023, month: 4, day: 23), price: 4.4),
            
            ExileSale(day: date(year: 2023, month: 4, day: 24), price: 4.0),
            ExileSale(day: date(year: 2023, month: 4, day: 25), price: 3.88),
            ExileSale(day: date(year: 2023, month: 4, day: 26), price: 3.4),
            ExileSale(day: date(year: 2023, month: 4, day: 27), price: 3.63),
            ExileSale(day: date(year: 2023, month: 4, day: 28), price: 3.75),
            ExileSale(day: date(year: 2023, month: 4, day: 29), price: 3.59),
            ExileSale(day: date(year: 2023, month: 4, day: 30), price: 3.15),
            
            ExileSale(day: date(year: 2023, month: 5, day: 1), price: 2.96),
            ExileSale(day: date(year: 2023, month: 5, day: 2), price: 2.65),
            ExileSale(day: date(year: 2023, month: 5, day: 3), price: 2.5),
            ExileSale(day: date(year: 2023, month: 5, day: 4), price: 2.45),
            ExileSale(day: date(year: 2023, month: 5, day: 5), price: 2.49),
            ExileSale(day: date(year: 2023, month: 5, day: 6), price: 2.5),
            ExileSale(day: date(year: 2023, month: 5, day: 7), price: 2.27),
            
            ExileSale(day: date(year: 2023, month: 5, day: 8), price: 1.97),
            ExileSale(day: date(year: 2023, month: 5, day: 9), price: 1.913),
            ExileSale(day: date(year: 2023, month: 5, day: 10), price: 1.97),
            ExileSale(day: date(year: 2023, month: 5, day: 11), price: 2.04),
            ExileSale(day: date(year: 2023, month: 5, day: 12), price: 2.11),
            ExileSale(day: date(year: 2023, month: 5, day: 13), price: 2.12),
            ExileSale(day: date(year: 2023, month: 5, day: 14), price: 2.03),
            
            ExileSale(day: date(year: 2023, month: 5, day: 15), price: 2.14),
            ExileSale(day: date(year: 2023, month: 5, day: 16), price: 2.07),
            ExileSale(day: date(year: 2023, month: 5, day: 17), price: 2.13),
            ExileSale(day: date(year: 2023, month: 5, day: 18), price: 2.08),
            
            ExileSale(day: date(year: 2023, month: 5, day: 23), price: 1.76),
            ExileSale(day: date(year: 2023, month: 5, day: 24), price: 1.6),
        ]
    
    static let chaos: [ExileSale] = [
            ExileSale(day: date(year: 2023, month: 4, day: 14), price: 0.0854),
            ExileSale(day: date(year: 2023, month: 4, day: 15), price: 0.0754),
            ExileSale(day: date(year: 2023, month: 4, day: 16), price: 0.0654),
            
            ExileSale(day: date(year: 2023, month: 4, day: 17), price: 0.0554),
            ExileSale(day: date(year: 2023, month: 4, day: 18), price: 0.0554),
            ExileSale(day: date(year: 2023, month: 4, day: 19), price: 0.0554),
            ExileSale(day: date(year: 2023, month: 4, day: 20), price: 0.0554),
            ExileSale(day: date(year: 2023, month: 4, day: 21), price: 0.0344),
            ExileSale(day: date(year: 2023, month: 4, day: 22), price: 0.0284),
            ExileSale(day: date(year: 2023, month: 4, day: 23), price: 0.0264),
            
            ExileSale(day: date(year: 2023, month: 4, day: 24), price: 0.0246),
            ExileSale(day: date(year: 2023, month: 4, day: 25), price: 0.0234),
            ExileSale(day: date(year: 2023, month: 4, day: 26), price: 0.0186),
            ExileSale(day: date(year: 2023, month: 4, day: 27), price: 0.0176),
            ExileSale(day: date(year: 2023, month: 4, day: 28), price: 0.020),
            
            ExileSale(day: date(year: 2023, month: 5, day: 3), price: 0.0114),
        ]
}
