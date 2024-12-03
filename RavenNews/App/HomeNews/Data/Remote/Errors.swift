//
//  Errors.swift
//  RavenNews
//
//  Created by MaurZac on 02/12/24.
//
enum ApiError: Error {
    case invalidUrl
    case requestFailed
    case invalidResponse
    case decodingError
    case custom(String)
}
