//  VideoPlayerClient.swift
//  VideoPlayerClient
//
//  Created by ErrorErrorError on 12/23/22.
//

import AVFoundation
import ComposableArchitecture
import Foundation
import SharedModels

// MARK: - VideoPlayerClient

public struct VideoPlayerClient {
    public let status: () -> AsyncStream<Status>
    public let progress: () -> AsyncStream<Double>
    public let execute: (Action) async -> Void
    public let player: () -> AVPlayer
}

public extension VideoPlayerClient {
    typealias VideoGravity = AVLayerVideoGravity

    enum Status: Equatable {
        /// Idle
        case idle

        /// From the first load to get the first frame of the video
        case loading

        /// Player can start playing
        case loaded(duration: Double)

        /// Playback States
        case playback(Playback)

        /// Finished Playing
        case finished

        /// An error occurred and cannot continue playing
        case error
    }

    enum Playback: Equatable, CaseIterable {
        case buffering
        case playing
        case paused
    }

    enum Action: Equatable {
        /// Play Item
        /// Thos requires url and metadata and optional referer (if the video requires it)

        case play(Payload)

        /// Resume  Video
        case resume

        /// Pause Video
        case pause

        /// Change Progress
        case seekTo(Double)

        /// Change Volume
        case volume(Double)

        /// Clear Video Player
        case clear
    }

    struct Payload: Equatable {
        let source: Source
        let metadata: Metadata
        let subtitles: [SourcesOptions.Subtitle]

        // TODO: Add subtitles to parse
        public init(
            source: Source,
            metadata: VideoPlayerClient.Metadata,
            subtitles: [SourcesOptions.Subtitle] = []
        ) {
            self.source = source
            self.metadata = metadata
            self.subtitles = subtitles
        }
    }

    struct Metadata: Equatable {
        let videoTitle: String
        let videoAuthor: String
        var thumbnail: URL?

        public init(
            videoTitle: String,
            videoAuthor: String,
            thumbnail: URL? = nil
        ) {
            self.videoTitle = videoTitle
            self.videoAuthor = videoAuthor
            self.thumbnail = thumbnail
        }
    }
}

// MARK: Sendable

extension VideoPlayerClient: @unchecked
Sendable {}

// MARK: DependencyKey

extension VideoPlayerClient: DependencyKey {}

public extension DependencyValues {
    var videoPlayerClient: VideoPlayerClient {
        get { self[VideoPlayerClient.self] }
        set { self[VideoPlayerClient.self] = newValue }
    }
}
