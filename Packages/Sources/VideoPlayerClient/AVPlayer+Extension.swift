//  AVPlayer+Extension.swift
//
//
//  Created by ErrorErrorError on 12/24/22.
//
//

import AVFoundation
import Foundation

// MARK: AVPlayerItem + Extension

public extension AVPlayerItem {
    var bufferProgress: Double {
        totalDuration > 0 ? currentBufferDuration / totalDuration : 0
    }

    var currentBufferDuration: Double {
        loadedTimeRanges.first?.timeRangeValue.end.seconds ?? 0
    }

    var currentDuration: Double {
        currentTime().seconds
    }

    var playProgress: Double {
        totalDuration > 0 ? currentDuration / totalDuration : 0
    }

    var totalDuration: Double {
        asset.duration.seconds
    }
}

// MARK: AVPlayer + Extension

public extension AVPlayer {
    var bufferProgress: Double {
        currentItem?.bufferProgress ?? 0
    }

    var currentBufferDuration: Double {
        currentItem?.currentBufferDuration ?? 0
    }

    var currentDuration: Double {
        currentItem?.currentDuration ?? 0
    }

    var playProgress: Double {
        currentItem?.playProgress ?? 0
    }

    var totalDuration: Double {
        currentItem?.totalDuration ?? 0
    }

    convenience init(asset: AVURLAsset) {
        self.init(playerItem: AVPlayerItem(asset: asset))
    }
}

// MARK: - AVPlayerItem.Status + CustomStringConvertible, CustomDebugStringConvertible

extension AVPlayerItem.Status: CustomStringConvertible, CustomDebugStringConvertible {
    public var debugDescription: String {
        description
    }

    public var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .readyToPlay:
            return "readyToPlay"
        case .failed:
            return "failed"
        @unknown default:
            return "default-unknown"
        }
    }
}

// MARK: - AVPlayer.Status + CustomStringConvertible, CustomDebugStringConvertible

extension AVPlayer.Status: CustomStringConvertible, CustomDebugStringConvertible {
    public var debugDescription: String {
        description
    }

    public var description: String {
        switch self {
        case .unknown:
            return "unknown"
        case .readyToPlay:
            return "readyToPlay"
        case .failed:
            return "failed"
        @unknown default:
            return "default-unknown"
        }
    }
}

// MARK: - AVPlayer.TimeControlStatus + CustomStringConvertible, CustomDebugStringConvertible

extension AVPlayer.TimeControlStatus: CustomStringConvertible, CustomDebugStringConvertible {
    public var debugDescription: String {
        description
    }

    public var description: String {
        switch self {
        case .paused:
            return "paused"
        case .waitingToPlayAtSpecifiedRate:
            return "waitingToPlayAtSpecifiedRate"
        case .playing:
            return "playing"
        @unknown default:
            return "default-unknown"
        }
    }
}
