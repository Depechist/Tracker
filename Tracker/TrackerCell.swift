//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Artem Adiev on 02.07.2023.
//

// MARK: КЛАСС ЯЧЕЙКИ ТРЕКЕРОВ

import UIKit

// Протокол для обработки нажатия на кнопку ячейки
protocol TrackerCellDelegate: AnyObject {
    func completeTracker(id: UUID, at indexPath: IndexPath)
    func uncompleteTracker(id: UUID, at indexPath: IndexPath)
}

final class TrackerCell: UICollectionViewCell {
    
    // Объявляем делегата обработки нажатия кнопки ячейки
    weak var delegate: TrackerCellDelegate?
    
    // Свойство для сохранения статуса трекера (завершено / не завершено)
    private var isCompletedToday: Bool = false
    
    // Свойство для сохранения ID трекера
    private var trackerId: UUID?
    
    // Заводим свойство для использования в методе configure()
    private var indexPath: IndexPath?
    
    // MARK: - UI ELEMENTS
    
    // Верхняя часть ячейки
    private var upperView: UIView = {
        let view = UIView()
        view.backgroundColor = .colorSelection14
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Нижняя часть ячейки
    private var lowerView: UIView = {
        let view = UIView()
        view.backgroundColor = .ypWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Лейбл для эмодзи
    private var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // UIView для эмодзи
    private var emojiBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ypWhite.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Лейбл теста на трекере
    private var trackerText: UITextView = {
        let text = UITextView()
        text.textColor = .ypWhite
        text.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        text.backgroundColor = .clear
        text.isScrollEnabled = false
        text.textContainerInset = UIEdgeInsets.zero
        text.textContainer.lineFragmentPadding = 0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    // Счетчик дней под трекером
    private var dayCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .ypBlack
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // Кнопка +/- под трекером
    private var plusButton: UIButton = {
        let button = UIButton()
        let templateImage = UIImage(named: "PlusButton")?.withRenderingMode(.alwaysTemplate)
        button.setImage(templateImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Картинка для кнопки + под трекером
    private var plusImage: UIImage = {
        let image = UIImage(named: "PlusButton")?.withRenderingMode(.alwaysTemplate) ?? UIImage()
        return image
    }()
    
    // Картинка для кнопки done под трекером
    private var doneImage: UIImage = {
        let image = UIImage(named: "DoneButton") ?? UIImage()
        return image
    }()
    
    // Метод для "собирания" ячейки
    func configure(with tracker: Tracker, isCompletedToday: Bool, completedDays: Int, indexPath: IndexPath) {
        self.trackerId = tracker.id
        self.isCompletedToday = isCompletedToday
        self.indexPath = indexPath
        
        let color = tracker.color
    
        upperView.backgroundColor = color
        plusButton.tintColor = color
        trackerText.text = tracker.title
        emojiLabel.text = tracker.emoji
        
        let wordDay = pluralizeDays(completedDays)
        dayCountLabel.text = "\(wordDay)"
        
        let image = isCompletedToday ? doneImage : plusImage
        plusButton.setImage(image, for: .normal)
    }
    
    // Метод для определения написания количества дней (день / дня / дней)
    private func pluralizeDays(_ count: Int) -> String {
        let remainder10 = count % 10
        let remainder100 = count % 100
        
        if remainder10 == 1 && remainder100 != 11 {
            return "\(count) день"
        } else if remainder10 >= 2 && remainder10 <= 4 && (remainder100 < 100 || remainder100 >= 20) {
            return "\(count) дня"
        } else {
            return "\(count) дней"
        }
    }
    
    // Отслеживаем нажатие на кнопку под трекером
    @objc private func plusButtonTapped() {
        Analytics.shared.tapButton(on: "Main", itemType: .track)
        
        guard let trackerId = trackerId, let indexPath = indexPath else { return }
        if isCompletedToday {
            delegate?.uncompleteTracker(id: trackerId, at: indexPath)
        } else {
            delegate?.completeTracker(id: trackerId, at: indexPath)
        }
    }
    
    // MARK: - UI ELEMENTS LAYOUT
    
    // Инициализатор для настройки ячейки
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)

        contentView.addSubview(upperView)
        contentView.addSubview(lowerView)
        upperView.addSubview(emojiBackgroundView)
        upperView.addSubview(emojiLabel)
        upperView.addSubview(trackerText)
        lowerView.addSubview(dayCountLabel)
        lowerView.addSubview(plusButton)
        
        NSLayoutConstraint.activate([
            upperView.topAnchor.constraint(equalTo: contentView.topAnchor),
            upperView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            upperView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            upperView.heightAnchor.constraint(equalToConstant: 90),
            
            lowerView.topAnchor.constraint(equalTo: upperView.bottomAnchor),
            lowerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            lowerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            lowerView.heightAnchor.constraint(equalToConstant: 58),
            
            emojiBackgroundView.topAnchor.constraint(equalTo: upperView.topAnchor, constant: 12),
            emojiBackgroundView.leadingAnchor.constraint(equalTo: upperView.leadingAnchor, constant: 12),
            emojiBackgroundView.widthAnchor.constraint(equalToConstant: 24),
            emojiBackgroundView.heightAnchor.constraint(equalToConstant: 24),

            emojiLabel.centerXAnchor.constraint(equalTo: emojiBackgroundView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiBackgroundView.centerYAnchor),
            
            trackerText.topAnchor.constraint(equalTo: upperView.topAnchor, constant: 44),
            trackerText.leadingAnchor.constraint(equalTo: upperView.leadingAnchor, constant: 12),
            trackerText.trailingAnchor.constraint(equalTo: upperView.trailingAnchor, constant: -12),
            trackerText.bottomAnchor.constraint(equalTo: upperView.bottomAnchor, constant: -12),
            trackerText.widthAnchor.constraint(equalToConstant: 143),
            trackerText.heightAnchor.constraint(equalToConstant: 34),
            
            dayCountLabel.centerYAnchor.constraint(equalTo: lowerView.centerYAnchor),
            dayCountLabel.leadingAnchor.constraint(equalTo: lowerView.leadingAnchor, constant: 10),
            
            plusButton.centerYAnchor.constraint(equalTo: lowerView.centerYAnchor),
            plusButton.trailingAnchor.constraint(equalTo: lowerView.trailingAnchor, constant: -10),
        ])
        
        // Цвет ячейки
        upperView.backgroundColor = .colorSelection14
        // Закругляем края ячейки
        upperView.layer.cornerRadius = 16
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


