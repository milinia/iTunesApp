//
//  NetworkManager.swift
//  iTunesSearch
//
//  Created by Evelina on 04.04.2024.
//

import Foundation

protocol NetworkManagerProtocol {
    func makeRequest(with query: String) async throws -> Data
}

final class NetworkManager: NetworkManagerProtocol {
    
    // MARK: - Implement NetworkManagerProtocol
    func makeRequest(with query: String) async throws -> Data {
        guard let url = URL(string: query) else { throw URLError(.badURL) }
        let urlRequest = URLRequest(url: url)
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw URLError(.badServerResponse)}
        return data
    }
}
