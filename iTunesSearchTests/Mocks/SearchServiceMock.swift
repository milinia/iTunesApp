//
//  SearchServiceMock.swift
//  iTunesSearchTests
//
//  Created by Evelina on 14.04.2024.
//

import Foundation
@testable import iTunesSearch

final class SearchServiceMock: SearchServiceProtocol {
    
    var isFailureResponse: Bool = false
    
    func search(text: String) async throws -> iTunesSearch.SearchResponse {
        if isFailureResponse {
            throw AppError.networkError
        } else {
            return SearchResponse(results: [])
        }
    }
    
    func searchWithFilters(text: String, filters: String) async throws -> iTunesSearch.SearchResponse {
        if isFailureResponse {
            throw AppError.networkError
        } else {
            return SearchResponse(results: [])
        }
    }
}
