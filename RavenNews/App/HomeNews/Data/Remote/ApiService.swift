//
//  ApiService.swift
//  RavenNews
//
//  Created by MaurZac on 02/12/24.
//
import Foundation
import Combine

class ApiService {
    static let shared = ApiService()

    let baseUrl = "https://api.nytimes.com/svc/mostpopular/v2/"

    var defaultHeaders: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
    }

    let session: URLSession

    private init(session: URLSession = .shared) {
        self.session = session
    }

    func request<T: Decodable>(url: String, headers: [String: String]? = nil) -> Future<T, Error> {
        return Future { promise in
            guard let url = URL(string: url) else {
                promise(.failure(URLError(.badURL)))
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            
            if let headers = headers {
                headers.forEach { key, value in
                    request.setValue(value, forHTTPHeaderField: key)
                }
            } else {
                self.defaultHeaders.forEach { key, value in
                    request.setValue(value, forHTTPHeaderField: key)
                }
            }

            self.session.dataTaskPublisher(for: request)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        promise(.failure(error))
                    case .finished:
                        break
                    }
                } receiveValue: { data, response in
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        promise(.failure(URLError(.badServerResponse)))
                        return
                    }

                    let decoder = JSONDecoder()
                    do {
                        let decodedResponse = try decoder.decode(T.self, from: data)
                        promise(.success(decodedResponse))
                    } catch {
                        promise(.failure(error))
                    }
                }
                .store(in: &self.cancellables)
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
}
