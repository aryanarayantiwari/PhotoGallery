//
//  Network.swift
//  PhotoGallery
//
//  Created by Arya Narayan Tiwari on 28/02/26.
//

import Foundation

// MARK: - Network Protocol

protocol Network {
    func fetch<T: Decodable>(from url: URL) async throws -> [T]
}

// MARK: - Network Service

struct NetworkService: Network {
    func fetch<T: Decodable>(from url: URL) async throws -> [T] {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200...299 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        return try JSONDecoder().decode([T].self, from: data)
    }
}

// MARK: - API Endpoint

enum APIEndpoint {
    case photos(page: Int, limit: Int)
}

extension APIEndpoint {
    var url: URL {
        switch self {
        case .photos(let page, let limit):
            var components = URLComponents()
            components.scheme = "https"
            components.host = "jsonplaceholder.typicode.com"
            components.path = "/photos"
            
            components.queryItems = [
                URLQueryItem(name: "_page", value: "\(page)"),
                URLQueryItem(name: "_limit", value: "\(limit)")
            ]
            
            return components.url!
        }
    }
}

