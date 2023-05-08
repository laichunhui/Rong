//
//  Color+Extension.swift
//
//
//  Created by ErrorErrorError on 11/18/22.
//
//

import SwiftUI

public extension Color {
    static let primaryAccent = Color("primaryAccent")
    static let secondaryAccent = Color("secondaryAccent")
    
    /// 高亮/选中（黄色）
    static let steamYellow = 0xFFF15E.color
    /// 错误/警告（红色）
    static let steamRed = 0xF54479.color
    
    static let gold = 0xEABE65.color
    
    static let rongGreen = 0x74D607.color
}

extension Int {
    public var color: Color {
        let red = Double(self as Int >> 16 & 0xff) / 255
        let green = Double(self >> 8 & 0xff) / 255
        let blue  = Double(self & 0xff) / 255
        return Color(red: red, green: green, blue: blue)
    }
    
    public var uiColor: UIColor {
        let red = Double(self as Int >> 16 & 0xff) / 255
        let green = Double(self >> 8 & 0xff) / 255
        let blue  = Double(self & 0xff) / 255
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
}
