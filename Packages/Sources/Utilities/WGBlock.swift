//
//  WGBlock.swift
//  WGKit
//
//  Created by laichunhui on 2021/8/10.
//

import Foundation

public typealias WGVoidBlock = () -> Void
public typealias WGGenericBlock<T> = (T) -> Void


public struct WGVoidBlockWrapper: Equatable {
    var id : String {
        return UUID().uuidString
    }
    public static func == (lhs: WGVoidBlockWrapper, rhs: WGVoidBlockWrapper) -> Bool {
        lhs.id == rhs.id
    }
    
    var block: WGVoidBlock?
    public  init(block: WGVoidBlock?) {
        self.block = block
    }
    public func call() {
        block?()
    }
}

public struct WGGenericBlockWrapper<T>: Equatable {
    var id : String {
        return UUID().uuidString
    }
    public static func == (lhs: WGGenericBlockWrapper, rhs: WGGenericBlockWrapper) -> Bool {
        lhs.id == rhs.id
    }
    
    public var block: WGGenericBlock<T>?
    
    public init(block: WGGenericBlock<T>? ) {
        self.block = block
    }
    public func call(value: T) {
        block?(value)
    }
    
}
