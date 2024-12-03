//
//  HomeNewsCoordinator.swift
//  RavenNews
//
//  Created by MaurZac on 30/11/24.
//
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    func start()
    func navigateDetailsNews(news: Articles)
    func presentCustomAlert(
            image: UIImage?,
            title: String,
            description: String,
            firstButtonTitle: String?,
            secondButtonTitle: String?,
            firstButtonAction: (() -> Void)?,
            secondButtonAction: (() -> Void)?
        )
}


final class HomeNewsCoordinator: Coordinator {

    func presentCustomAlert(image: UIImage?, title: String, description: String, firstButtonTitle: String?, secondButtonTitle: String?, firstButtonAction: (() -> Void)?, secondButtonAction: (() -> Void)?) {
        let customAlertVC = AlertDialog(
                firstButtonTitle: firstButtonTitle,
                secondButtonTitle: secondButtonTitle,
                firstButtonAction: firstButtonAction,
                secondButtonAction: secondButtonAction
            )
            customAlertVC.image = image
            customAlertVC.titleText = title
            customAlertVC.descriptionText = description

            customAlertVC.modalPresentationStyle = .overFullScreen
            customAlertVC.modalTransitionStyle = .crossDissolve
            
            if let viewController = navigationController.visibleViewController {
                viewController.present(customAlertVC, animated: true, completion: nil)
            } else {
                navigationController.topViewController?.present(customAlertVC, animated: true, completion: nil)
            }
        
    }
    
    var navigationController: UINavigationController
    var viewControllerFactory: HomeNewsFactory

    init(navigationController: UINavigationController, viewControllerFactory: HomeNewsFactory) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory
    }

    func start() {
        let apiService = ApiService.shared
        let viewModel = HomeNewsViewModel(apiService: apiService)
        let homeNews = HomeNewsView(viewModel: viewModel, coordinator: self, viewControllerFactory: viewControllerFactory)

        navigationController.pushViewController(homeNews, animated: false)
    }

//    func startHome() {
//        let homeViewController = viewControllerFactory.makeHomeViewController(coordinator: self)
//        navigationController.pushViewController(homeViewController, animated: false)
//    }
    
    func navigateDetailsNews(news: Articles) {
        //let favoriteMovieRepository = FavoriteMovieRepositoryImpl(coreDataManager: CoreDataManager.shared)
        //let detailViewModel = DetailMovieViewModel(movie: movie, favoriteMovieRepository: favoriteMovieRepository)
        let detailViewController = viewControllerFactory.makeDetailNewsViewController(news: news)
        navigationController.pushViewController(detailViewController, animated: true)
    }
    
//    func navigateDetailsNews() {
//         let detailNews = viewControllerFactory.makeWatchlistViewController()
//         navigationController.pushViewController(watchlistViewController, animated: true)
//     }
}
