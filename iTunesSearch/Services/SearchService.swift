//
//  SearchService.swift
//  iTunesSearch
//
//  Created by Evelina on 06.04.2024.
//

import Foundation

protocol SearchServiceProtocol {
    func search(text: String) async throws -> SearchResponse
    func searchWithFilters(text: String, filters: String) async throws -> SearchResponse
}

final class SearchService: SearchServiceProtocol {
    // MARK: - Private properties
    private let networkManager: NetworkManagerProtocol
     
    // MARK: - Init
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
     
    // MARK: - Implementation SearchServiceProtocol
    func search(text: String) async throws -> SearchResponse {
        let data = try await networkManager.makeRequest(with: APIRequests.search(searchRequest: text).url)
        let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
        return searchResponse
    }
    
    func searchWithFilters(text: String, filters: String) async throws -> SearchResponse {
        let data = try await networkManager.makeRequest(with: APIRequests.searchWithFilters(searchRequest: text,
                                                                                            filters: filters).url)
        let searchResponse = try JSONDecoder().decode(SearchResponse.self, from: data)
        return searchResponse
    }
}
