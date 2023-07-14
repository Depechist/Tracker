//
//  DataManager.swift
//  Tracker
//
//  Created by Artem Adiev on 10.07.2023.
//

import UIKit

struct Tracker {
    let id: UUID
    let date: Date
    let emoji: String
    let title: String
    let color: UIColor
    let dayCount: Int
    let schedule: [WeekDay]?
    
    init(id: UUID, date: Date, emoji: String, text: String, color: UIColor, dayCount: Int, schedule: [WeekDay]) {
        self.id = id
        self.date = date
        self.emoji = emoji
        self.title = text
        self.color = color
        self.dayCount = dayCount
        self.schedule = schedule
    }
}

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
    
    init(title: String, trackers: [Tracker]) {
        self.title = title
        self.trackers = trackers
    }
}

struct TrackerRecord {
    let trackerId: UUID
    let date: Date
    
    init(trackerId: UUID, date: Date) {
        self.trackerId = trackerId
        self.date = date
    }
}

enum WeekDay: Int {
    case sunday = 1 // Согласно системе в Calendar, воскресенье - это 1
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    
    // Вычисляемое свойство, которое возвращает rawValue текущего дня недели
    var numberValue: Int {
        return self.rawValue
    }
}
