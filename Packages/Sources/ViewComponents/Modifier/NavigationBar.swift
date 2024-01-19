//
//  File.swift
//  
//
//  Created by JerryLai on 2023/7/31.
//

import SwiftUI
import Utilities
import SFSafeSymbols

extension View {
    public func customNavigation(isShow: Binding<Bool> = .constant(true), color: Color = Color.secondPageBG, autoBack: Bool = true, title: String, trailing: some View = Spacer(), backBlock: WGVoidBlock? = nil) -> some View {
        self.navigationBarHidden(true)
            .modifier(WGNavigationBar(isShow: isShow, color: color, autoBack: autoBack, title: title, trailing: trailing, backBlock: backBlock))
    }
    
    public func pureNavigation(color: Color = .white, title: String = "", backBlock: WGVoidBlock? = nil) -> some View {
        self.navigationBarHidden(true)
            .navigationBarBackButtonHidden()
            .modifier(WGPureNavigationBar(isShow: .constant(true), color: color, autoBack: backBlock == nil, title: title, trailing: Spacer(), backBlock: backBlock))
    }
}

public struct WGNavigationBar: ViewModifier {
    public var title: String
    public var backBlock: WGVoidBlock?
    var trailing: AnyView
    @Binding var isShow: Bool
    var color: Color
    var autoBack: Bool
    
    @Environment(\.layoutDirection) var direction
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    public init(isShow: Binding<Bool>, color: Color = WGColor.secondPageBG, autoBack: Bool, title: String, trailing: some View, backBlock: WGVoidBlock?) {
        self.title = title
        self.backBlock = backBlock
        self.trailing = trailing.asAnyView()
        self._isShow = isShow
        self.color = color
        self.autoBack = autoBack
    }
    
    public func body(content: Content) -> some View {
        ZStack {
            color
                .ignoresSafeArea()
            VStack(spacing: 0) {
                if isShow {
                    HStack(alignment: .center) {
                        Spacer().overlay(
                            HStack {
                                Button(action: {
                                    self.backBlock?()
                                    if autoBack {
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                }) {
                                    HStack {
                                        Image.init(systemSymbol: SFSymbol.chevronBackward)
//                                        fontIcon(.back, size: 24, color: WGColor.textMain)
//                                            .rotationEffect(.degrees(direction == .leftToRight ? 0 : 180))
                                        Spacer()
                                    }.frame(width: 32, height: 32)
                                }
                                Spacer()
                            }
                        )
                        Text.H4(title)
                            .foregroundColor(.white)
                        Spacer().overlay(
                            HStack {
                                Spacer()
                                trailing
                            }
                        )
                    }
                    .frame(height: UIView.navBarHeight)
                    .padding(.horizontal, 16)
                }
                content
            }
        }
    }
}


public struct WGPureNavigationBar: ViewModifier {
    public var title: String
    public var backBlock: WGVoidBlock?
    var trailing: AnyView
    @Binding var isShow: Bool
    var color: Color
    var autoBack: Bool
    
    @Environment(\.layoutDirection) var direction
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    public init(isShow: Binding<Bool>, color: Color = WGColor.secondPageBG, autoBack: Bool, title: String, trailing: some View, backBlock: WGVoidBlock?) {
        self.title = title
        self.backBlock = backBlock
        self.trailing = trailing.asAnyView()
        self._isShow = isShow
        self.color = color
        self.autoBack = autoBack
    }
    
    public func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            
            if isShow {
                HStack(alignment: .center) {
                    Spacer().overlay(
                        HStack {
                            Button(action: {
                                self.backBlock?()
                                if autoBack {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            }) {
                                HStack {
                                    Image.init(systemSymbol: SFSymbol.chevronBackward)
                                        .rotationEffect(.degrees(direction == .leftToRight ? 0 : 180))
                                    Spacer()
                                }.frame(width: 32, height: 44)
                            }
                            Spacer()
                        }
                    )
                    Text.H4(title)
                        .foregroundColor(.white)
                    Spacer().overlay(
                        HStack {
                            Spacer()
                            trailing
                        }
                    )
                }
                .frame(height: UIView.navBarHeight)
                .padding(.horizontal, 16)
                .padding(.top, UIView.safeTop)
            }
        }
    }
}
