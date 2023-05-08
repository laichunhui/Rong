//
//  File.swift
//
//
//  Created by ErrorErrorError on 2/7/23.
//
//

import SwiftUI

// MARK: - ArrowIndicatorsModifier

public struct ArrowIndicatorsModifier: ViewModifier {
    let previous: () -> Void
    let next: () -> Void

    var leftDisabled = false
    var rightDisabled = false

    @State
    private var hovering = false

    public init(
        previous: @escaping () -> Void,
        next: @escaping () -> Void
    ) {
        self.previous = previous
        self.next = next
    }

    public func body(content: Content) -> some View {
        HStack {
            buildArrow("chevron.compact.left") {
                withAnimation {
                    previous()
                }
            }
            .disabled(leftDisabled)

            content
                .clipped()
                .contentShape(Rectangle())

            buildArrow("chevron.compact.right") {
                withAnimation {
                    next()
                }
            }
            .disabled(rightDisabled)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.horizontal)
        .onHover { isHovering in
            withAnimation {
                hovering = isHovering
            }
        }
    }

    @ViewBuilder
    private func buildArrow(
        _ systemName: String,
        action: @escaping () -> Void
    ) -> some View {
        Button {
            action()
        } label: {
            Image(systemName: systemName)
                .font(.system(size: 32, weight: .regular))
                .frame(maxHeight: .infinity)
                .padding(8)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .opacity(hovering ? 1.0 : 0)
        .foregroundColor(.init(white: 1.0))
    }

    func leftDisabled(_ disabled: Bool) -> ArrowIndicatorsModifier {
        var copy = self
        copy.leftDisabled = disabled
        return copy
    }

    func rightDisabled(_ disabled: Bool) -> ArrowIndicatorsModifier {
        var copy = self
        copy.rightDisabled = disabled
        return copy
    }
}

public extension View {
    func arrowIndicators(
        _ position: Binding<Int>,
        count: Int
    ) -> some View {
        modifier(
            ArrowIndicatorsModifier(
                previous: {
                    position.wrappedValue -= 1
                }, next: {
                    position.wrappedValue += 1
                }
            )
            .leftDisabled(position.wrappedValue <= 0)
            .rightDisabled(position.wrappedValue >= count - 1)
        )
    }

    func arrowIndicators<I>(
        _ range: Binding<Range<I>>,
        _ maxBounds: Range<I>,
        shiftBy count: I
    ) -> some View where I: AdditiveArithmetic {
        modifier(
            ArrowIndicatorsModifier {
                range.wrappedValue = range.wrappedValue.shiftLeft(by: count, maxBounds: maxBounds)
            } next: {
                range.wrappedValue = range.wrappedValue.shiftRight(by: count, maxBounds: maxBounds)
            }
            .leftDisabled(maxBounds.lowerBound >= range.wrappedValue.lowerBound)
            .rightDisabled(maxBounds.upperBound <= range.wrappedValue.upperBound)
        )
    }
}

extension Range where Bound: AdditiveArithmetic {
    func shiftLeft(by count: Bound, maxBounds: Range<Bound>) -> Range<Bound> {
        if lowerBound - count >= maxBounds.lowerBound {
            return (lowerBound - count)..<(upperBound - count)
        }
        return self
    }

    func shiftRight(by count: Bound, maxBounds: Range<Bound>) -> Range<Bound> {
        if upperBound + count <= maxBounds.upperBound {
            return (lowerBound + count)..<(upperBound + count)
        }
        return self
    }
}
