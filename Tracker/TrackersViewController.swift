//
//  ViewController.swift
//  Tracker
//
//  Created by Artem Adiev on 15.06.2023.
//

// MARK: ГЛАВНЫЙ ЭКРАН

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
    
    // Объявляем синглтон с моковыми данными
    private let dataManager = DataManager.shared
    
    // Массив со всеми созданными трекерами
    private var categories: [TrackerCategory] = []
    
    // Массив с видимыми на экране трекерами
    private var visibleCategories: [TrackerCategory] = []
    
    // Хранилище записей завершенных трекеров
    private var completedTrackers: [TrackerRecord] = []
    
    // Заголовки для секций (хедеры)
    private var sectionTitles = ["Домашний уют", "Радостные мелочи"]
    
    // MARK: - UI ELEMENTS
    
    // Создаем экземпляр коллекции
    var trackerCollectionView: UICollectionView = {
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
    
//    private var dateLabel: UILabel {
//        let label = UILabel()
//        label.backgroundColor = .ypBackground
//        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
//        label.textAlignment = .center
//        label.clipsToBounds = true
//        label.layer.cornerRadius = 16
//        label.layer.zPosition = 10
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }
//
//    private var datePicker: UIDatePicker {
//        let picker = UIDatePicker()
//        picker.preferredDatePickerStyle = .compact
//        picker.datePickerMode = .date
//        picker.locale = Locale(identifier: "ru_Ru")
//        picker.calendar.firstWeekday = 2
//        picker.clipsToBounds = true
//        picker.layer.cornerRadius = 16
//        picker.translatesAutoresizingMaskIntoConstraints = false
//        return picker
//    }
    
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
        
        // Обновляем данные в зависимости от наличия трекеров и даты
        reloadData()
        
        // Отслеживаем изменения значения пикера
        datePicker.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        // Отслеживаем изменения в поисковой строке и выдаем трекеры в реальном времени
        searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        
        // Создаем Нотификатор для сигнала об отмене создания трекера и закрытии всех модальных экранов
        NotificationCenter.default.addObserver(self, selector: #selector(closeAllModalViewControllers),
                                               name: Notification.Name("CloseAllModals"), object: nil)
        
        // Устанавливаем фон для экрана
        view.backgroundColor = .ypWhite
        
        // Отображаем коллекцию и другие UI элементы
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
    
    // Задаем клик на кнопку + в навбаре
    @objc func addButtonTaped() {
        let modalVC = AddTrackerViewController()
        modalVC.modalTransitionStyle = .coverVertical
        present(modalVC, animated: true)
    }
    
    // Задаем закрытие всех модальных экранов в случае отмены создания трекера
    @objc func closeAllModalViewControllers() {
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
        categories = dataManager.categories
        dateChanged()
    }
    
    // При изменении даты производим фильтрацию массива VisibleCategories по weekday.numberValue
    @objc private func dateChanged() {
//        updateDateLabelTitle(with: datePicker.date) // Исправляет datePicker при смене даты (альт. datePicker)
        reloadVisibleCategories()
    }
    
    @objc private func searchTextChanged() {
        reloadVisibleCategories()
    }
    
    // При изменении даты и с учетом поиска производим фильтрацию массива VisibleCategories
    // по weekDay.numberValue и searchTextField
    private func reloadVisibleCategories() {
        let calendar = Calendar.current
        let filterWeekDay = calendar.component(.weekday, from: datePicker.date)
        let filterText = (searchTextField.text ?? "").lowercased() // Уходим от зависимости от регистра и переводим в lowercased
        
        // Для исправления бага с отображением заголовка для пустой секции...
        // ...Пользуемся методом compactMap, который как бы "проглатывает малое внутри себя"
        visibleCategories = categories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                // Условие по тексту в поиске
                let textCondition = filterText.isEmpty || // Если поле пустое, то отображаем в любом случае
                    tracker.text.lowercased().contains(filterText) // Если не пустое, то сверяем текст из поля с текстом из трекера
                // Условие по дате в datePicker'е
                let dateCondition = tracker.shedule?.contains { weekDay in
                    weekDay.numberValue == filterWeekDay
                } == true
                
                // Сверяемся с двумя условиями и возвращаем их
                return textCondition && dateCondition
            }
            
            // ...А также если категория пуста - пропускаем ее
            if trackers.isEmpty {
                return nil
            }
            
            return TrackerCategory(
                title: category.title,
                trackers: trackers
            )
        }
        // Перезагружаем коллекцию в соответствии с результатом
        trackerCollectionView.reloadData()
        reloadPlaceholder()
    }
    
    // Отображаем плейсхолдер если трекеров еще нет
    private func reloadPlaceholder() {
        if !categories.isEmpty {
            placeholderImage.isHidden = true
            placeholderLabel.isHidden = true
        } else if visibleCategories.isEmpty { // TODO: Условие не работает, плейсхолдер не отображается.
            placeholderImage.isHidden = false
            placeholderLabel.isHidden = false
            placeholderLabel.text = "На сегодня задач нет"
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
        let trackerRecord = TrackerRecord(trackerId: id, date: datePicker.date)
        completedTrackers.append(trackerRecord)
        trackerCollectionView.reloadItems(at: [indexPath])
    }
    
    func uncompleteTracker(id: UUID, at indexPath: IndexPath) {
        completedTrackers.removeAll { trackerRecord in
            isSameTrackerRecord(trackerRecord: trackerRecord, id: id)
        }
        trackerCollectionView.reloadItems(at: [indexPath])
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

//extension TrackersViewController: UICollectionViewDelegate {
//
//}

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

