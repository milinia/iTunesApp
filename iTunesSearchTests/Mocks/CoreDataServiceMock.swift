//
//  CoreDataServiceMock.swift
//  iTunesSearchTests
//
//  Created by Evelina on 14.04.2024.
//

import Foundation
@testable import iTunesSearch

class CoreDataServiceMock: SearchRequestCoreDataServiceProtocol {
    
    var isFailureResponse: Bool = false
    
    func fetchSearchRequestData() -> [iTunesSearch.SearchRequest]? {
        if isFailureResponse {
            return nil
        } else {
            return []
        }
    }
    
    func saveSearchRequest(request: String) {}
}
