//
//  DataManager.swift
//  Tracker
//
//  Created by Artem Adiev on 13.07.2023.
//

import Foundation
import UIKit

final class DataManager {
    
    // Создаем синглтон
    static let shared = DataManager()
    
    // Приватный инициализатор, чтобы предотвратить создание более одного экземпляра
    private init() {}
    
    // Массив с эмодзи для создания трекеров
    let emojis: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶", "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝", "😪"]
    
    // Массив с цветами для создания трекеров
    let colors = [UIColor.colorSelection1, UIColor.colorSelection2, UIColor.colorSelection3, UIColor.colorSelection4,
                  UIColor.colorSelection5, UIColor.colorSelection6, UIColor.colorSelection7, UIColor.colorSelection8,
                  UIColor.colorSelection9, UIColor.colorSelection10, UIColor.colorSelection11, UIColor.colorSelection12,
                  UIColor.colorSelection13, UIColor.colorSelection14, UIColor.colorSelection15, UIColor.colorSelection16,
                  UIColor.colorSelection17, UIColor.colorSelection18]
}


