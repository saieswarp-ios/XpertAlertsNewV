//
//  URLSessionAPIClient.swift
//  XpertAlertsNewV
//
//  Created by IOS DEV on 08/09/26.
import Foundation

final class URLSessionAPIClient: APIClient {
    
    func request(endpoint: String,
                 method: String,
                 queryItems: [URLQueryItem]) async throws -> Data {
        
        guard var components = URLComponents(string: endpoint) else {
            throw URLError(.badURL)
        }
        
        components.queryItems = queryItems
        
        guard let url = components.url else {
            
            throw URLError(.badURL)
        }
        
  //      print("Request URL:" , url)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            
            throw URLError(.badServerResponse)
            
        }
        
        guard 200...299 ~= httpResponse.statusCode else {
            
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}








