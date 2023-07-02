//
//  ViewController.swift
//  Tracker
//
//  Created by Artem Adiev on 15.06.2023.
//

import UIKit

class TrackersViewController: UIViewController {
    
    // Создаем массив с созданными трекерами
    private var categories: [TrackerCategory] = []
    private var visibleCategories: [TrackerCategory] = []
    
    // MARK: - UI ELEMENTS
    
    // Создаем экземпляр коллекции
    let trackerCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return collectionView
    }()
    
    // Создаем экземпляр DatePicker
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        return picker
    }()
    
    // Создаем экземпляр UILabel
    private lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "Трекеры"
        mainLabel.textColor = .ypBlack
        mainLabel.font = UIFont.boldSystemFont(ofSize: 34)
        return mainLabel
    }()
    
    // Создаем экземпляр UISearchTextField
    private lazy var searchField: UISearchTextField = {
        let field = UISearchTextField()
        field.placeholder = "Поиск"
        return field
    }()
    
    // Создаем картинку-заглушку для пустой коллекции
    private lazy var emptyCollectionIcon: UIImageView = {
        let image = UIImage(named: "EmptyCollectionIcon")
        let emptyCollectionIcon = UIImageView(image: image)
        return emptyCollectionIcon
    }()
    
    private lazy var emptyCollectionLabel: UILabel = {
        let label = UILabel()
        label.text = "Что будем отслеживать?"
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    // MARK: - LIFECYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Устанавливаем фон для экрана
        view.backgroundColor = .ypWhite
        
        // Отображаем коллекцию и другие UI элементы
        setupTrackerCollectionView()
        addSubviews()
        
        // Устанавливаем кнопки в NavigationBar
        if let navBar = navigationController?.navigationBar {
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: .none)
            addButton.tintColor = .ypBlack
            navBar.topItem?.setLeftBarButton(addButton, animated: false)
            
            let datePickerButton = UIBarButtonItem(customView: datePicker)
            navBar.topItem?.setRightBarButton(datePickerButton, animated: false)
        }
    }
    
    // MARK: - UI ELEMENTS LAYOUT
    
     private func addSubviews() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        searchField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainLabel)
        view.addSubview(searchField)
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        if visibleCategories.count == 0 {
            emptyCollectionIcon.translatesAutoresizingMaskIntoConstraints = false
            emptyCollectionLabel.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(emptyCollectionIcon)
            view.addSubview(emptyCollectionLabel)
            
            NSLayoutConstraint.activate([
                emptyCollectionIcon.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                emptyCollectionIcon.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                emptyCollectionLabel.topAnchor.constraint(equalTo: emptyCollectionIcon.bottomAnchor, constant: 8),
                emptyCollectionLabel.centerXAnchor.constraint(equalTo: emptyCollectionIcon.centerXAnchor)
            ])
        } else {
            trackerCollectionView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(trackerCollectionView)
            NSLayoutConstraint.activate([
                trackerCollectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
                trackerCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                trackerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }
    
    // Настраиваем коллекцию для отображения
    private func setupTrackerCollectionView() {
        trackerCollectionView.dataSource = self
        trackerCollectionView.delegate = self
    }
}

// MARK: - EXTENSIONS

extension TrackersViewController: UICollectionViewDataSource {
    // Возвращаем коллекции количество элементов в массиве
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories.count
    }
    
    // Создаем ячейку для отображения на экране
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrackerCollectionViewCell
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
}

