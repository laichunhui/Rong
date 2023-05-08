//  View+Keyboard.swift
//  Anime Now! (macOS)
//
//  Created by ErrorErrorError on 10/29/22.
//
//

#if os(macOS)
import AppKit
import SwiftUI

public extension View {
    func onKeyDown(
        _ onKeyDown: @escaping (KeyCommandsHandlerModifier.KeyCommands) -> Void
    ) -> some View {
        modifier(KeyCommandsHandlerModifier(onKeyDown: onKeyDown))
    }
}

public struct KeyCommandsHandlerModifier: ViewModifier {
    public enum KeyCommands: UInt16 {
        case spaceBar = 49
        case leftArrow = 123
        case rightArrow = 124
        case downArrow = 125
        case upArrow = 126
    }

    var onKeyDown: (KeyCommands) -> Void

    public func body(content: Content) -> some View {
        content.background(
            Representable(onKeyDown: onKeyDown)
        )
    }
}

extension KeyCommandsHandlerModifier {
    struct Representable: NSViewRepresentable {
        var onKeyDown: (KeyCommands) -> Void

        func makeNSView(context _: Context) -> NSView {
            let view = EventView(onKeyDown)
            return view
        }

        func updateNSView(_: NSView, context _: Context) {}
    }

    class EventView: NSView {
        var onKeyDown: (KeyCommands) -> Void

        var observer: Any?

        init(
            _ onKeyDown: @escaping (KeyCommands) -> Void
        ) {
            self.onKeyDown = onKeyDown
            super.init(frame: .zero)

            self.observer = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event -> NSEvent? in
                guard let keyDown = KeyCommands(rawValue: event.keyCode) else {
                    return event
                }
                DispatchQueue.main.async { [weak self] in self?.onKeyDown(keyDown) }
                return nil
            }
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        deinit {
            guard let observer else {
                return
            }

            NSEvent.removeMonitor(observer)
        }
    }
}
#endif
