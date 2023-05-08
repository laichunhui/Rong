//
//  ImageSize.swift
//  Anime Now! (iOS)
//
//  Created by ErrorErrorError on 9/21/22.
//

import Foundation

// MARK: - ImageSize

public enum ImageSize: Codable, Hashable, Comparable {
    case tiny(URL)
    case small(URL)
    case medium(URL)
    case large(URL)
    case original(URL)

    public var link: URL {
        switch self {
        case let .tiny(url):
            return url
        case let .small(url):
            return url
        case let .medium(url):
            return url
        case let .large(url):
            return url
        case let .original(url):
            return url
        }
    }

    public static func < (lhs: ImageSize, rhs: ImageSize) -> Bool {
        if case .tiny = lhs {
            return true
        } else if case .small = lhs {
            if case .tiny = rhs {
                return false
            } else {
                return true
            }
        } else if case .medium = lhs {
            if case .tiny = rhs {
                return false
            } else if case .small = rhs {
                return false
            } else {
                return true
            }
        } else if case .large = lhs {
            if case .original = rhs {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }

    var description: String {
        switch self {
        case .tiny:
            return "tiny"
        case .small:
            return "small"
        case .medium:
            return "medium"
        case .large:
            return "large"
        case .original:
            return "original"
        }
    }
}

public extension [ImageSize] {
    var smallest: ImageSize? {
        self.min { $0 < $1 }
    }

    var largest: ImageSize? {
        self.max { $0 < $1 }
    }
}
