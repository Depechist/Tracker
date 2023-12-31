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
        
        // Определяем просмотрен ли Онбординг
        let onboardingCompleted = UserDefaults.standard.bool(forKey: OnboardingPageViewController.onboardingCompletedKey)
        
        if !onboardingCompleted {
            
            // Создаем экран Онбординга
            let onboardingVC = OnboardingPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
            
            // Показываем экран Онбординга
            window.rootViewController = onboardingVC
        } else {
            // Создаем и добавляем экран Трекеров в TabBar
            let trackersViewController = TrackersViewController()
            trackersViewController.tabBarItem.image = UIImage(named: "TabBarTrackersIcon")
            trackersViewController.tabBarItem.title = NSLocalizedString("tabTrackers", comment: "")
            
            // Создаем и добавляем экран Статистики в TabBar
            let statsViewController = StatisticViewController()
            statsViewController.tabBarItem.image = UIImage(named: "TabBarStatsIcon")
            statsViewController.tabBarItem.title = NSLocalizedString("tabStatistics", comment: "")
            
            // Оборачиваем его в NavigationController
            let trackersNavigationController = UINavigationController(rootViewController: trackersViewController)
            
            // Создаем экземпляр TapBarController
            let tabBarController = UITabBarController()
            let separatorImage = UIImage()
            tabBarController.tabBar.barTintColor = .ypBlack
            tabBarController.tabBar.shadowImage = separatorImage
            tabBarController.tabBar.backgroundImage = separatorImage
            tabBarController.tabBar.layer.borderWidth = 0.50
            tabBarController.tabBar.clipsToBounds = true
            
            // Добавляем контроллер навигации в TapBarController
            tabBarController.viewControllers = [trackersNavigationController, statsViewController]
            
            // Устанавливаем tapBarController корневым (основным) экраном для окна
            window.rootViewController = tabBarController
        }
                
        // Запоминаем окно и делаем его видимым
        self.window = window
        window.makeKeyAndVisible()
    }
}

