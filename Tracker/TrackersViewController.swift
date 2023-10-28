//
//  ViewController.swift
//  Tracker
//
//  Created by Artem Adiev on 15.06.2023.
//

// MARK: ГЛАВНЫЙ ЭКРАН

import UIKit

final class TrackersViewController: UIViewController {
    
    // Храним выбранную в пикере дату
    var currentDate: Date = Date()
    
    // Объявляем синглтон с моковыми данными
    private let dataManager = DataManager.shared
    
    private let trackerStore = TrackerStore()
    private let trackerCategoryStore = TrackerCategoryStore()
    private var trackerRecordStore = TrackerRecordStore()

    // Массив с видимыми на экране трекерами
    private var visibleCategories: [TrackerCategory] = []
    
    // Хранилище записей завершенных трекеров
    var completedTrackers: [TrackerRecord] = []
    
    // MARK: - UI ELEMENTS
    
    // Создаем экземпляр коллекции
    private var trackerCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .clear
        
        // Регистрируем тип ячеек
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: "cell")
        
        // Регистрируем тип хедера
        collectionView.register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        
        return collectionView
    }()
    
    // Создаем экземпляр DatePicker
    private let datePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.preferredDatePickerStyle = .compact
        picker.datePickerMode = .date
        picker.locale = Locale.current
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
    private lazy var searchTextField: UISearchTextField = {
        let field = UISearchTextField()
        field.backgroundColor = .ypBackground
        field.placeholder = "Поиск"
        field.returnKeyType = .done
        // Для работы поиска и отображения соотв коллекций - объявляем делегат
        field.delegate = self
        return field
    }()
    
    // Создаем картинку-заглушку для пустой коллекции
    private lazy var placeholderImage: UIImageView = {
        let image = UIImage(named: "EmptyCollectionIcon")
        let emptyCollectionIcon = UIImageView(image: image)
        return emptyCollectionIcon
    }()
    
    // Подпись под картинкой-заглушкой
    private lazy var placeholderLabel: UILabel = {
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
        
        // Обновляем данные в зависимости от наличия трекеров и даты
        reloadData()
        
        // Отслеживаем изменения значения пикера
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        // Отслеживаем изменения в поисковой строке и выдаем трекеры в реальном времени
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        
        // Создаем Нотификатор для сигнала об отмене создания трекера и закрытии всех модальных экранов
        NotificationCenter.default.addObserver(self, selector: #selector(closeAllModalViewControllers),
                                               name: Notification.Name("CloseAllModals"), object: nil)
        
        // Отображаем коллекцию и другие UI элементы
        addSubviews()
        
        // Устанавливаем кнопки в NavigationBar
        if let navBar = navigationController?.navigationBar {
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
            addButton.style = .done
            addButton.tintColor = .ypBlack
            navBar.topItem?.setLeftBarButton(addButton, animated: false)
            
            let datePickerButton = UIBarButtonItem(customView: datePicker)
            navBar.topItem?.setRightBarButton(datePickerButton, animated: false)
        }
        
        trackerCategoryStore.delegate = self
        trackerRecordStore.delegate = self
        completedTrackers = trackerRecordStore.trackerRecords
    }
    
    // Задаем клик на кнопку + в навбаре
    @objc private func addButtonTapped() {
        Analytics.shared.tapButton(on: "Main", itemType: .addTrack)
        
        let modalVC = AddTrackerViewController()
        modalVC.modalTransitionStyle = .coverVertical
        present(modalVC, animated: true)
    }
    
    // Задаем закрытие всех модальных экранов в случае отмены создания трекера
    @objc private func closeAllModalViewControllers() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // По ID проверяем завершен ли трекер именно сегодня
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
    }
    
    // Метод для сравнения записей о трекере
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date,
                                                inSameDayAs: datePicker.date)
        return trackerRecord.trackerId == id && isSameDay
    }
    
    private func reloadData() {
        dateChanged()
    }
    
    @objc private func newTrackerCreated() {
        reloadData()
    }
    
    // При изменении даты производим фильтрацию массива VisibleCategories по weekday.numberValue
    @objc private func dateChanged() {
        currentDate = datePicker.date
        reloadVisibleCategories()
    }
    
    @objc private func searchTextChanged() {
        reloadVisibleCategories()
    }
    
    // При изменении даты и с учетом поиска производим фильтрацию массива VisibleCategories
    // по weekDay.numberValue и searchTextField
    private func reloadVisibleCategories() {
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: currentDate)
        let filterText = (searchTextField.text ?? "").lowercased() // Уходим от зависимости от регистра и переводим в lowercased
        
        // Для исправления бага с отображением заголовка для пустой секции...
        // ...Пользуемся методом compactMap, который как бы "проглатывает малое внутри себя"
        let categories = trackerCategoryStore.trackerCategories
        visibleCategories = categories.compactMap { category -> TrackerCategory? in
            let categoryTrackers = category.trackers
            let trackers = categoryTrackers.filter { tracker in
                
                // Условие по тексту в поиске
                let textCondition = filterText.isEmpty || // Если поле пустое, то отображаем в любом случае
                    tracker.title.lowercased().contains(filterText) // Если не пустое, то сверяем текст из поля с текстом из трекера
                
                // Условие по дате в datePicker'е
                var dateCondition: Bool {
                    guard !(tracker.schedule ?? []).isEmpty else {
                        let calendar = Calendar.current
                        let currentSelectedDay = calendar.dateComponents([.year, .month, .day], from: currentDate)
                        let trackerCreationDate = calendar.dateComponents([.year, .month, .day], from: tracker.date)
                        return currentSelectedDay == trackerCreationDate
                    }
                    return tracker.schedule?.contains { weekDay in
                        weekDay.rawValue == filterWeekDay
                    } == true
                }
                
                // Сверяемся с двумя условиями и возвращаем их
                return textCondition && dateCondition
            }
            
            // ...А также если категория пуста - пропускаем ее
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(
                header: category.header,
                trackers: trackers
            )
        }
        // Перезагружаем коллекцию в соответствии с результатом
        trackerCollectionView.reloadData()
        reloadPlaceholder()
    }
    
    // Отображаем плейсхолдер если трекеров еще нет
    private func reloadPlaceholder() {
        if trackerCategoryStore.trackerCategories.isEmpty {
                placeholderImage.isHidden = false
                placeholderLabel.isHidden = false
            } else if visibleCategories.isEmpty {
                placeholderImage.isHidden = false
                placeholderLabel.isHidden = false
                placeholderLabel.text = "На этот день задач нет"
            } else {
                placeholderImage.isHidden = true
                placeholderLabel.isHidden = true
            }
    }
    
    // MARK: - UI ELEMENTS LAYOUT
    
    private func addSubviews() {
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        placeholderImage.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainLabel)
        view.addSubview(searchTextField)
        view.addSubview(trackerCollectionView)
        view.addSubview(placeholderImage)
        view.addSubview(placeholderLabel)
        
        // Задаем делегата и датасоурс для коллекции
        trackerCollectionView.dataSource = self
        trackerCollectionView.delegate = self
        
        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            placeholderImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImage.bottomAnchor, constant: 8),
            placeholderLabel.centerXAnchor.constraint(equalTo: placeholderImage.centerXAnchor),
            
            trackerCollectionView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 10),
            trackerCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            trackerCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackerCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

// MARK: - EXTENSIONS

// Экстенш для корректной работы поисковой строки
extension TrackersViewController: UITextFieldDelegate {
    
    // Метод который работает по кнопке Готово (done) и возвращает результат
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder() // скрывает текстфилд
        
        reloadVisibleCategories()
        
        return true // Возвращаем совершение действия (можно отменять, но это сейчас не нужно)
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func completeTracker(id: UUID, at indexPath: IndexPath) {
        
        // Сравниваем две даты напрямую без учета времени
        let currentDate = Calendar.current.startOfDay(for: Date()) // Текущая дата
        let datePickerDate = Calendar.current.startOfDay(for: datePicker.date) // Дата из пикера
        
        // Храним на этом экране выбранную в календарике дату
        // И сравниваем тут эти две даты, если выбранная дата больше
        // Чем текущая, то не вызывать код ниже
        if currentDate < datePickerDate {
            let alertController = UIAlertController(title: "Ой, мы в будущем!", message: "Невозможно отметить этой датой", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "ОК", style: .default))
            self.present(alertController, animated: true, completion: nil)
            return
        } else {
            let trackerRecord = TrackerRecord(trackerId: id, date: datePicker.date)
            try? trackerRecordStore.addNewTrackerRecord(trackerRecord)
        }
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.forEach {
            if isSameTrackerRecord(trackerRecord: $0, id: id) {
                try? trackerRecordStore.removeTrackerRecord($0)
            }
        }
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    // Возвращаем коллекции количество секций
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return visibleCategories.count
    }
    
    // Возвращаем коллекции количество элементов в секции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let trackers = visibleCategories[section].trackers
        return trackers.count
    }
    
    // Создаем ячейку для отображения на экране
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! TrackerCell
        
        let cellData = visibleCategories
        let tracker = cellData[indexPath.section].trackers[indexPath.item]
        
        cell.delegate = self
        
        // Передаем значение того завершен ли трекер сегодня
        let isCompletedToday = isTrackerCompletedToday(id: tracker.id)
        // Считаем сколько записей хранится в выполненных трекерах с конкретным ID
        let completedDays = completedTrackers.filter { $0.trackerId == tracker.id }.count
        cell.configure(
            with: tracker,
            isCompletedToday: isCompletedToday,
            completedDays: completedDays,
            indexPath: indexPath)
        
        return cell
    }
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
            headerView.titleLabel.text = visibleCategories[indexPath.section].header
            return headerView
        default:
            assert(false, "Invalid element type for SupplementaryElement")
        }
    }
}

// MARK: - TrackerCategoryStoreDelegate
extension TrackersViewController: TrackerCategoryStoreDelegate {
    func storeCategoriesDidUpdate(_ store: TrackerCategoryStore) {
        reloadData()
    }
}

// MARK: - TrackerRecordStoreDelegate
extension TrackersViewController: TrackerRecordStoreDelegate {
    func storeRecordsDidUpdate(_ store: TrackerRecordStore) {
        completedTrackers = store.trackerRecords
        reloadData()
    }
}


