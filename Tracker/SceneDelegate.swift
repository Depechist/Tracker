//
//  SceneDelegate.swift
//  Tracker
//
//  Created by Artem Adiev on 15.06.2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Убеждаемся, что новая сцена - это окно или останавливаем выполнение
        guard let scene = (scene as? UIWindowScene) else { return }
        
        // Создаем новое окно сцены (экрана)
        let window = UIWindow(windowScene: scene)
        
        // Создаем новый экран (ViewController) приложения
        let viewController = TrackersViewController()
        
        // Оборачиваем его в NavigationController
        let navigationController = UINavigationController(rootViewController: viewController)
        
        // Создаем экземпляр TapBarController
        let tapBarController = UITabBarController()
        
        // Добавляем контроллер навигации в TapBarController
        tapBarController.viewControllers = [navigationController]
        
        // Устанавливаем tapBarController корневым (основным) экраном для окна
        window.rootViewController = tapBarController
        
        // Запоминаем окно и делаем его видимым
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

