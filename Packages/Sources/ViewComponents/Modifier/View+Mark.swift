//
//  File.swift
//  
//
//  Created by JerryLai on 2023/7/28.
//

import SwiftUI
import Utilities

public struct BottomSepline: ViewModifier {
    public var color: Color
    var padding: CGFloat
    public init(color: Color = Color.separator, padding: CGFloat = 8) {
        self.color = color
        self.padding = padding
    }
    
    public func body(content: Content) -> some View {
        VStack(spacing: 0) {
            content
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(color)
                .padding(.horizontal, padding)
        }
    }
}
