//
//  ChipView.swift
//  Anime Now! (iOS)
//
//  Created by ErrorErrorError on 9/27/22.
//

import SwiftUI

// MARK: - ChipView

public struct ChipView<Accessory: View>: View {
    let text: String
    var accessory: (() -> Accessory)?
    var backgroundColor: Color? = .gray
    var opacity = 0.25

    public init(
        text: String,
        accessory: (() -> Accessory)? = nil
    ) {
        self.text = text
        self.accessory = accessory
    }

    public var body: some View {
        HStack(
            alignment: .center,
            spacing: 8
        ) {
            accessory?()
            Text(text)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(backgroundColor?.opacity(opacity))
        .clipShape(Capsule())
    }
}

public extension ChipView {
    func chipBackgroundColor(_ color: Color?) -> Self {
        var view = self
        view.backgroundColor = color
        return view
    }

    func chipOpacity(_ opacity: Double) -> Self {
        var view = self
        view.opacity = opacity
        return view
    }
}

public extension ChipView where Accessory == EmptyView {
    init(text: String) {
        self.init(text: text, accessory: nil)
    }
}

// MARK: - ChipView_Previews

struct ChipView_Previews: PreviewProvider {
    static var previews: some View {
        ChipView(text: "2021") {
            Image(systemName: "star.fill")
        }
        .preferredColorScheme(.dark)
    }
}
