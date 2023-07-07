//
//  ViewController.swift
//  Tracker
//
//  Created by Artem Adiev on 15.06.2023.
//

import UIKit

// Создаем класс для заголовка секции
class SectionHeader: UICollectionReusableView {
    var titleLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 28),
            titleLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class TrackersViewController: UIViewController {
    
    // Массив со всеми созданными трекерами
    private var categories: [TrackerCategory] = []
    
    // Массив с видимыми на экране трекерами
    private var visibleCategories: [[Tracker]] = [
        // Секция 1
        [Tracker(emoji: "❤️", text: "Поливать растения", backgroundColor: .colorSelection5, buttonColor: .colorSelection5, dayCount: "1 день")],
        
        // Секция 2
        [Tracker(emoji: "😻", text: "Кошка заслонила камеру на созвоне", backgroundColor: .colorSelection2, buttonColor: .colorSelection2, dayCount: "5 дней"),
         Tracker(emoji: "🌺", text: "Бабушка прислала открытку в вотсаппе", backgroundColor: .colorSelection1, buttonColor: .colorSelection1, dayCount: "4 дня"),
         Tracker(emoji: "❤️", text: "Свидания в апреле", backgroundColor: .colorSelection14, buttonColor: .colorSelection14, dayCount: "5 дней")]
    ]
    
    // Заголовки для секций (хедеры)
    private var sectionTitles = ["Домашний уют", "Радостные мелочи"]
    
    // MARK: - UI ELEMENTS
    
    // Создаем экземпляр коллекции
    var trackerCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        
        // Регистрируем тип ячеек
        collectionView.register(TrackerCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        // Регистрируем тип хедера
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")

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
    // Возвращаем коллекции количество секций
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    // Возвращаем коллекции количество элементов в секции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        visibleCategories[section].count
    }
    
    // Создаем ячейку для отображения на экране
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrackerCollectionViewCell
        
        // Подтягиваем ячейку из массива
        let tracker = visibleCategories[indexPath.section][indexPath.item]
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
    
    // Задаем размер каждого элемента (ячейки) в коллекции
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return CGSize(width: (collectionView.bounds.width / 2) - 20.0, height: 148)

    }
    
    // Задаем минимальное расстояние между элементами в строке
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        return 10
    }
    
    // Задаем отступы для всей секции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 15.0)
    }
    
    // Высота заголовка
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50) // Высота хедера
    }
    
    // Отображаем заголовки на экране
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                         withReuseIdentifier: "header",
                                                                         for: indexPath) as! SectionHeader
            // Устанавливаем заголовок для каждой секции
            headerView.titleLabel.text = sectionTitles[indexPath.section]
            return headerView
        default:
            assert(false, "Invalid element type for SupplementaryElement")
        }
    }
}



