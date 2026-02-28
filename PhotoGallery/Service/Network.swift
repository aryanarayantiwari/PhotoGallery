//
//  Network.swift
//  PhotoGallery
//
//  Created by Arya Narayan Tiwari on 28/02/26.
//

import Foundation

protocol Network {
    var endpoint: URL { get }
    var request: URLRequest { get }
    func fetch<T: Codable>(session: URLSession) async throws -> [T]
}

struct NetworkService: Network {
    func fetch<T>(session: URLSession) async throws -> [T] where T : Decodable, T : Encodable {
        let (data, _) = try await session.data(for: request)
        let decoder = JSONDecoder()
        let images = try decoder.decode([T].self, from: data)
        return images
    }
    
    var endpoint: URL {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/photos") else {
            fatalError("URL not configured")
        }
        return url
    }
    
    var request: URLRequest {
        return URLRequest(url: endpoint)
    }
}
