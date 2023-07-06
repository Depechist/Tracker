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
    private var visibleCategories: [Tracker] = [
        Tracker(emoji: "❤️", text: "Поливать растения", backgroundColor: .colorSelection3, buttonColor: .colorSelection3, dayCount: "1 день"),
        Tracker(emoji: "😻", text: "Кошка заслонила камеру на созвоне", backgroundColor: .colorSelection5, buttonColor: .colorSelection5, dayCount: "5 дней")
    ]
    
    // MARK: - UI ELEMENTS
    
    // Создаем экземпляр коллекции
    var trackerCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")

        return collectionView
    }()
    
    // Создаем экземпляр DatePicker
    let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.calendar.firstWeekday = 2
        return picker
    }()
    
    // Создаем экземпляр UILabel
    private lazy var mainLabel: UILabel = {
        let mainLabel = UILabel()
        mainLabel.text = "Трекеры"
        mainLabel.textColor = .ypBlack
        mainLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
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
    
    // Подпись под картинкой-заглушкой
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
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTaped))
            addButton.tintColor = .ypBlack
            navBar.topItem?.setLeftBarButton(addButton, animated: false)
            
            let datePickerButton = UIBarButtonItem(customView: datePicker)
            navBar.topItem?.setRightBarButton(datePickerButton, animated: false)
        }
    }
    
    @objc func addButtonTaped() {
        let modalVC = AddTrackerViewController()
        modalVC.modalTransitionStyle = .coverVertical
        present(modalVC, animated: true)
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
        
        // Подтягиваем ячейку из массива
        let tracker = visibleCategories[indexPath.item]
        cell.emojiLabel.text = tracker.emoji
        cell.trackerText.text = tracker.text
        cell.upperView.backgroundColor = tracker.backgroundColor
        cell.actionButton.tintColor = tracker.buttonColor
        cell.dayCountLabel.text = tracker.dayCount
        
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegate {
    
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 2) - 20.0, height: 148)

    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    }
}



