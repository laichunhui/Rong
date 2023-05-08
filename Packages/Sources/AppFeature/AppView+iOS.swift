//
//  File.swift
//  
//
//  Created by laichunhui on 2023/5/6.
//

#if os(iOS)
import ComposableArchitecture
import SwiftUI
import Utilities
import ViewComponents

extension AppView {
    @ViewBuilder
    var tabBar: some View {
        if DeviceUtil.isPad {
            iPadTabBar
        } else {
            iosTabBar
        }
    }

    @ViewBuilder
    private var iosTabBar: some View {
        WithViewStore(
            store,
            observe: \.route
        ) { viewStore in
            HStack {
                ForEach(
                    AppReducer.Route.allCases,
                    id: \.self
                ) { item in
                    VStack(spacing: 6) {
                        Group {
                            if item.isIconSystemImage {
                                Image(systemName: "\(item == viewStore.state ? item.selectedIcon : item.icon)")
                            } else {
                                Image("\(item == viewStore.state ? item.selectedIcon : item.icon)")
                            }
                        }
                        .frame(width: 26, height: 26)
//                        .overlay(
//                            WithViewStore(
//                                store,
//                                observe: \.totalDownloadsCount
//                            ) { countState in
//                                if item == .downloads, countState.state > 0 {
//                                    Text("\(countState.state)")
//                                        .font(.footnote.bold())
//                                        .foregroundColor(.black)
//                                        .padding(4)
//                                        .background(Color.white)
//                                        .clipShape(Circle())
//                                        .frame(
//                                            maxWidth: .infinity,
//                                            maxHeight: .infinity,
//                                            alignment: .topTrailing
//                                        )
//                                        .animation(.linear, value: countState.state)
//                                        .offset(x: 4, y: -4)
//                                }
//                            }
//                        )

                        Text(item.title)
                            .font(.system(size: 10))
                    }
                    .foregroundColor(
                        item == viewStore.state ? Color.white : Color.gray
                    )
                    .font(.system(size: 18).weight(.semibold))
                    .frame(maxWidth: .infinity)
                    .frame(alignment: .center)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewStore.send(
                            .set(\.$route, item),
                            animation: .linear(duration: 0.15)
                        )
                    }
                }
            }
            .padding([.horizontal, .top], 12)
            .padding(.bottom, DeviceUtil.hasBottomIndicator ? 0 : 12)
        }
        .frame(maxWidth: .infinity)
        .background(
            BlurView(.systemThinMaterialDark)
                .edgesIgnoringSafeArea(.bottom)
        )
    }

    @ViewBuilder
    private var iPadTabBar: some View {
        WithViewStore(
            store,
            observe: \.route
        ) { viewStore in
            HStack(spacing: 0) {
                ForEach(
                    AppReducer.Route.allCases,
                    id: \.self
                ) { item in
                    Group {
                        if item.isIconSystemImage {
                            Image(
                                systemName: "\(item == viewStore.state ? item.selectedIcon : item.icon)"
                            )
                        } else {
                            Image("\(item == viewStore.state ? item.selectedIcon : item.icon)")
                        }
                    }
                    .foregroundColor(
                        item == viewStore.state ? Color.white : Color.gray
                    )
                    .font(.system(size: 20).weight(.semibold))
                    .frame(
                        width: 48,
                        height: 48,
                        alignment: .center
                    )
//                    .overlay(
//                        WithViewStore(
//                            store,
//                            observe: \.totalDownloadsCount
//                        ) { countState in
//                            if item == .downloads, countState.state > 0 {
//                                Text("\(countState.state)")
//                                    .font(.footnote.bold())
//                                    .foregroundColor(.black)
//                                    .padding(4)
//                                    .background(Color.white)
//                                    .clipShape(Circle())
//                                    .frame(
//                                        maxWidth: .infinity,
//                                        maxHeight: .infinity,
//                                        alignment: .topTrailing
//                                    )
//                                    .padding(8)
//                                    .animation(.linear, value: countState.state)
//                            }
//                        }
//                    )
                    .contentShape(Rectangle())
                    .onTapGesture {
                        viewStore.send(
                            .set(\.$route, item),
                            animation: .linear(duration: 0.15)
                        )
                    }
                }
            }
            .padding(.horizontal, 12)
            .background(Color(white: 0.08))
            .clipShape(Capsule())
            .padding(.bottom, DeviceUtil.hasBottomIndicator ? 0 : 24)
        }
    }
}
#endif
