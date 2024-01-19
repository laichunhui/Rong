//
//  File.swift
//  
//
//  Created by JerryLai on 2023/12/15.
//

import Foundation
import SwiftUI

public extension View {
    func alertModify(
        spaceColor: Color = Color.black.opacity(0.8),
        dismiss: WGVoidBlock? = nil
    ) -> some View {
        modifier(AlertFilm(spaceColor: spaceColor, dismiss: dismiss))
    }
}

struct AlertFilm: ViewModifier {
    @State private var progress: CGFloat = 0
    var dismiss: WGVoidBlock?
    var spaceColor: Color
    
    init(spaceColor: Color, dismiss: WGVoidBlock? = nil) {
        self.dismiss = dismiss
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
                    withAnimation(.easeInOut(duration: 0.5)) {
                        self.progress = 1.0
                    }
                }
        
            content
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
