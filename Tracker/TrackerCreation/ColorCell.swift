//
//  ColorCell.swift
//  Tracker
//
//  Created by Artem Adiev on 23.07.2023.
//

// MARK: ЯЧЕЙКА ДЛЯ КОЛЛЕКЦИИ ВЫБОРА ЦВЕТА

import UIKit

final class ColorCell: UICollectionViewCell {
    // Внутренний квадрат для отображения цвета
    let innerView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 8 // Закругление углов контента ячейки
        contentView.layer.borderWidth = 2 // Установка толщины рамки контента
        contentView.layer.borderColor = UIColor.clear.cgColor // Установка цвета рамки (прозрачный)
        contentView.clipsToBounds = true // Обрезка контента по границам контента ячейки
        
        innerView.translatesAutoresizingMaskIntoConstraints = false // Отключение автоматического создания ограничений
        contentView.addSubview(innerView) // Добавление innerView в контент ячейки
        
        NSLayoutConstraint.activate([
            innerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            innerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            innerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            innerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
        
        innerView.layer.cornerRadius = 8 // Закругление углов innerView
        innerView.clipsToBounds = true // Обрезка контента по границам innerView
    }
    
    // Изменение цвета рамки контента при выборе ячейки
    override var isSelected: Bool {
        didSet {
            contentView.layer.borderColor = isSelected ? innerView.backgroundColor?.cgColor.copy(alpha: 0.3) : UIColor.clear.cgColor
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
