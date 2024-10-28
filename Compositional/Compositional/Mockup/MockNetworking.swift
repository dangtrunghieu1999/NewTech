//
//  MockNetworking.swift
//  Compositional
//
//  Created by Kai on 28/10/24.
//

import Foundation

struct MockNetworking: Services {
    func getHomeMusic() async throws -> [MusicSectionDTO] {
        await Task.delay(seconds: 2)
        guard let url = Bundle.main.url(forResource: "HomeMusic", withExtension: "json") else {
            throw NSError(domain: "MockNetworking", code: 404, userInfo: [NSLocalizedDescriptionKey: "Not Found"])
        }
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let baseDTO = try decoder.decode(BaseDTO<[MusicSectionDTO]>.self, from: data)
        return baseDTO.data
    }
}
