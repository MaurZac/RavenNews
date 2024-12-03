//
//  DetailNewsViewModel.swift
//  RavenNews
//
//  Created by MaurZac on 30/11/24.
//
import Foundation
import UIKit

final class DetailNewsViewModel {
    // MARK: - Properties
    let news: Articles
    
    // MARK: - Init
    init(news: Articles) {
        self.news = news
    }
}

