//
//  SearchRequestCoreDataService.swift.swift
//  iTunesSearch
//
//  Created by Evelina on 04.04.2024.
//

import Foundation
import CoreData
import UIKit

protocol SearchRequestCoreDataServiceProtocol {
    func fetchSearchRequestData() -> [SearchRequest]?
    func saveSearchRequest(request: String)
}

final class SearchRequestCoreDataService: SearchRequestCoreDataServiceProtocol {
    
    // MARK: - Private properties
    private let context: NSManagedObjectContext? = {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return nil}
        return appDelegate.persistentContainer.viewContext
    }()
    
    // MARK: - Implement SearchRequestCoreDataServiceProtocol
    func fetchSearchRequestData() -> [SearchRequest]? {
        guard let unwrappedContext = context else {
            return nil
        }
        do {
            let requests = try unwrappedContext.fetch(SearchRequest.fetchRequest())
            return requests.reversed()
        } catch {
            return nil
        }
    }
    
    func saveSearchRequest(request: String) {
        guard let unwrappedContext = context else { return }
        let searchRequest = SearchRequest(context: unwrappedContext)
        searchRequest.request = request
        do {
            try unwrappedContext.save()
        } catch {
            return
        }
    }
}
