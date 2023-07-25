//
//  EmojiCollectionView.swift
//  Tracker
//
//  Created by Artem Adiev on 25.07.2023.
//

// MARK: КОЛЛЕКЦИЯ ДЛЯ ВЫБОРА ЭМОДЗИ

import UIKit

final class EmojiCollectionView: UICollectionView {
    
    var dataManager = DataManager.shared
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        dataSource = self
        delegate = self
        
        backgroundColor = .clear
        allowsMultipleSelection = false
        isScrollEnabled = false
        clipsToBounds = false
        
        // Регистрация класса ячейки и класса хедера для дальнейшего использования
        register(EmojiCell.self, forCellWithReuseIdentifier: "emojiCell")
        register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataSource

extension EmojiCollectionView: UICollectionViewDataSource {
    // Устанавливаем количество элементов в разделе как количество эмодзи в DataManager
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.emojis.count
    }
    // Устанавливаем отображение каждой ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCell", for: indexPath) as! EmojiCell
        cell.emojiLabel.text = dataManager.emojis[indexPath.row]
        return cell
    }
}

// MARK: - DelegateFlowLayout

extension EmojiCollectionView: UICollectionViewDelegateFlowLayout {
    // Задаем отступы для всей секции
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0.0, left: 18.0, bottom: 0.0, right: 18.0)
    }
    
    // Высота заголовка
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50) // Высота хедера
    }
    
    // Устанавливаем представление для вспомогательных элементов (хедера)
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: "header",
                                                                             for: indexPath) as! SectionHeader
            // Устанавливаем заголовок для каждой секции
            headerView.titleLabel.text = "Emoji"
            return headerView
            
        default:
            assert(false, "Invalid element type for SupplementaryElement")
        }
    }
    
    // Устанавливаем размеры для ячеек
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    // Устанавливаем минимальное расстояние между элементами внутри одной строки
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    // Устанавливаем минимальное расстояние между строками
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
