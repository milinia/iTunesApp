//
//  APIRequests.swift
//  iTunesSearch
//
//  Created by Evelina on 04.04.2024.
//

import Foundation

enum APIRequests {
    case search(searchRequest: String)
    case searchWithFilters(searchRequest: String, filters: String)
    case lookupForArtist(id: Int)
    case lookupForArtistsWorks(id: Int, entity: String)
    
    var url: String {
        switch self {
        case .search(let searchRequest):
            let request = searchRequest.replacingOccurrences(of: " ", with: "+")
            return baseUrl + "/search?term=\(request)&limit=30"
        case .searchWithFilters(let searchRequest, let filters):
            let request = searchRequest.replacingOccurrences(of: " ", with: "+")
            return baseUrl + "/search?term=\(request)&limit=30&\(filters)"
        case .lookupForArtist(let id):
            return baseUrl + "/lookup?id=\(id)"
        case .lookupForArtistsWorks(let id, let entity):
            return baseUrl + "/lookup?id=\(id)&entity=\(entity)&limit=5"
        }
    }
    
    var baseUrl: String {
        return "https://itunes.apple.com"
    }
}
