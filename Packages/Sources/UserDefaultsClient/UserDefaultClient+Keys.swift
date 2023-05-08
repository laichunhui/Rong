//
//  UserDefaultClient+Keys.swift
//
//  Created by ErrorErrorError on 12/22/22.
//
//

import Foundation
import SharedModels

public extension UserDefaultsClient.Key {
    static var hasShownOnboarding: UserDefaultsClient.Key<Bool> { .init("hasShownOnboarding") }
    static var hasClearedAllVideos: UserDefaultsClient.Key<Bool> { .init("hasClearedAllVideos") }

    static var searchedItems: UserDefaultsClient.Key<[String]> { .init("searchedItems", defaultValue: []) }

    static var compactEpisodes: UserDefaultsClient.Key<Bool> { .init("compactEpisodes") }
    static var episodesDescendingOrder: UserDefaultsClient.Key<Bool> { .init("episodesDescendingOrder") }

//    static var videoPlayerAudio: UserDefaultsClient
//        .Key<EpisodeLink.Audio> { .init("videoPlayerAudio", defaultValue: .sub) }
    static var videoPlayerSubtitle: UserDefaultsClient.Key<String?> { .init("videoPlayerSubtitle", defaultValue: nil) }
    static var videoPlayerQuality: UserDefaultsClient
        .Key<Source.Quality?> { .init("videoPlayerQuality", defaultValue: .auto) }
}
