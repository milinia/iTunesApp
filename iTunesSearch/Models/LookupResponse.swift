//
//  LookupResponse.swift
//  iTunesSearch
//
//  Created by Evelina on 13.04.2024.
//

import Foundation

struct LookupResponse: Decodable {
    let results: [ArtistData]
}

struct ArtistData: Decodable {
    let artistLinkUrl: String
    let primaryGenreName: String
    let artistName: String
    let artistType: String
}
