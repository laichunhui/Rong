//
//  UserDefaultsClient+Live.swift
//  Anime Now!
//
//  Created by ErrorErrorError on 9/14/22.
//

import ComposableArchitecture
import Foundation

extension UserDefaultsClient {
    static let live: Self = {
        let userDefaults = UserDefaults.standard

        return Self(
            dataForKey: { userDefaults.data(forKey: $0) },
            boolForKey: { userDefaults.bool(forKey: $0) },
            doubleForKey: { userDefaults.double(forKey: $0) },
            intForKey: { userDefaults.integer(forKey: $0) },
            setBool: { key, value in
                Task {
                    userDefaults.set(value, forKey: key)
                }
            },
            setInt: { key, value in
                Task {
                    userDefaults.set(value, forKey: key)
                }
            },
            setDouble: { key, value in
                Task {
                    userDefaults.set(value, forKey: key)
                }
            },
            setData: { key, value in
                Task {
                    userDefaults.set(value, forKey: key)
                }
            },
            remove: { key in
                Task {
                    userDefaults.removeObject(forKey: key)
                }
            }
        )
    }()
}

// MARK: - UserDefaults + Sendable

extension UserDefaults: @unchecked Sendable {}
