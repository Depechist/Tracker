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
        
        // Создаем и добавляем экран Трекеров в TabBar
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem.image = UIImage(named: "TabBarTrackersIcon")
        trackersViewController.tabBarItem.title = "Трекеры"
        
        // Создаем и добавляем экран Статистики в TabBar
        let statsViewController = StatsViewController()
        statsViewController.tabBarItem.image = UIImage(named: "TabBarStatsIcon")
        statsViewController.tabBarItem.title = "Статистика"
        
        // Оборачиваем его в NavigationController
        let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
        
        // Создаем экземпляр TapBarController
        let tabBarController = UITabBarController()
        
        // Добавляем контроллер навигации в TapBarController
        tabBarController.viewControllers = [trackersNavigationController, statsViewController]
        
        // Устанавливаем tapBarController корневым (основным) экраном для окна
        window.rootViewController = tabBarController
        
        // Запоминаем окно и делаем его видимым
        self.window = window
        window.makeKeyAndVisible()
    }
}

