//
//  CreateTrackerViewController.swift
//  Tracker
//
//  Created by Artem Adiev on 05.07.2023.
//

// MARK: ЭКРАН ВЫБОРА ТИПА ТРЕКЕРА

import UIKit

class AddTrackerViewController: UIViewController {
    
    private let habitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Привычка", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    
    private let eventButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .ypBlack
        button.setTitle("Нерегулярное событие", for: .normal)
        button.setTitleColor(.ypWhite, for: .normal)
        button.layer.cornerRadius = 16
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ypWhite
        
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 49))
        navBar.barTintColor = .ypWhite
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
        view.addSubview(navBar)
        let navTitle = UINavigationItem(title: "Создание трекера")
        navBar.setItems([navTitle], animated: false)
        
        addSubviews()
    }
    
    private func addSubviews() {
        habitButton.addTarget(self, action: #selector(habitButtonTapped), for: .touchUpInside)
        eventButton.addTarget(self, action: #selector(eventButtonTapped), for: .touchUpInside)

        habitButton.translatesAutoresizingMaskIntoConstraints = false
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(habitButton)
        view.addSubview(eventButton)

        NSLayoutConstraint.activate([
            habitButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            habitButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            habitButton.widthAnchor.constraint(equalToConstant: 335),
            habitButton.heightAnchor.constraint(equalToConstant: 60),
            
            eventButton.topAnchor.constraint(equalTo: habitButton.bottomAnchor, constant: 16),
            eventButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventButton.widthAnchor.constraint(equalToConstant: 335),
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func habitButtonTapped() {
        let modalVC = NewHabitViewController()
        modalVC.modalTransitionStyle = .coverVertical
        present(modalVC, animated: true)
    }
    
    @objc private func eventButtonTapped() {
        let modalVC = NewEventViewController()
        modalVC.modalTransitionStyle = .coverVertical
        present(modalVC, animated: true)
    }
    
}
