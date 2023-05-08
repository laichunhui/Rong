//  UIApplication+Extension.swift
//  Anime Now! (iOS)
//
//  Created by ErrorErrorError on 11/3/22.
//
//

#if os(iOS)
import Foundation
import SwiftUI

extension UIApplication {
    func endEditing(_ force: Bool) {
        let _ = windows
            .first(where: \.isKeyWindow)?
            .endEditing(force)
    }
}
#endif
