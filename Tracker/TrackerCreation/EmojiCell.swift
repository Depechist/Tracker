//
//  EmojiCell.swift
//  Tracker
//
//  Created by Artem Adiev on 23.07.2023.
//

// MARK: ЯЧЕЙКА ДЛЯ КОЛЛЕКЦИИ ВЫБОРА ЭМОДЗИ

import UIKit

final class EmojiCell: UICollectionViewCell {
    // UILabel, который будет отображать эмодзи
    var emojiLabel: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        // Закругляем углы для рамки
        contentView.layer.cornerRadius = 16
        
        // UILabel с рамкой, совпадающей с рамкой contentView
        emojiLabel = UILabel(frame: contentView.bounds)
        
        emojiLabel.textAlignment = .center
        emojiLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        contentView.addSubview(emojiLabel)
    }
    
    // Переопределение свойства isSelected
    override var isSelected: Bool {
        didSet {
            // Установка цвета фона contentView в серый, когда ячейка выбрана, и в прозрачный, когда выделение снимается
            contentView.backgroundColor = isSelected ? UIColor.ypLightGray : UIColor.clear
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
