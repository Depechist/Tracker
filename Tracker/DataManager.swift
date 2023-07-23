//
//  DataManager.swift
//  Tracker
//
//  Created by Artem Adiev on 13.07.2023.
//

import Foundation

final class DataManager {
    
    // Создаем синглтон
    static let shared = DataManager()
    
    // Приватный инициализатор, чтобы предотвратить создание более одного экземпляра
    private init() {}
    
    // Массив с моковыми данными
    var categories: [TrackerCategory] = [
        TrackerCategory(title: "Домашний уют", trackers:
                            [Tracker(id: UUID(), date: Date(), emoji: "❤️", title: "Поливать растения", color: .colorSelection5, dayCount: 1, schedule: [.monday])]),

        TrackerCategory(title: "Радостные мелочи", trackers:
                            [Tracker(id: UUID(), date: Date(), emoji: "😻", title: "Кошка заслонила камеру на созвоне", color: .colorSelection2, dayCount: 5, schedule: [.monday, .sunday, .thursday]),
                             Tracker(id: UUID(), date: Date(), emoji: "🌺", title: "Бабушка прислала открытку в вотсаппе", color: .colorSelection1, dayCount: 4, schedule: [.wednesday, .thursday, .saturday]),
                             Tracker(id: UUID(), date: Date(), emoji: "❤️", title: "Свидания в апреле", color: .colorSelection14, dayCount: 5, schedule: [.monday, .friday])
                            ])
    ]
}


