//
//  HomeNewsFactory.swift
//  RavenNews
//
//  Created by MaurZac on 30/11/24.
//
import Foundation
import UIKit

protocol HomeNewsFactory {
    func makeDetailNewsViewController(news: Articles) -> DetailNewsView
}

final class HomeViewFactoryImp: HomeNewsFactory {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func makeDetailNewsViewController(news: Articles) -> DetailNewsView {
        print(navigationController)
//        let coreData = CoreDataManager.saveContext(self)
//        let favoriteMovieRepository = FavoriteMovieRepositoryImpl(coreDataManager: coreDataManager)
//        
        let viewModel = DetailNewsViewModel(news: news)
        return DetailNewsView(viewModel: viewModel)
    }
    
}

