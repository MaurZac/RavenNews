//
//  TokenRepository.swift
//  RavenNews
//
//  Created by MaurZac on 02/12/24.
//
protocol TokenRepository {
    func saveToken(_ token: String) -> Bool
    func getToken() -> String?
}
