//
//  Task+Ext.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import Foundation

extension Task where Success == Never, Failure == Never {
    static func delay(seconds: Float) async -> Void {
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}
