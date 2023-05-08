//
//  File.swift
//
//
//  Created by ErrorErrorError on 2/10/23.
//
//

import Foundation

public extension VideoPlayerClient {
    static var testValue: VideoPlayerClient = .init {
        .init { continuation in
            continuation.yield(.loading)
            continuation.yield(.loaded(duration: 5_000))
            continuation.yield(.playback(.buffering))
            continuation.yield(.playback(.playing))
            continuation.yield(.playback(.paused))
        }
    } progress: {
        .finished
    } execute: { _ in
    } player: {
        .init()
    }
}
