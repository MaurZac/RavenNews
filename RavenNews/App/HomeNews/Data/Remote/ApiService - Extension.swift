//
//  ApiService - Extension.swift
//  RavenNews
//
//  Created by MaurZac on 02/12/24.
//

import Foundation

extension ApiService {
    func request<T: Decodable>(
        endpoint: String,
        method: String = "GET",
        parameters: [String: Any]? = nil,
        headers: [String: String]? = nil,
        responseType: T.Type,
        completion: @escaping (Result<T, ApiError>) -> Void
    ) {
        guard let url = URL(string: baseUrl + endpoint) else {
            completion(.failure(.invalidUrl))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.allHTTPHeaderFields = headers ?? defaultHeaders
        
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
            } catch {
                completion(.failure(.custom("Error serializando parámetros.")))
                return
            }
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.custom(error.localizedDescription)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidResponse))
                return
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}

