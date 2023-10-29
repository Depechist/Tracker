//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Artem Adiev on 25.10.2023.
//

import UIKit

final class OnboardingPageViewController: UIPageViewController {
    
    // Создаем ключ для хранения значения была ли кнопка Онбординга нажата
    static let onboardingCompletedKey = "onboardingCompleted"
    
    // Массив страниц Онбординга
    private var pages: [UIViewController] = []
    
    // MARK: - UI Elements
    
    // Создаем индикатор для текущей страницы Онбординга
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        configurePageControl(pageControl) // конфигурируем индикатор
        return pageControl
    }()
    
    // Кнопка выхода из Онбординга
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        configureButton(button) // конфигурируем кнопку
        return button
    }()
    
    // MARK: - Initializers
    
    // Настройка переходов между страницами
    override init(transitionStyle style: UIPageViewController.TransitionStyle, 
                  navigationOrientation: UIPageViewController.NavigationOrientation,
                  options: [UIPageViewController.OptionsKey : Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation)
    }
    
    // Необходимый для IB метод, не используем
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.overrideUserInterfaceStyle = .light
        
        setupOnboardingPages()     // Создаем страницы Онбординга
        setupPageViewControl()  // Настраиваем Контроллер
        setupConstraints()         // Задаем констрейнты для элементов
    }
    
    // MARK: - Setup UI
    
    // Настройка индикатора текущей страницы
    private func configurePageControl(_ pageControl: UIPageControl) {
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.currentPageIndicatorTintColor = .ypBlack
        pageControl.pageIndicatorTintColor = UIColor.ypBlack.withAlphaComponent(0.3)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Настройка кнопки выхода из Онбординга (кнопка "Вот это технологии!")
    private func configureButton(_ button: UIButton) {
        button.setTitle("Вот это технологии!", for: .normal)
        button.backgroundColor = .ypBlack
        button.layer.cornerRadius = 16
        button.setTitleColor(.ypWhite, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // Устанавливаем элементы на странице
    private func setupPageViewControl() {
        dataSource = self
        delegate = self
        view.addSubview(pageControl)
        view.addSubview(button)
    }
    
    // Создаем стоковую страницу Онбординга с изображением и текстом
    private func createOnboardingPage(imageName: String, labelText: String) -> UIViewController {
        let onboardingVC = UIViewController()
        
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        onboardingVC.view.addSubview(imageView)
        
        let label = UILabel()
        label.text = labelText
        label.textAlignment = .center
        label.numberOfLines = 2
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        onboardingVC.view.addSubview(label)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: onboardingVC.view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: onboardingVC.view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: onboardingVC.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: onboardingVC.view.trailingAnchor),
            
            label.centerXAnchor.constraint(equalTo: onboardingVC.view.centerXAnchor),
            label.topAnchor.constraint(equalTo: onboardingVC.view.topAnchor, constant: 452),
            label.leadingAnchor.constraint(equalTo: onboardingVC.view.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: onboardingVC.view.trailingAnchor, constant: -16)
        ])
        return onboardingVC
    }
    
    // Корректируем страницу Онбординга в зависимости от номера и добавляем в массив
    private func setupOnboardingPages() {
        let page1 = createOnboardingPage(imageName: "OnboardingBlue", labelText: "Отслеживайте только то, что хотите")
        let page2 = createOnboardingPage(imageName: "OnboardingRed", labelText: "Даже если это\nне литры воды или йога")
        pages.append(contentsOf: [page1, page2])
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 594),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.topAnchor.constraint(equalTo: pageControl.bottomAnchor, constant: 24),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    // По нажатию кнопки собираем экран Трекеров и переходим туда
    @objc private func buttonTapped() {
        
        // Сохраняем знание о том, что Онбординг просмотрен
        UserDefaults.standard.set(true, forKey: OnboardingPageViewController.onboardingCompletedKey)
        
        // Создаем и добавляем экран Трекеров в TabBar
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem.image = UIImage(named: "TabBarTrackersIcon")
        trackersViewController.tabBarItem.title = "Трекеры"
        
        // Создаем и добавляем экран Статистики в TabBar
        let statsViewController = StatisticViewController()
        statsViewController.tabBarItem.image = UIImage(named: "TabBarStatsIcon")
        statsViewController.tabBarItem.title = "Статистика"
        
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
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        window.rootViewController = tabBarController
    }
}

// MARK: - Data Source

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
        return pages[nextIndex]
    }
}

// MARK: - Delegate

// Обновляем индикатор страницы при переходе между страницами
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed {
            let currentPageIndex = pages.firstIndex(of: viewControllers!.first!)!
            pageControl.currentPage = currentPageIndex
        }
    }
}

