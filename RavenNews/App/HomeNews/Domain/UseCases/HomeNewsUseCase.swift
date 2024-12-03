//
//  HomeNewsUseCase.swift
//  RavenNews
//
//  Created by MaurZac on 02/12/24.
//
import Combine
import Foundation

final class HomeMovieUseCase {
    private let repository: HomeNewsRepository
    private var cancellables = Set<AnyCancellable>()
    
    init(repository: HomeNewsRepository) {
        self.repository = repository
    }
    
    func fetchPopularNews() -> AnyPublisher<[Articles], Error> {
        return repository.fetchPopularNews()
    }
}
