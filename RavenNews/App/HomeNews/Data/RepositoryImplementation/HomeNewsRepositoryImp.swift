//
//  HomeNewsRepositoryImp.swift
//  RavenNews
//
//  Created by MaurZac on 02/12/24.
//
import Foundation
import Combine

class HomeNewsRepositoryImp: HomeNewsRepository {
    
    private let apiClient: ApiService
    
    init(apiClient: ApiService) {
        self.apiClient = apiClient
    }

    func fetchPopularNews() -> AnyPublisher<[Articles], Error> {
        let endpoint = "https://api.nytimes.com/svc/mostpopular/v2/viewed/1.json?api-key=qTl6HA9lEk9bHwEMNSrdjRAceMnSqQEZ"
        
        return apiClient.request(url: endpoint)
            .receive(on: DispatchQueue.main)
            .map { (response: News) in
                return response.results
            }
            .eraseToAnyPublisher()
    }
}

