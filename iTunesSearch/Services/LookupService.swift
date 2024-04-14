//
//  LookupService.swift
//  iTunesSearch
//
//  Created by Evelina on 13.04.2024.
//

import Foundation

protocol LookupServiceProtocol {
    func lookupForArtist(id: Int) async throws -> ArtistData
    func lookupForArtistWorks(id: Int, entity: String) async throws -> SearchResponse
}

final class LookupService: LookupServiceProtocol {
    // MARK: - Private properties
    private let networkManager: NetworkManagerProtocol
     
    // MARK: - Init
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
     
    // MARK: - Implementation LookupServiceProtocol
    func lookupForArtist(id: Int) async throws -> ArtistData {
        let data = try await networkManager.makeRequest(with: APIRequests.lookupForArtist(id: id).url)
        let lookupResponse = try JSONDecoder().decode(LookupResponse.self, from: data)
        return lookupResponse.results[0]
    }
    func lookupForArtistWorks(id: Int, entity: String) async throws -> SearchResponse {
        let data = try await networkManager.makeRequest(with: APIRequests.lookupForArtistsWorks(id: id,
                                                                                                entity: entity).url)
        let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
        return searchResponse
    }
}
