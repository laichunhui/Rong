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

public extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

public extension Color {
    /// 主题色 #4CECE6
     static let main: Color = Color(hex: "#4CECE6")
    /// 背景色 #06060C
    static let background: Color = Color(hex: "#06060C")
    /// 二级页面背景色 #171A25
    static let secondPageBG: Color = Color(hex: "#171A25")
    /// 浮层卡片背景色 #1E222E
    static let floatLayerBG: Color = Color(hex: "#1E222E")
    /// GameBox/FontHiLightBtn
    static let fontHiLightBtn: Color = Color(hex: "#000000")
    /// TabBar底色 #12151F
    static let tabbarBG: Color = Color(hex: "#12151F")
    /// 标题内容 白色
    static let textTitle: Color = Color.white
    /// 主要内容 白色 0.8
    static let textMain: Color = Color.white.opacity(0.8)
    /// 次要内容  白色 0.6
    static let textSecondary: Color = Color.white.opacity(0.6)
    /// 描述内容  白色 0.5
    static let textDes: Color = Color.white.opacity(0.5)
    /// 补充内容 白色 0.4
    static let texttAddition: Color = Color.white.opacity(0.4)
    /// 白色 白色 0.3
    static let textOpacity3: Color = Color.white.opacity(0.3)
    /// 最浅白色 白色 0.2
    static let textLowest: Color = Color.white.opacity(0.2)
    static let textLowest10: Color = Color.white.opacity(0.1)
    ///  白色 0.7
    static let textOpacity7: Color = Color.white.opacity(0.7)
    /// 按钮文字颜色 常用高亮按钮上的文字 黑色
    static let textHiLightBtn: Color = Color.black
    /// 错误/警告 #FF5449
    static let error: Color = Color(hex: "#FF5449")
    /// 金色  FFAC19
    static let rewardColor: Color = Color(hex: "#FFAC19")
    /// vip字体颜色 #682604
    static let vipTitleColor: Color = Color(hex: "#D6611A")
    /// SeparatorColor #2B3145
    static let separator: Color = Color(hex: "#2B3145")
    /// 占位图 背景颜色
    static let placeholderColor: Color = Color.init(hex: "#2F3449")
    /// 字体高亮点击 4CECE6
    static let textLink: Color = Color(hex: "#4CECE6")
    /// 匹配背景颜色 紫色 160E37
    static let matchBgColor: Color = Color(hex: "#160E37")
    /// 匹配蓝色item背景
    static let matchBlueColor: Color = Color(hex: "#35E7E8")
    static let matchBlueBtnColor: Color = Color(hex: "#00FEFF")
    /// 匹配紫色item背景
    static let matchPurpleColor: Color = Color(hex: "#AB77FF")
    static let matchPurpleBtnColor: Color = Color(hex: "#BD95FF")
    /// 匹配黄色item背景
    static let matchYellowColor: Color = Color(hex: "#FFED4E")
    static let matchYellowBtnColor: Color = Color(hex: "#FDFFA8")
    /// 匹配橙色item背景
    static let matchOrangeColor: Color = Color(hex: "#FF9167")
    static let matchOrangeBtnColor: Color = Color(hex: "#FFB295")
    /// 匹配绿色item背景
    static let matchGreenColor: Color = Color(hex: "#9BE142")
    static let matchGreenBtnColor: Color = Color(hex: "#BBF86D")
    /// 匹配粉色item背景
    static let matchPinkColor: Color = Color(hex: "#FF6B98")
    static let matchPinkBtnColor: Color = Color(hex: "#FF99B8")
    /// 匹配深紫色item背景
    static let matchDarkPurpleColor: Color = Color(hex: "#7280FF")
    
}
