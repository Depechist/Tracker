//
//  ColorCollectionView.swift
//  Tracker
//
//  Created by Artem Adiev on 25.07.2023.
//

import UIKit

// CollectionView для выбора цвета
let colorCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "colorCell")
    collectionView.backgroundColor = .clear
    collectionView.allowsMultipleSelection = false
    collectionView.isScrollEnabled = false
    
    collectionView.register(SectionHeader.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                            withReuseIdentifier: "header")
    
    return collectionView
}()
