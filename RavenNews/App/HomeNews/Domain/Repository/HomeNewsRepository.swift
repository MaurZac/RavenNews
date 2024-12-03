//
//  HomeNewsRepository.swift
//  RavenNews
//
//  Created by MaurZac on 02/12/24.
//
import Foundation
import Combine

protocol HomeNewsRepository {
    func fetchPopularNews() -> AnyPublisher<[Articles], Error>
}
