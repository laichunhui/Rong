//
//  ContextButton.swift
//
//
//  Created by ErrorErrorError on 1/8/23.
//
//

import Foundation
import ImageDatabaseClient
import SwiftUI

#if os(macOS)
import AppKit
#endif

private let iconSize = CGSize(width: 18, height: 18)

// MARK: - ContextButtonItem

public struct ContextButtonItem: Equatable {
    let name: String
    let image: URL?

    public init(
        name: String,
        image: URL? = nil
    ) {
        self.name = name
        self.image = image
    }
}

// MARK: - ContextButton

public struct ContextButton<Label: View>: View {
    #if os(macOS)
    @StateObject
    private var menu = MenuObservable()
    #endif

    let items: [ContextButtonItem]
    let label: () -> Label
    let action: ((String) -> Void)?

    public init(
        items: [ContextButtonItem],
        action: ((String) -> Void)? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.items = items
        self.label = label
        self.action = action
    }

    public var body: some View {
        #if os(iOS)
        Menu {
            ForEach(items, id: \.name) { item in
                Button {
                    action?(item.name)
                } label: {
                    HStack {
                        Text(item.name)
                        CachedAsyncImage(url: item.image) { image in
                            image.resizable()
                                .interpolation(.medium)
                        } placeholder: {
                            EmptyView()
                        }
                        .scaledToFit()
                        .frame(width: iconSize.width, height: iconSize.height)
                    }
                }
            }
        } label: {
            label()
        }
        .foregroundColor(.white)
        #else
        label()
            .background(
                GeometryReader { geometryProxy in
                    Color.clear
                        .onChange(of: geometryProxy.frame(in: .global)) { newValue in
                            menu.frame = newValue
                        }
                        .onAppear {
                            menu.frame = geometryProxy.frame(in: .global)
                        }
                }
            )
            .onTapGesture {
                menu.showMenu.toggle()
            }
            .onChange(of: items) { items in
                menu.populateMenu(items: items)
            }
            .onAppear {
                menu.callback = action
                menu.populateMenu(items: items)
            }
        #endif
    }
}

#if os(macOS)

private class MenuObservable: NSObject, ObservableObject, NSMenuDelegate {
    @Published
    var showMenu = false {
        didSet { showMenuPopup(showMenu) }
    }

    var frame: CGRect = .zero
    var callback: ((String) -> Void)?

    private let menu = NSMenu()

    override init() {
        super.init()
        menu.delegate = self
    }

    func populateMenu(items: [ContextButtonItem]) {
        menu.removeAllItems()

        for item in items {
            let menuItem = NSMenuItem(title: item.name, action: #selector(handlePress), keyEquivalent: "")
            menuItem.representedObject = item
            menuItem.target = self
            if let url = item.image, let image = ImageDatabase.shared.cachedImage(url) {
                menuItem.image = image
            }
            menuItem.image?.size = iconSize
            menu.addItem(menuItem)
        }
    }

    private func showMenuPopup(_ show: Bool) {
        if show {
            let windowPosition = NSApplication.shared.mainWindow?.frame ?? .zero
            let point = windowPosition.origin.applying(
                .init(
                    translationX: frame.origin.x,
                    y: windowPosition.size.height - frame.origin.y - frame.height
                )
            )
            menu.popUp(
                positioning: nil,
                at: point,
                in: nil
            )
        }
    }

    func menuDidClose(_: NSMenu) {
        showMenu = false
    }

    @objc
    func handlePress(_ sender: Any?) {
        guard let menuItem = sender as? NSMenuItem else {
            return
        }

        guard let item = menuItem.representedObject as? ContextButtonItem else {
            return
        }

        DispatchQueue.main.async { [weak self] in
            self?.callback?(item.name)
        }
    }
}

#endif
