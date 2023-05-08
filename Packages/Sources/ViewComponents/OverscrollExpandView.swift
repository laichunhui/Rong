//
//  OverscrollExpandView.swift
//
//
//  Created by ErrorErrorError on 2/8/23.
//
//

import SwiftUI

// MARK: - OverscrollExpandView

struct OverscrollExpandView: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { reader in
            let minY = reader.frame(in: .global).minY
            content
                .frame(
                    width: reader.size.width,
                    height: reader.size.height + (minY > 0 ? minY : 0),
                    alignment: .top
                )
                .contentShape(Rectangle())
                .clipped()
                .offset(y: minY < 0 ? 0 : -minY)
        }
    }
}

public extension View {
    @ViewBuilder
    func overscrollExpandView(_ active: Bool = true) -> some View {
        if active {
            modifier(OverscrollExpandView())
        } else {
            self
        }
    }
}
