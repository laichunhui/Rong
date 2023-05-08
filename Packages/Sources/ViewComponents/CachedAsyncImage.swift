//
//  SwiftUIView.swift
//
//
//  Created by ErrorErrorError on 2/7/23.
//
//

import ImageDatabaseClient
import SwiftUI

// MARK: - CachedAsyncImagePhase

public enum CachedAsyncImagePhase {
    case empty
    case success(Image)
    case failed(Error)

    public var image: Image? {
        if case let .success(image) = self {
            return image
        }
        return nil
    }

    public var error: Error? {
        if case let .failed(error) = self {
            return error
        }
        return nil
    }
}

// MARK: - CachedAsyncImage

public struct CachedAsyncImage<Content: View>: View {
    @State
    private var phase = CachedAsyncImagePhase.empty
    private let url: URL?
    private let transaction: Transaction
    private let content: (CachedAsyncImagePhase) -> Content
    private var onAverageColorChanged: ((Color?) -> Void)?

    public init(
        url: URL? = nil,
        transaction: Transaction = .init(),
        @ViewBuilder content: @escaping (CachedAsyncImagePhase) -> Content
    ) {
        self.url = url
        self.content = content
        self.transaction = transaction
    }

    public var body: some View {
        content(phase)
            .onAppear {
                fetchImage(url, transaction)
            }
            .onChange(of: url) { newValue in
                fetchImage(newValue, transaction)
            }
    }

    public func onAverageColor(_ callback: ((Color?) -> Void)?) -> Self {
        var copy = self
        copy.onAverageColorChanged = callback
        return copy
    }

    @MainActor
    private func fetchImage(
        _ url: URL?,
        _ transaction: Transaction
    ) {
        guard let url else {
            phase = .empty
            return
        }

        if let cachedImage = ImageDatabase.shared.cachedImage(url) {
            phase = .success(.init(cachedImage))
            onAverageColorChanged?(cachedImage.averageColor)
            return
        }

        Task.detached {
            guard !Task.isCancelled else {
                return
            }

            do {
                let image = try await ImageDatabase.shared.image(url)

                await MainActor.run {
                    withTransaction(transaction) {
                        phase = .success(.init(image))
                    }
                    onAverageColorChanged?(image.averageColor)
                }
            } catch {
                await MainActor.run {
                    withTransaction(transaction) {
                        phase = .failed(error)
                    }
                    onAverageColorChanged?(nil)
                }
            }
        }
    }
}

public extension CachedAsyncImage {
    init<I: View, P: View>(
        url: URL?,
        transaction: Transaction = .init(),
        @ViewBuilder content: @escaping (Image) -> I,
        @ViewBuilder placeholder: @escaping () -> P
    ) where Content == _ConditionalContent<I, P> {
        self.init(url: url, transaction: transaction) { phase in
            if let image = phase.image {
                content(image)
            } else {
                placeholder()
            }
        }
    }
}

// MARK: - CachedAsyncImage_Previews

struct CachedAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        CachedAsyncImage(url: nil) { phase in
            switch phase {
            case .empty:
                EmptyView()
            case let .success(image):
                image
                    .resizable()
                    .scaledToFill()
            case .failed:
                EmptyView()
            }
        }
    }
}
