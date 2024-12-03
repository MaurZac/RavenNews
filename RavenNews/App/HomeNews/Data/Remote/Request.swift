//
//  Request.swift
//  RavenNews
//
//  Created by MaurZac on 02/12/24.
//
extension ApiService {
    func getMostPopularArticles(
        days: Int,
        apiKey: String,
        completion: @escaping (Result<[Articles], ApiError>) -> Void
    ) {
        let endpoint = "viewed/\(days).json?api-key=\(apiKey)"
        request(endpoint: endpoint, responseType: News.self) { result in
            switch result {
            case .success(let response):
                completion(.success(response.results))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

