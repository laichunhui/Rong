//
//  File.swift
//
//
//  Created by ErrorErrorError on 2/9/23.
//
//

import Foundation
import SwiftUI

// MARK: - ImageDatabase

@globalActor
public actor ImageDatabase: GlobalActor {
    public static var shared = ImageDatabase()

    private let cache: URLCache = {
        let cachesURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let diskCacheURL = cachesURL.appendingPathComponent("ImageCaches", conformingTo: .directory)
        return .init(
            memoryCapacity: 0,
            diskCapacity: 1_024 * 1_024 * 1_024,
            directory: diskCacheURL
        )
    }()

    private lazy var session: URLSession = {
        let config = URLSessionConfiguration.default
        config.urlCache = cache
        return .init(configuration: config)
    }()

    private let cachedImages = NSCache<NSString, PlatformImage>()

    public func image(_ url: URL) async throws -> PlatformImage {
        try await image(.init(url: url))
    }

    public func image(_ request: URLRequest) async throws -> PlatformImage {
        // Check an image is already in memory

        if let cached = cachedImages.object(forKey: request.id as NSString) {
            return cached
        }

        // Check if it's in disk

        if let response = cache.cachedResponse(for: request) {
            if let image = PlatformImage(data: response.data) {
                cachedImages.setObject(image, forKey: request.id as NSString)
                return image
            } else {
                throw "Malformed image data response for: \(request.url?.absoluteString ?? "Unknown")"
            }
        }

        // Download image

        let (data, response) = try await session.data(for: request)
        guard let image = PlatformImage(data: data) else {
            throw "Image data invalid for \(request.url?.absoluteString ?? "Unknown")"
        }
        cache.storeCachedResponse(.init(response: response, data: data), for: request)
        cachedImages.setObject(image, forKey: request.id as NSString)
        return image
    }

    public nonisolated func cachedImage(_ request: URLRequest) -> PlatformImage? {
        cachedImages.object(forKey: request.id as NSString)
    }

    public nonisolated func cachedImage(_ url: URL) -> PlatformImage? {
        cachedImage(.init(url: url))
    }

    public nonisolated func diskUsage() -> Int {
        cache.currentDiskUsage
    }

    public nonisolated func maxDiskCapacity() -> Int {
        cache.diskCapacity
    }

    public func reset() {
        cache.removeAllCachedResponses()
        cachedImages.removeAllObjects()
    }
}

// MARK: - NSCache + Sendable

extension NSCache: @unchecked
Sendable {}

// MARK: - URLRequest + Identifiable

extension URLRequest: Identifiable {
    public var id: String { "\(hashValue)" }
}

// MARK: - String + Error

extension String: Error {}

#if canImport(AppKit)
public typealias PlatformImage = NSImage
#else
public typealias PlatformImage = UIImage
#endif

public extension Image {
    init(_ platform: PlatformImage) {
        #if canImport(UIKit)
        self.init(uiImage: platform)
        #else
        self.init(nsImage: platform)
        #endif
    }
}

public extension PlatformImage {
    var averageColor: Color? {
        #if os(macOS)
        var rect = NSRect(origin: .zero, size: size)
        guard let cgImage = cgImage(forProposedRect: &rect, context: .current, hints: nil) else {
            return nil
        }
        let inputImage = CIImage(cgImage: cgImage)
        #else
        guard let inputImage = CIImage(image: self) else {
            return nil
        }
        #endif

        let extentVector = CIVector(
            x: inputImage.extent.origin.x,
            y: inputImage.extent.origin.y,
            z: inputImage.extent.size.width,
            w: inputImage.extent.size.height
        )

        guard let filter = CIFilter(
            name: "CIAreaAverage",
            parameters: [
                kCIInputImageKey: inputImage,
                kCIInputExtentKey: extentVector
            ]
        ) else {
            return nil
        }

        guard let outputImage = filter.outputImage else {
            return nil
        }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull as Any])
        context.render(
            outputImage,
            toBitmap: &bitmap,
            rowBytes: 4,
            bounds: .init(x: 0, y: 0, width: 1, height: 1),
            format: .RGBA8,
            colorSpace: nil
        )

        return .init(
            .sRGB,
            red: CGFloat(bitmap[0]) / 255,
            green: CGFloat(bitmap[1]) / 255,
            blue: CGFloat(bitmap[2]) / 255,
            opacity: CGFloat(bitmap[3]) / 255
        )
    }
}
