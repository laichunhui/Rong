//
//  File.swift
//  
//
//  Created by laichunhui on 2023/5/5.
//

import SwiftUI
import ComposableArchitecture
import Home
import Chat
import Chart
import Setting
import DownloaderClient

// MARK: - AppReducer
public struct AppReducer: Reducer{
    public init() {}

    public enum Route: String, CaseIterable {
        case home
        case chart
        case chat
        case setting

        public var isIconSystemImage: Bool {
            return true
        }

        public var icon: String {
            switch self {
            case .home:
                return "house"
            case .chart:
                return "chart.pie"
            case .chat:
                return "bubble.left"
            case .setting:
                return "gearshape"
            }
        }

        public var selectedIcon: String {
            switch self {
            case .home:
                return "house.fill"
            case .chart:
                return "chart.pie.fill"
            case .chat:
                return "bubble.left.fill"
            case .setting:
                return "gearshape.fill"
            }
        }

        public var title: String {
            .init(rawValue.prefix(1).capitalized + rawValue.dropFirst())
        }

        public static var allCases: [AppReducer.Route] {
            #if os(macOS)
            return [.home, .chart, .chat]
            #else
            return [.home, .chart, .chat, .setting]
            #endif
        }
    }

    public struct State: Equatable {
        @BindingState
        public var route = Route.home

        public var home = HomeReducer.State()
        public var chart = ChartReducer.State()
        public var chat = ChatReducer.State()
        public var setting = SettingReducer.State()

        public var totalDownloadsCount = 0
        public init() {}
    }

    public enum Action: BindableAction {
        case onAppear
        case appDelegate(AppDelegateReducer.Action)
        case home(HomeReducer.Action)
        case chart(ChartReducer.Action)
        case chat(ChatReducer.Action)
        case setting(SettingReducer.Action)
        case binding(BindingAction<State>)
    }

//    @Dependency(\.anilistClient)
//    var anilistClient
//    @Dependency(\.apiClient)
//    var apiClient
//    @Dependency(\.mainQueue)
//    var mainQueue
//    @Dependency(\.discordClient)
//    var discordClient
//    @Dependency(\.databaseClient)
//    var databaseClient
//    @Dependency(\.downloaderClient)
//    var downloaderClient
//    @Dependency(\.kitsuClient)
//    var kitsuClient
//    @Dependency(\.myanimelistClient)
//    var myanimelistClient
//    @Dependency(\.videoPlayerClient)
//    var videoPlayerClient

    public var body: some Reducer<State, Action> {
        Scope(state: \.setting.userSettings, action: /Action.appDelegate) {
            AppDelegateReducer()
        }

        Scope(state: \.home, action: /Action.home) {
            HomeReducer()
        }

        Scope(state: \.chart, action: /Action.chart) {
            ChartReducer()
        }

        Scope(state: \.chat, action: /Action.chat) {
            ChatReducer()
        }

        Scope(state: \.setting, action: /Action.setting) {
           SettingReducer()
        }

        BindingReducer()

//        Reduce(core)
//            .ifLet(\.videoPlayer, action: /Action.videoPlayer) {
//                AnimePlayerReducer()
//            }
//            .ifLet(\.animeDetail, action: /Action.animeDetail) {
//                AnimeDetailReducer()
//            }
//            .ifLet(\.modalOverlay, action: /Action.modalOverlay) {
//                ModalOverlayReducer()
//            }
//
//        Reduce(discordRichPresence)
    }
}

extension AppReducer {
    // swiftlint:disable cyclomatic_complexity function_body_length
    func core(state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .appDelegate(.appDidEnterBackground):
            break
        case .appDelegate(.appWillTerminate):
            return .run { send in
                await send(.appDelegate(.appDidEnterBackground))
                #if os(macOS)
                // for macOS, save everything before fully closing app.
                try? await mainQueue.sleep(for: 0.5)
                await NSApp.reply(toApplicationShouldTerminate: true)
                #endif
            }
        case .appDelegate(.appDidFinishLaunching):
           break
        default:
            break
        }
        return .none
    }
}
