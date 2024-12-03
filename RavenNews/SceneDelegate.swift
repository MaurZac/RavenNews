//
//  SceneDelegate.swift
//  RavenNews
//
//  Created by MaurZac on 28/11/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator: HomeNewsCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        transitionToMainApp()
    }
    
    private func transitionToMainApp() {
        let navigationController = UINavigationController()
        //navigationController.navigationBar.isHidden = true

        let viewControllerFactory = HomeViewFactoryImp(
            navigationController: navigationController
        )
        coordinator = HomeNewsCoordinator(
            navigationController: navigationController,
            viewControllerFactory:viewControllerFactory
        )
        
        let _: ()? = coordinator?.start()
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}


}

