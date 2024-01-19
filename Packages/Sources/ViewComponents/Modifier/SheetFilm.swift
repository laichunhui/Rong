//
//  File.swift
//  
//
//  Created by JerryLai on 2023/12/15.
//

import Foundation
import SwiftUI

public extension View {
    func sheetModify(
        contentheight: CGFloat = kScreenHeight * 0.7,
        spaceColor: Color = Color.black.opacity(0.6),
        dismiss: WGVoidBlock? = nil
    ) -> some View {
        modifier(SheetFilm(contentheight: contentheight, spaceColor: spaceColor, dismiss: dismiss))
    }
}

struct SheetFilm: ViewModifier {
    @State private var progress: CGFloat = 0
    var dismiss: WGVoidBlock?
    var contentheight: CGFloat
    var spaceColor: Color
    
    init(contentheight: CGFloat, spaceColor: Color, dismiss: WGVoidBlock? = nil) {
        self.dismiss = dismiss
        self.contentheight = contentheight
        self.spaceColor = spaceColor
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            spaceColor.ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    dismissAction()
                }
                .opacity(progress)
                .onAppear {
                    withAnimation(.linear(duration: 1)) {
                        self.progress = 1.0
                    }
                }
            VStack {
                Spacer()
                content
                    .frame(height: contentheight)
            }
            .ignoresSafeArea(.container, edges: .bottom)
        }
        .accessibilityElement(children: .contain)
    }
    
    func dismissAction() {
        let duration = 0.25
        Task {
            await withCheckedContinuation { continuation in
                withAnimation(.linear(duration: duration)) {
                    self.progress = 0
                }

                DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                    continuation.resume()
                    dismiss?()
                }
            }
        }
    }
}


