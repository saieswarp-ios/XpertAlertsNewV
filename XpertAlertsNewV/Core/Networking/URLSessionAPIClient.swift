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
        
        
        print("FINAL API URL:")
        print(url.absoluteString)
        
        
  //      print("Request URL:" , url)
        
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
      
        let data: Data
        let response: URLResponse

        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            let nsError = error as NSError

            print("API REQUEST FAILED")
            print("Endpoint:", components.path)
            print("Error domain:", nsError.domain)
            print("Error code:", nsError.code)
            print("Error description:", nsError.localizedDescription)
            print("Underlying error:", nsError.userInfo[NSUnderlyingErrorKey] ?? "None")

            throw error
        }

        
        guard let httpResponse = response as? HTTPURLResponse else {
            
            throw URLError(.badServerResponse)
            
        }
        
        guard 200...299 ~= httpResponse.statusCode else {

            print("❌ HTTP STATUS CODE:", httpResponse.statusCode)

            if let responseString = String(
                data: data,
                encoding: .utf8
            ) {
                print("❌ SERVER RESPONSE:")
                print(responseString)
            }

            throw URLError(.badServerResponse)
        }
        return data
    }
}





//djhfabsdhfvgdshfgvd


