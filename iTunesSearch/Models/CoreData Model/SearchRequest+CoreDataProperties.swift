//
//  SearchRequest+CoreDataProperties.swift
//  iTunesSearch
//
//  Created by Evelina on 05.04.2024.
//
//

import Foundation
import CoreData


extension SearchRequest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchRequest> {
        return NSFetchRequest<SearchRequest>(entityName: "SearchRequest")
    }

    @NSManaged public var request: String?

}

extension SearchRequest : Identifiable {

}
