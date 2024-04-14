//
//  Assembly.swift
//  iTunesSearch
//
//  Created by Evelina on 04.04.2024.
//

import Foundation

protocol AssemblyProtocol {
    var searchService: SearchServiceProtocol { get }
    var networkManager: NetworkManagerProtocol { get }
    var imageService: ImageServiceProtocol { get }
    var lookupService: LookupServiceProtocol { get }
    var coreDataService: SearchRequestCoreDataServiceProtocol { get }
}

final class Assembly: AssemblyProtocol {
    lazy var networkManager: NetworkManagerProtocol = NetworkManager()
    lazy var searchService: SearchServiceProtocol = SearchService(networkManager: networkManager)
    lazy var imageService: ImageServiceProtocol = ImageService(networkManager: networkManager)
    lazy var lookupService: LookupServiceProtocol = LookupService(networkManager: networkManager)
    lazy var coreDataService: SearchRequestCoreDataServiceProtocol = SearchRequestCoreDataService()
}
