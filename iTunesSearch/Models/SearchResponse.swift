//
//  SearchResponse.swift
//  iTunesSearch
//
//  Created by Evelina on 06.04.2024.
//

import Foundation
import UIKit

struct SearchResponse: Decodable {
    let results: [Result]
}

struct Result: Decodable {
    let artistName: String
    let wrapperType: WrapperType?
    let trackName: String?
    let artworkUrl100: String?
    let trackTimeMillis: Int?
    let trackPrice: Double?
    let currency: String?
    let collectionPrice: Double?
    let collectionName: String?
    let longDescription: String?
    let primaryGenreName: String?
    let artistId: Int?
    let description: String?
    let trackViewUrl: String?
    let kind: Kind?
}

enum WrapperType: String, Decodable {
    case track = "track"
    case artist = "artist"
    case collection = "collection"
    case audiobook = "audiobook"
    
    var icon: UIImage? {
        switch self {
        case .track:
            return UIImage(systemName: "waveform")
        case .artist:
            return UIImage(systemName: "person.fill")
        case .collection:
            return UIImage(systemName: "folder.fill")
        case .audiobook:
            return UIImage(systemName: "book.pages")
        }
    }
}


enum Kind: String, Decodable, CaseIterable {
    case featureMovie = "feature-movie"
    case song = "song"
    case tvEpisode = "tv-episode"
    case book = "book"
    case album = "album"
    case artist = "artist"
    
    var artistWorkEntity: String {
        switch self {
        case .featureMovie:
            return "movie"
        case .song:
            return "song"
        case .tvEpisode:
            return "tvShow"
        case .book:
            return "audiobook"
        case .album:
            return "album"
        case .artist:
            return "artist"
        }
    }
}

enum Language: String, CaseIterable {
    case en = "Английский"
    case jp = "Японский"
    
    var number: Int {
        switch self {
        case .en:
            return 0
        case .jp:
            return 1
        }
    }
}

enum Entity: String, CaseIterable {
    case all = "Без разницы"
    case movie = "Фильм"
    case podcast = "Подкаст"
    case album = "Альбом"
    case song = "Песня"
    case artist = "Исполнитель"
    case author = "Автор"
    case audiobook = "Аудиокнига"
    case ebook = "Электронная книга"
    
    var number: Int {
        switch self {
        case .all:
            return 0
        case .movie:
            return 1
        case .podcast:
            return 2
        case .album:
            return 3
        case .song:
            return 4
        case .artist:
            return 5
        case .author:
            return 6
        case .audiobook:
            return 7
        case .ebook:
            return 8
        }
    }
}
