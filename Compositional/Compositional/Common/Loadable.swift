//
//  Loadable.swift
//  Compositional
//
//  Created by Kai on 31/10/24.
//

import Foundation

enum Loadable<ValueType> {
    case isLoading(last: ValueType?)
    case loaded(value: ValueType)
    case failed(error: Error)

    var value: ValueType? {
        switch self {
        case .isLoading: return nil
        case let .loaded(value): return value
        case .failed: return nil
        }
    }

    var valueOrPast: ValueType? {
        switch self {
        case let .isLoading(last): return last
        case let .loaded(value): return value
        case .failed: return nil
        }
    }

    var isLoading: Bool {
        switch self {
        case .isLoading: return true
        default: return false
        }
    }
}
