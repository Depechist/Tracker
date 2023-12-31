//
//  ColorCollectionView.swift
//  Tracker
//
//  Created by Artem Adiev on 25.07.2023.
//

// MARK: КОЛЛЕКЦИЯ ДЛЯ ВЫБОРА ЦВЕТА

import UIKit

final class ColorCollectionView: UICollectionView {
    
    var dataManager = DataManager.shared
    var selectedColor: UIColor?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        
        dataSource = self
        delegate = self
        
        backgroundColor = .clear
        allowsMultipleSelection = false
        isScrollEnabled = false
        clipsToBounds = false
        
        register(ColorCell.self, forCellWithReuseIdentifier: "colorCell")
        register(SectionHeader.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "header")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - DataSource

extension ColorCollectionView: UICollectionViewDataSource {
    // Устанавливаем количество элементов в разделе как количество эмодзи в DataManager
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataManager.colors.count
    }
    
    // Устанавливаем отображение каждой ячейки
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCell
        cell.contentView.backgroundColor = UIColor.clear
        cell.innerView.backgroundColor = dataManager.colors[indexPath.row]
        return cell
    }
}

// MARK: - DelegateFlowLayout

extension ColorCollectionView: UICollectionViewDelegateFlowLayout {
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
            headerView.titleLabel.text = "Цвет"
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ColorCell
        selectedColor = cell.innerView.backgroundColor
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let color = dataManager.colors[indexPath.row]
        let isSelected = color.hexString() == selectedColor?.hexString()
        if isSelected {
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .bottom)
            cell.contentView.layer.borderColor = isSelected ? color.cgColor.copy(alpha: 0.3) : UIColor.clear.cgColor
        }
    }
}
