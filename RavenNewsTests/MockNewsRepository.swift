//
//  MockNewsRepository.swift
//  RavenNews
//
//  Created by MaurZac on 03/12/24.
//
import Foundation
import Combine
@testable import RavenNews

final class MockHomeNewsRepository: HomeNewsRepository {
    private let mockData: Result<[Articles], Error>
    
    init(mockData: Result<[Articles], Error>) {
        self.mockData = mockData
    }
    
    func fetchPopularNews() -> AnyPublisher<[Articles], Error> {
        return Future<[Articles], Error> { promise in
            promise(self.mockData)
        }
        .eraseToAnyPublisher()
    }
}


