//
//  TrackerCollectionViewCell.swift
//  Tracker
//
//  Created by Artem Adiev on 02.07.2023.
//

// MARK: КЛАСС И СТРУКТУРЫ ТРЕКЕРОВ

import UIKit

final class TrackerCollectionViewCell: UICollectionViewCell {
    
    // MARK: - UI ELEMENTS
    
    // Верхняя часть ячейки
    var upperView: UIView = {
        let view = UIView()
        view.backgroundColor = .colorSelection14
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Нижняя часть ячейки
    var lowerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Лейбл для эмодзи
    var emojiLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // UIView для эмодзи
    var emojiBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ypWhite.withAlphaComponent(0.3)
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // Лейбл теста на трекере
    var trackerText: UITextView = {
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
    var dayCountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Кнопка +/- под трекером
    var actionButton: UIButton = {
        let button = UIButton()
        let templateImage = UIImage(named: "PlusButton")?.withRenderingMode(.alwaysTemplate)
        button.setImage(templateImage, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - UI ELEMENTS LAYOUT
    
    // Инициализатор для настройки ячейки
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(upperView)
        contentView.addSubview(lowerView)
        upperView.addSubview(emojiBackgroundView)
        upperView.addSubview(emojiLabel)
        upperView.addSubview(trackerText)
        lowerView.addSubview(dayCountLabel)
        lowerView.addSubview(actionButton)
        
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
            
            actionButton.centerYAnchor.constraint(equalTo: lowerView.centerYAnchor),
            actionButton.trailingAnchor.constraint(equalTo: lowerView.trailingAnchor, constant: -10),
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

    // MARK: - TRACKER STRUCTURES

struct Tracker {
    let emoji: String
    let text: String
    let backgroundColor: UIColor
    let buttonColor: UIColor
    let dayCount: String
    
    init(emoji: String, text: String, backgroundColor: UIColor, buttonColor: UIColor, dayCount: String) {
        self.emoji = emoji
        self.text = text
        self.backgroundColor = backgroundColor
        self.buttonColor = buttonColor
        self.dayCount = dayCount
    }
}

struct TrackerCategory {
    
}

struct TrackerRecord {
    
}
