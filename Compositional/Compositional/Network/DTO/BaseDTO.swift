//
//  BaseDTO.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import Foundation

struct BaseDTO<T:Codable>: Codable {
    let code: Int
    let message: String
    let data: T
}
