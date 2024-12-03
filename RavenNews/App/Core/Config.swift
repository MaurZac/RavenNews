//
//  Config.swift
//  RavenNews
//
//  Created by MaurZac on 02/12/24.
//
import Foundation

class Config {
    static var apiKey: String? {
        return KeychainManager.shared.get(key: "apiKey") ??
               Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String
    }
}

